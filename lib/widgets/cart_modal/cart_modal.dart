import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cart/cart_provider.dart';
import '../../providers/auth/auth_provider.dart';
import '../../services/supabase_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartModal extends ConsumerWidget {
  const CartModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final total = cartNotifier.total;
    final establishmentId = cartNotifier.establishmentId;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Carrinho',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          // Lista de itens
          if (cartItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('Carrinho vazio')),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CartItemTile(item: item);
                },
              ),
            ),
          // Total e checkout
          if (cartItems.isNotEmpty) ...[
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _checkout(context, ref, establishmentId, total),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Finalizar Pedido'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _checkout(
    BuildContext context,
    WidgetRef ref,
    String? establishmentId,
    double total,
  ) async {
    if (establishmentId == null) {
      Fluttertoast.showToast(msg: 'Erro: estabelecimento não identificado');
      return;
    }

    final cartItems = ref.read(cartProvider);
    final auth = ref.read(authProvider);
    final userId = auth.value?.userId;

    if (userId == null) {
      Fluttertoast.showToast(msg: 'Faça login para finalizar pedido');
      return;
    }

    try {
      // Converter itens do carrinho para formato do banco
      final items = cartItems.map((item) => {
        'id': item.id,
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
      }).toList();

      // Criar pedido
      await SupabaseClientService.client.from('orders').insert({
        'establishment_id': establishmentId,
        'user_id': userId,
        'consumer_id': userId,
        'items': items,
        'total': total,
        'status': 'pending',
      });

      // Limpar carrinho
      ref.read(cartProvider.notifier).clear();

      // Notificar POS via realtime (já configurado no Supabase)
      await SupabaseClientService.notifyNewOrder({
        'establishment_id': establishmentId,
        'total': total,
      });

      if (context.mounted) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Pedido realizado com sucesso!');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erro ao finalizar pedido: $e');
    }
  }
}

class CartItemTile extends ConsumerWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: item.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: item.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.fastfood),
        title: Text(item.name),
        subtitle: Text('R\$ ${item.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                ref.read(cartProvider.notifier).updateQuantity(
                      item.id,
                      item.quantity - 1,
                    );
              },
            ),
            Text('${item.quantity}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                ref.read(cartProvider.notifier).updateQuantity(
                      item.id,
                      item.quantity + 1,
                    );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(cartProvider.notifier).removeItem(item.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
