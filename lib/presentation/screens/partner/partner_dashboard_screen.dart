import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class PartnerDashboardScreen extends ConsumerWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Parceiro'),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo ao painel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _tile(
                  context,
                  icon: Icons.edit,
                  label: 'Editar Perfil',
                  route: '/partner-edit',
                ),
                _tile(
                  context,
                  icon: Icons.meeting_room_outlined,
                  label: 'Quartos',
                  route: '/partner-rooms',
                ),
                _tile(
                  context,
                  icon: Icons.restaurant_menu_outlined,
                  label: 'Cardápio',
                  route: '/partner-menu',
                ),
                _tile(
                  context,
                  icon: Icons.calendar_month_outlined,
                  label: 'Reservas',
                  route: '/partner-bookings',
                ),
                _tile(
                  context,
                  icon: Icons.public,
                  label: 'Página pública',
                  route: '/partner-public',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Métricas rápidas',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Check-ins (30d)'),
                trailing: const Text('124'),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Reservas ativas'),
                trailing: const Text('8'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
