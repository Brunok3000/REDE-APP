import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsOption(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notificações',
            subtitle: 'Gerenciar alertas e preferências',
            onTap: () {
              // TODO: Navegar para tela de notificações
            },
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            context,
            icon: Icons.lock_outline,
            title: 'Privacidade',
            subtitle: 'Configurações de segurança e privacidade',
            onTap: () {
              // TODO: Navegar para tela de privacidade
            },
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            context,
            icon: Icons.language_outlined,
            title: 'Idioma',
            subtitle: 'Selecionar idioma preferido',
            onTap: () {
              // TODO: Navegar para tela de idioma
            },
          ),
          const SizedBox(height: 12),
          _buildSettingsOption(
            context,
            icon: Icons.info_outline,
            title: 'Sobre',
            subtitle: 'Informações sobre o aplicativo',
            onTap: () {
              // TODO: Navegar para tela sobre
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryVeryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
