import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/supabase_client.dart';
import '../../providers/auth/auth_provider.dart';

// Provider para pedidos do estabelecimento do partner
final partnerOrdersRealtimeProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      establishmentId,
    ) async* {
      final client = SupabaseClientService.client;

      // Subscribe para atualizações realtime dos pedidos
      final stream = client
          .from('orders')
          .stream(primaryKey: ['id'])
          .eq('establishment_id', establishmentId)
          .order('created_at');

      yield* stream.map((event) {
        // event é uma lista de maps
        return List<Map<String, dynamic>>.from(event);
      });
    });

class POSDashboardScreen extends ConsumerStatefulWidget {
  const POSDashboardScreen({super.key});

  @override
  ConsumerState<POSDashboardScreen> createState() => _POSDashboardScreenState();
}

class _POSDashboardScreenState extends ConsumerState<POSDashboardScreen> {
  final Set<String> _seenOrderIds = {};

  @override
  void initState() {
    super.initState();
    // Load seen ids from Hive
    try {
      final box = Hive.box('kds_orders');
      final List<dynamic> seen =
          box.get('seen', defaultValue: <dynamic>[]) as List<dynamic>;
      _seenOrderIds.addAll(seen.map((e) => e.toString()));
    } catch (_) {}
  }

  void _cacheOrder(Map<String, dynamic> order) {
    try {
      final box = Hive.box('kds_orders');
      final key = 'order_${order['id']}';
      box.put(key, order);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider).value;

    // Se não for parceiro, mostrar erro
    if (auth?.role != 'partner') {
      return Scaffold(
        appBar: AppBar(title: const Text('POS')),
        body: const Center(
          child: Text('Apenas parceiros podem acessar esta função'),
        ),
      );
    }

    // Obter ID do estabelecimento do partner
    final establishmentId = auth?.userId ?? '';

    // Listen para novos pedidos: toca som, vibra e cacheia quando um novo pedido chega
    ref.listen<AsyncValue<List<Map<String, dynamic>>>>(
      partnerOrdersRealtimeProvider(establishmentId),
      (previous, next) {
        try {
          final prevList = previous?.value ?? <Map<String, dynamic>>[];
          final nextList = next.value ?? <Map<String, dynamic>>[];
          if (prevList.length < nextList.length) {
            // Novo pedido recebido
            try {
              HapticFeedback.vibrate();
            } catch (_) {}
            try {
              SystemSound.play(SystemSoundType.alert);
            } catch (_) {}
            Fluttertoast.showToast(msg: 'Novo pedido recebido');

            // Cachear novos pedidos e keep them as not-seen
            final prevIds = prevList.map((e) => e['id'] as String).toSet();
            for (final o in nextList) {
              final id = o['id'] as String;
              if (!prevIds.contains(id)) {
                _cacheOrder(o);
              }
            }
            setState(() {});
          }
        } catch (_) {}
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel POS'),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              // Marcar todos como visto
              try {
                final box = Hive.box('kds_orders');
                final allIds = <String>[];
                final current =
                    ref
                        .read(partnerOrdersRealtimeProvider(establishmentId))
                        .value ??
                    <Map<String, dynamic>>[];
                for (final o in current) {
                  final id = o['id']?.toString();
                  if (id != null) allIds.add(id);
                }
                box.put('seen', allIds);
                _seenOrderIds.clear();
                _seenOrderIds.addAll(allIds);
                setState(() {});
                Fluttertoast.showToast(
                  msg: 'Todos os pedidos marcados como vistos',
                );
              } catch (_) {}
            },
            icon: const Icon(Icons.remove_red_eye, color: Colors.white),
            label: const Text(
              'Marcar todos',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Tooltip(
            message: 'Recarregar pedidos',
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(partnerOrdersRealtimeProvider(establishmentId));
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Abas: Todos, Pendentes, Em Preparo, Prontos
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pedidos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: const Text('Status'),
                  avatar: const Icon(Icons.filter_list),
                  onDeleted: () {},
                ),
              ],
            ),
          ),
          // Lista de pedidos com status
          Expanded(
            child: ref
                .watch(partnerOrdersRealtimeProvider(establishmentId))
                .when(
                  data: (orders) {
                    if (orders.isEmpty) {
                      return const Center(
                        child: Text('Nenhum pedido no momento'),
                      );
                    }

                    // Separar pedidos por status
                    final pending = orders
                        .where((o) => o['status'] == 'pending')
                        .toList();
                    final preparing = orders
                        .where((o) => o['status'] == 'preparing')
                        .toList();
                    final ready = orders
                        .where((o) => o['status'] == 'ready')
                        .toList();

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pendentes
                          if (pending.isNotEmpty)
                            _buildOrderSection(
                              context,
                              ref,
                              'Novos Pedidos',
                              pending,
                              Colors.red,
                            ),
                          // Em Preparo
                          if (preparing.isNotEmpty)
                            _buildOrderSection(
                              context,
                              ref,
                              'Em Preparo',
                              preparing,
                              Colors.orange,
                            ),
                          // Prontos
                          if (ready.isNotEmpty)
                            _buildOrderSection(
                              context,
                              ref,
                              'Prontos para Entrega',
                              ready,
                              Colors.green,
                            ),
                        ],
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, st) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Erro: $err'),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(
                            partnerOrdersRealtimeProvider(establishmentId),
                          ),
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

