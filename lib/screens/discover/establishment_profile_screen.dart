import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/establishment.dart';
import '../../services/supabase_client.dart';
import '../../providers/cart/cart_provider.dart';
import 'services_tabs.dart';

// Provider para menu items
final menuItemsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      establishmentId,
    ) async {
      final client = SupabaseClientService.client;
      final results = await client
          .from('menu_items')
          .select()
          .eq('establishment_id', establishmentId)
          .eq('available', true);
      return List<Map<String, dynamic>>.from(results);
    });

class EstablishmentProfileScreen extends ConsumerStatefulWidget {
  final Establishment establishment;

  const EstablishmentProfileScreen({super.key, required this.establishment});

  @override
  ConsumerState<EstablishmentProfileScreen> createState() =>
      _EstablishmentProfileScreenState();
}

class _EstablishmentProfileScreenState
    extends ConsumerState<EstablishmentProfileScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _mainTabController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _mainTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mainTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.establishment.name), elevation: 0),
      body: Column(
        children: [
          // Galeria de fotos
          SizedBox(
            height: 250,
            child:
                widget.establishment.photos != null &&
                    widget.establishment.photos!.isNotEmpty
                ? PageView.builder(
                    controller: _pageController,
                    itemCount: widget.establishment.photos!.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.establishment.photos![index],
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.store, size: 100),
                  ),
          ),
          // Informações do estabelecimento
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.establishment.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (widget.establishment.rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.establishment.rating!.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (widget.establishment.type != null)
                  Chip(label: Text(widget.establishment.type!)),
                const SizedBox(height: 16),
                if (widget.establishment.addressJson != null)
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.establishment.addressJson!['street'] ?? 'N/A',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // TabBar para Delivery e Serviços
          TabBar(
            controller: _mainTabController,
            tabs: const [
              Tab(text: 'Delivery', icon: Icon(Icons.restaurant)),
              Tab(text: 'Serviços', icon: Icon(Icons.calendar_today)),
            ],
          ),
          // Conteúdo com Delivery vs Serviços
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                // Aba 1: Delivery (Menu + Cart)
                _DeliveryTab(establishmentId: widget.establishment.id),
                // Aba 2: Serviços (Reserva + Ingressos + Hospedagem)
                _ServicesTab(establishmentId: widget.establishment.id),
              ],
            ),
          ),
          // Cart footer (apenas na aba Delivery)
          if (ref.watch(cartProvider).isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ref.watch(cartProvider).length} itens',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'R\$ ${ref.read(cartProvider.notifier).total.toStringAsFixed(2)}',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _showCheckoutModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showCheckoutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CheckoutModal(establishment: widget.establishment),
    );
  }
}

// Widget para aba Delivery
class _DeliveryTab extends ConsumerWidget {
  final String establishmentId;

  const _DeliveryTab({required this.establishmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuItemsProvider(establishmentId));

    return menuAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Nenhum item disponível'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _MenuItem(item: item, establishmentId: establishmentId);
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
              onPressed: () =>
                  ref.invalidate(menuItemsProvider(establishmentId)),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para aba Serviços
class _ServicesTab extends ConsumerStatefulWidget {
  final String establishmentId;

  const _ServicesTab({required this.establishmentId});

  @override
  ConsumerState<_ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends ConsumerState<_ServicesTab>
    with TickerProviderStateMixin {
  late TabController _servicesTabController;

  @override
  void initState() {
    super.initState();
    _servicesTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _servicesTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _servicesTabController,
          tabs: const [
            Tab(text: 'Reserva', icon: Icon(Icons.calendar_today)),
            Tab(text: 'Ingressos', icon: Icon(Icons.event_seat)),
            Tab(text: 'Hospedagem', icon: Icon(Icons.hotel)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _servicesTabController,
            children: [
              ReservaTab(establishmentId: widget.establishmentId),
              IngressosTab(establishmentId: widget.establishmentId),
              HospedagemTab(establishmentId: widget.establishmentId),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends ConsumerWidget {
  final Map<String, dynamic> item;
  final String establishmentId;

  const _MenuItem({required this.item, required this.establishmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = item['id'] as String;
    final name = item['name'] as String;
    final description = item['description'] as String?;
    final price = (item['price'] as num).toDouble();
    final imageUrl = item['image_url'] as String?;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagem
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    width: 80,
                    height: 80,
                    child: Icon(Icons.image_not_supported),
                  ),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.fastfood),
              ),
            const SizedBox(width: 12),
            // Detalhes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleSmall),
                  if (description != null && description.isNotEmpty)
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _addToCart(ref, id, name, price),
                        child: const Text('Adicionar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(WidgetRef ref, String itemId, String name, double price) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final item = CartItem(
      id: itemId,
      name: name,
      price: price,
      quantity: 1,
      establishmentId: establishmentId,
    );
    cartNotifier.addItem(item);
    Fluttertoast.showToast(msg: '$name adicionado ao carrinho');
  }
}

class CheckoutModal extends ConsumerWidget {
  final Establishment establishment;

  const CheckoutModal({super.key, required this.establishment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartTotal = ref.read(cartProvider.notifier).total;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Resumo do Pedido',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Itens
            for (final item in cart)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name),
                          Text(
                            '${item.quantity}x R\$ ${item.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'R\$ ${item.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            const Divider(),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  'R\$ ${cartTotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botões
            ElevatedButton(
              onPressed: () async {
                await _submitOrder(
                  context,
                  ref,
                  establishment.id,
                  cart,
                  cartTotal,
                );
              },
              child: const Text('Confirmar Pedido'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitOrder(
    BuildContext context,
    WidgetRef ref,
    String establishmentId,
    List<CartItem> cart,
    double total,
  ) async {
    try {
      final user = SupabaseClientService.getCurrentUser();
      if (user == null) {
        Fluttertoast.showToast(msg: 'Usuário não autenticado');
        return;
      }

      // Criar pedido no Supabase
      // Inserir pedido e obter o registro criado
      final insertResp = await SupabaseClientService.client
          .from('orders')
          .insert({
            'establishment_id': establishmentId,
            'consumer_id': user.id,
            'items': cart
                .map(
                  (item) => {
                    'id': item.id,
                    'name': item.name,
                    'quantity': item.quantity,
                    'price': item.price,
                  },
                )
                .toList(),
            'total': total,
            'status': 'pending',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .maybeSingle();

      // Limpar carrinho
      ref.read(cartProvider.notifier).clear();

      if (context.mounted) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Pedido realizado com sucesso!');
      }

      // Tentar notificar servidor para envio de push (Edge Function)
      try {
        if (insertResp != null) {
          await SupabaseClientService.notifyNewOrder(insertResp);
        } else {
          // fallback: enviar payload mínimo
          await SupabaseClientService.notifyNewOrder({
            'establishment_id': establishmentId,
            'consumer_id': user.id,
            'total': total,
          });
        }
      } catch (_) {
        // não bloquear a UX se a notificação falhar
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erro ao criar pedido: $e');
    }
  }
}
