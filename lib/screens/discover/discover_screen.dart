import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/supabase_client.dart';
import '../../services/geo_service.dart';

// Provider para eventos populares
final popularEventsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = SupabaseClientService.client;
  
  // Buscar eventos ordenados por engajamento (sold_tickets)
  final results = await client
      .from('events')
      .select('*, establishments(*)')
      .order('sold_tickets', ascending: false)
      .limit(10);

  return List<Map<String, dynamic>>.from(results);
});

// Provider para eventos próximos
final nearbyEventsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final location = await GeoService.getCurrentLocation();
    if (location == null) {
      // Fallback: buscar todos
      final client = SupabaseClientService.client;
      final results = await client
          .from('events')
          .select('*, establishments(*)')
          .order('date', ascending: true)
          .limit(20);
      return List<Map<String, dynamic>>.from(results);
    }

    // Buscar estabelecimentos próximos que têm eventos
    final nearby = await GeoService.searchNearbyEstablishments(
      latitude: location.latitude,
      longitude: location.longitude,
      radiusMeters: 10000, // 10km
    );

    if (nearby.isEmpty) return [];

    final establishmentIds = nearby.map((e) => e['id'] as String).toList();

    final client = SupabaseClientService.client;
    
    // Buscar todos os eventos desses estabelecimentos (Supabase não suporta IN diretamente)
    // Fazer múltiplas queries ou buscar todos e filtrar
    var query = client
        .from('events')
        .select('*, establishments(*)');
    
    final allResults = await query;
    
    final results = (allResults as List)
        .where((event) =>
            establishmentIds.contains(event['establishment_id']))
        .toList()
      ..sort((a, b) => (a['date'] as String?)
          ?.compareTo(b['date'] as String? ?? '') ??
          0);

    return List<Map<String, dynamic>>.from(results);
  } catch (e) {
    return [];
  }
});

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularAsync = ref.watch(popularEventsProvider);
    final nearbyAsync = ref.watch(nearbyEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(popularEventsProvider);
          ref.invalidate(nearbyEventsProvider);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel de eventos populares
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Eventos em Destaque',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              popularAsync.when(
                data: (events) => _buildEventCarousel(events),
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => const SizedBox(
                  height: 200,
                  child: Center(child: Text('Erro ao carregar eventos')),
                ),
              ),
              const SizedBox(height: 24),
              // Lista de eventos próximos
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Eventos Próximos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              nearbyAsync.when(
                data: (events) => _buildEventsList(events),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => const Center(
                  child: Text('Erro ao carregar eventos'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCarousel(List<Map<String, dynamic>> events) {
    if (events.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Nenhum evento em destaque')),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final establishment = event['establishments'] as Map<String, dynamic>?;
          
          return Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.blue[100],
                      child: Center(
                        child: Text(
                          event['name'] ?? 'Evento',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (establishment != null)
                          Text(
                            establishment['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        if (event['date'] != null)
                          Text(
                            'Data: ${event['date']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        if (event['price'] != null)
                          Text(
                            'R\$ ${event['price']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsList(List<Map<String, dynamic>> events) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('Nenhum evento próximo encontrado')),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final establishment = event['establishments'] as Map<String, dynamic>?;
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.event, size: 40),
            title: Text(event['name'] ?? 'Evento'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (establishment != null)
                  Text(establishment['name'] ?? ''),
                if (event['date'] != null)
                  Text('Data: ${event['date']}'),
              ],
            ),
            trailing: event['price'] != null
                ? Text(
                    'R\$ ${event['price']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  )
                : null,
            onTap: () {
              // TODO: Navegar para detalhes do evento
            },
          ),
        );
      },
    );
  }
}
