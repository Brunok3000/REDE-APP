import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  late List<String> _filterTabs;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _filterTabs = ['Todos', 'Pendentes', 'Entregues', 'Cancelados'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _filterTabs.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _selectedTabIndex == index
                                  ? AppColors.primary
                                  : AppColors.border,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _filterTabs[index],
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(
                            color:
                                _selectedTabIndex == index
                                    ? Colors.white
                                    : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Orders List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOrderCard(
                  context,
                  orderId: '#123456',
                  restaurant: 'Pizzaria Do Bairro',
                  status: 'Entregue',
                  statusColor: AppColors.success,
                  items: 3,
                  total: 'R\$ 45,90',
                  date: '15 de nov, 19:30',
                ),
                const SizedBox(height: 12),
                _buildOrderCard(
                  context,
                  orderId: '#123455',
                  restaurant: 'Burger Palace',
                  status: 'A caminho',
                  statusColor: AppColors.warning,
                  items: 2,
                  total: 'R\$ 32,50',
                  date: '14 de nov, 18:45',
                ),
                const SizedBox(height: 12),
                _buildOrderCard(
                  context,
                  orderId: '#123454',
                  restaurant: 'Sushi Express',
                  status: 'Pendente',
                  statusColor: AppColors.info,
                  items: 4,
                  total: 'R\$ 78,00',
                  date: '13 de nov, 20:15',
                ),
                const SizedBox(height: 12),
                _buildOrderCard(
                  context,
                  orderId: '#123453',
                  restaurant: 'Açai Tropical',
                  status: 'Entregue',
                  statusColor: AppColors.success,
                  items: 1,
                  total: 'R\$ 15,90',
                  date: '12 de nov, 10:30',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String orderId,
    required String restaurant,
    required String status,
    required Color statusColor,
    required int items,
    required String total,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      orderId,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Details
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                '$items itens',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                date,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Divider
          Divider(color: AppColors.border, height: 16),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                total,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Ver detalhes do pedido
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Ver Detalhes',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
