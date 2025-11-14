import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/establishment.dart';
import '../../services/geo_service.dart';
import '../../services/supabase_client.dart';
import '../../widgets/establishment_card/establishment_card.dart';
import '../../providers/auth/auth_provider.dart';

// Provider para busca de estabelecimentos
final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<Establishment>>>((ref) {
  return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<AsyncValue<List<Establishment>>> {
  final Ref ref;
  SearchNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    try {
      final client = SupabaseClientService.client;
      final results = await client.from('establishments').select().limit(20);
      final establishments = (results as List)
          .map((e) => Establishment.fromJson(e))
          .toList();
      state = AsyncValue.data(establishments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> search({
    String? query,
    String? type,
    bool? useGeo,
    bool? b2bOnly,
  }) async {
    state = const AsyncValue.loading();
    try {
      final auth = ref.read(authProvider);
      final isPartner = auth.value?.role == 'partner';

      List<Map<String, dynamic>> results;

      if (useGeo == true) {
        // Busca com geolocalização
        final location = await GeoService.getCurrentLocation();
        if (location != null) {
          results = await GeoService.searchNearbyEstablishments(
            latitude: location.latitude,
            longitude: location.longitude,
            type: type,
            b2bOnly: b2bOnly ?? (isPartner ? true : false),
          );
        } else {
          // Fallback: busca sem geo
          results = await _searchWithoutGeo(query: query, type: type, b2bOnly: b2bOnly);
        }
      } else {
        // Busca sem geolocalização
        results = await _searchWithoutGeo(query: query, type: type, b2bOnly: b2bOnly);
      }

      final establishments = results
          .map((e) => Establishment.fromJson(e))
          .toList();

      state = AsyncValue.data(establishments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<Map<String, dynamic>>> _searchWithoutGeo({
    String? query,
    String? type,
    bool? b2bOnly,
  }) async {
    var queryBuilder = SupabaseClientService.client.from('establishments').select();

    if (query != null && query.isNotEmpty) {
      queryBuilder = queryBuilder.ilike('name', '%$query%');
    }

    if (type != null && type.isNotEmpty) {
      queryBuilder = queryBuilder.eq('type', type);
    }

    final results = await queryBuilder;
    final list = List<Map<String, dynamic>>.from(results);

    // Filtrar B2B se necessário
    if (b2bOnly == true) {
      return list.where((e) {
        final services = e['services_json'] as Map<String, dynamic>?;
        return services?['b2b'] == true;
      }).toList();
    }

    return list;
  }
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String? _selectedType;
  bool _useGeo = false;
  bool _b2bOnly = false;

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authProvider);
    _b2bOnly = auth.value?.role == 'partner';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    ref.read(searchProvider.notifier).search(
          query: _searchController.text.trim().isEmpty
              ? null
              : _searchController.text.trim(),
          type: _selectedType,
          useGeo: _useGeo,
          b2bOnly: _b2bOnly,
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchProvider);
    final auth = ref.watch(authProvider);
    final isPartner = auth.value?.role == 'partner';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
      ),
      body: Column(
        children: [
          // Barra de busca e filtros
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar estabelecimentos...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
                const SizedBox(height: 12),
                // Filtros
                Wrap(
                  spacing: 8,
                  children: [
                    // Tipo
                    DropdownButton<String>(
                      value: _selectedType,
                      hint: const Text('Tipo'),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Todos')),
                        DropdownMenuItem(value: 'restaurant', child: Text('Restaurante')),
                        DropdownMenuItem(value: 'bar', child: Text('Bar')),
                        DropdownMenuItem(value: 'hotel', child: Text('Hotel')),
                        DropdownMenuItem(value: 'event', child: Text('Evento')),
                        DropdownMenuItem(value: 'supplier', child: Text('Fornecedor')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedType = value);
                        _performSearch();
                      },
                    ),
                    // Geolocalização
                    FilterChip(
                      label: const Text('📍 Próximo'),
                      selected: _useGeo,
                      onSelected: (selected) {
                        setState(() => _useGeo = selected);
                        _performSearch();
                      },
                    ),
                    // B2B (apenas para partners)
                    if (isPartner)
                      FilterChip(
                        label: const Text('B2B'),
                        selected: _b2bOnly,
                        onSelected: (selected) {
                          setState(() => _b2bOnly = selected);
                          _performSearch();
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Resultados
          Expanded(
            child: searchAsync.when(
              data: (establishments) {
                if (establishments.isEmpty) {
                  return const Center(
                    child: Text('Nenhum estabelecimento encontrado'),
                  );
                }
                return ListView.builder(
                  itemCount: establishments.length,
                  itemBuilder: (context, index) {
                    final est = establishments[index];
                    // Extrair distância se disponível
                    double? distance;
                    // TODO: Extrair distance_km se vier da busca geo
                    return EstablishmentCard(
                      establishment: est,
                      distanceKm: distance,
                      onTap: () {
                        // TODO: Navegar para perfil do estabelecimento
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erro: $err'),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(searchProvider),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
