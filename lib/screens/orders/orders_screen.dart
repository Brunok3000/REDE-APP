import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth/auth_provider.dart';
import '../../models/order.dart';
import '../../services/supabase_client.dart';
import 'package:intl/intl.dart';

// Provider para pedidos do consumidor
final consumerOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final client = SupabaseClientService.client;
  final user = SupabaseClientService.getCurrentUser();
  if (user == null) return [];

  final results = await client
      .from('orders')
      .select()
      .eq('consumer_id', user.id)
      .order('created_at', ascending: false);

  return (results as List).map((o) => OrderModel.fromJson(o)).toList();
});

// Provider para pedidos do parceiro
final partnerOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final client = SupabaseClientService.client;
  final user = SupabaseClientService.getCurrentUser();
  if (user == null) return [];

  // Buscar estabelecimentos do parceiro
  final establishments = await client
      .from('establishments')
      .select('id')
      .eq('owner_id', user.id);

  if (establishments.isEmpty) return [];

  final establishmentIds = (establishments as List)
      .map((e) => e['id'] as String)
      .toList();

  final results = await client
      .from('orders')
      .select()
      .order('created_at', ascending: false);

  // Filtrar localmente por establishment_id
  final ordersForEstablishments = (results as List)
      .where((order) => establishmentIds.contains(order['establishment_id']))
      .toList();

  return ordersForEstablishments.map((o) => OrderModel.fromJson(o)).toList();
});

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider).value;
    final role = auth?.role;
    final isPartner = role == 'partner';

    return Scaffold(
      appBar: AppBar(
        title: Text(isPartner ? 'Gerenciamento de Pedidos' : 'Meus Pedidos'),
      ),
      body: isPartner ? _PartnerOrdersView() : _ConsumerOrdersView(),
    );
  }
}

class _ConsumerOrdersView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(consumerOrdersProvider);

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text('Nenhum pedido ainda'));
        }
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return OrderCard(order: orders[index], isPartner: false);
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
              onPressed: () => ref.invalidate(consumerOrdersProvider),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerOrdersView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(partnerOrdersProvider);

    return ordersAsync.when(
      data: (orders) {
        // Agrupar por status
        final pending = orders.where((o) => o.status == 'pending').toList();
        final preparing = orders.where((o) => o.status == 'preparing').toList();
        final ready = orders.where((o) => o.status == 'ready').toList();

        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Pendentes', icon: Icon(Icons.pending)),
                  Tab(text: 'Preparando', icon: Icon(Icons.restaurant)),
                  Tab(text: 'Prontos', icon: Icon(Icons.check_circle)),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _OrdersList(orders: pending, isPartner: true),
                    _OrdersList(orders: preparing, isPartner: true),
                    _OrdersList(orders: ready, isPartner: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Erro: $err'),
            ElevatedButton(
              onPressed: () => ref.invalidate(partnerOrdersProvider),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final List<OrderModel> orders;
  final bool isPartner;

  const _OrdersList({required this.orders, required this.isPartner});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(child: Text('Nenhum pedido nesta categoria'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(order: orders[index], isPartner: isPartner);
      },
    );
  }
}

class OrderCard extends ConsumerWidget {
  final OrderModel order;
  final bool isPartner;

  const OrderCard({super.key, required this.order, required this.isPartner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColors = {
      'pending': Colors.orange,
      'accepted': Colors.blue,
      'rejected': Colors.red,
      'preparing': Colors.purple,
      'ready': Colors.green,
      'delivered': Colors.grey,
    };

    final statusLabels = {
      'pending': 'Pendente',
      'accepted': 'Aceito',
      'rejected': 'Rejeitado',
      'preparing': 'Preparando',
      'ready': 'Pronto',
      'delivered': 'Entregue',
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColors[order.status] ?? Colors.grey,
          child: Text(
            order.status?[0].toUpperCase() ?? '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text('Pedido #${order.id.substring(0, 8)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: R\$ ${order.total?.toStringAsFixed(2) ?? '0.00'}'),
            if (order.createdAt != null)
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: isPartner && order.status == 'pending'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _updateStatus(ref, order.id, 'accepted'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _updateStatus(ref, order.id, 'rejected'),
                  ),
                ],
              )
            : Chip(
                label: Text(
                  statusLabels[order.status] ?? order.status ?? 'Desconhecido',
                ),
                backgroundColor: statusColors[order.status],
              ),
        onTap: () {
          // TODO: Mostrar detalhes do pedido
        },
      ),
    );
  }

  Future<void> _updateStatus(
    WidgetRef ref,
    String orderId,
    String newStatus,
  ) async {
    try {
      await SupabaseClientService.client
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);

      ref.invalidate(partnerOrdersProvider);
    } catch (e) {
      // TODO: Mostrar erro
    }
  }
}
