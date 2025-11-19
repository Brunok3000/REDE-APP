import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class PartnerBookingsScreen extends ConsumerWidget {
  const PartnerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text('Calendário de reservas (skeleton)'),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Text(
                  'Componente de calendário será implementado (mock)',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