  Widget _buildOrderSection(
    BuildContext context,
    WidgetRef ref,
    String title,
    List<Map<String, dynamic>> orders,
    Color statusColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(width: 4, height: 24, color: statusColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Badge(label: Text('${orders.length}')),
            ],
          ),
        ),
        ...orders.map((order) {
          final id = (order['id'] ?? '').toString();
          final isNew = !_seenOrderIds.contains(id);
          return _OrderCard(
            order: order,
            statusColor: statusColor,
            isNew: isNew,
            onMarkSeen: () {
              try {
                final box = Hive.box('kds_orders');
                final List<dynamic> seen =
                    box.get('seen', defaultValue: <dynamic>[]) as List<dynamic>;
                if (!seen.map((e) => e.toString()).contains(id)) {
                  final updated = [...seen.map((e) => e.toString()), id];
                  box.put('seen', updated);
                }
                _seenOrderIds.add(id);
                setState(() {});
              } catch (_) {}
            },
          );
        }),
        const Divider(height: 24),
      ],
    );
  }
}

// Card para exibir detalhes de um pedido
class _OrderCard extends ConsumerWidget {
  final Map<String, dynamic> order;
  final Color statusColor;
  final bool isNew;
  final VoidCallback? onMarkSeen;

  const _OrderCard({
    required this.order,
    required this.statusColor,
    this.isNew = false,
    this.onMarkSeen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderId = order['id'] as String;
    final items = order['items'] as List?;
    final total = (order['total'] as num?)?.toDouble() ?? 0.0;
    final status = order['status'] as String?;
    final createdAt = order['created_at'] as String?;

    return Card(
      color: isNew ? Colors.yellow[50] : null,
      elevation: isNew ? 4 : 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido #${orderId.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (createdAt != null)
                    Text(
                      'Hora: ${DateTime.parse(createdAt).hour}:${DateTime.parse(createdAt).minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
                Text(
                  status ?? 'pendente',
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          // Itens do pedido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Itens:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (items != null && items.isNotEmpty)
                  ...items.map((item) {
                    final itemName = item['name'] ?? 'Item';
                    final itemQty = item['quantity'] ?? 1;
                    final itemPrice =
                        (item['price'] as num?)?.toDouble() ?? 0.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '$itemQty x $itemName',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'R\$ ${(itemPrice * itemQty).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  })
                else
                  const Text('Nenhum item'),
                const SizedBox(height: 16),
                const Divider(),
                // Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (isNew)
                      OutlinedButton.icon(
                        onPressed: onMarkSeen,
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text('Marcar visto'),
                      ),
                    if (status == 'pending')
                      ElevatedButton.icon(
                        onPressed: () => _updateOrderStatus(
                          context,
                          ref,
                          orderId,
                          'preparing',
                        ),
                        icon: const Icon(Icons.local_dining),
                        label: const Text('Preparar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    if (status == 'preparing')
                      ElevatedButton.icon(
                        onPressed: () =>
                            _updateOrderStatus(context, ref, orderId, 'ready'),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Pronto'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    if (status == 'ready')
                      ElevatedButton.icon(
                        onPressed: () => _updateOrderStatus(
                          context,
                          ref,
                          orderId,
                          'delivered',
                        ),
                        icon: const Icon(Icons.delivery_dining),
                        label: const Text('Entregue'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    if (status == 'pending')
                      OutlinedButton.icon(
                        onPressed: () => _updateOrderStatus(
                          context,
                          ref,
                          orderId,
                          'cancelled',
                        ),
                        icon: const Icon(Icons.close),
                        label: const Text('Rejeitar'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateOrderStatus(
    BuildContext context,
    WidgetRef ref,
    String orderId,
    String newStatus,
  ) async {
    try {
      await SupabaseClientService.client
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);

      if (context.mounted) {
        Fluttertoast.showToast(msg: 'Pedido atualizado para: $newStatus');
        // Marcar como visto no cache local
        try {
          final box = Hive.box('kds_orders');
          final List<dynamic> seen =
              box.get('seen', defaultValue: <dynamic>[]) as List<dynamic>;
          if (!seen.map((e) => e.toString()).contains(orderId)) {
            final updated = [...seen.map((e) => e.toString()), orderId];
            box.put('seen', updated);
          }
        } catch (_) {}
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erro ao atualizar pedido: $e');
    }
  }
}
