import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Meu Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: AppColors.primary,
            onPressed: () {
              // TODO: Navegar para editar perfil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.surface,
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    'João Silva',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Username
                  Text(
                    '@joaosilva123',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Bio
                  Text(
                    'Viajante | Foodie | Aventureiro 🌍',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat(label: 'Posts', value: '42'),
                      Container(width: 1, height: 40, color: AppColors.border),
                      _buildStat(label: 'Seguidores', value: '1.2K'),
                      Container(width: 1, height: 40, color: AppColors.border),
                      _buildStat(label: 'Seguindo', value: '340'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Menu Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuOption(
                    icon: Icons.favorite_outline,
                    title: 'Estabelecimentos Salvos',
                    subtitle: 'Seus favoritos',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Meus Pedidos',
                    subtitle: 'Histórico e status',
                    onTap: () {
                      context.go('/orders');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.calendar_today_outlined,
                    title: 'Minhas Reservas',
                    subtitle: 'Próximas e passadas',
                    onTap: () {
                      context.go('/reservations');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.star_outline,
                    title: 'Avaliações',
                    subtitle: 'Suas críticas e notas',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.comment_outlined,
                    title: 'Depoimentos pendentes',
                    subtitle: 'Aprovar ou remover depoimentos',
                    onTap: () {
                      context.go('/testimonials');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.remove_red_eye_outlined,
                    title: 'Quem visitou seu perfil',
                    subtitle: 'Ver visitantes recentes',
                    onTap: () {
                      context.go('/visitors');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.payment_outlined,
                    title: 'Métodos de Pagamento',
                    subtitle: 'Cartões e contas',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.location_on_outlined,
                    title: 'Endereços',
                    subtitle: 'Seus endereços salvos',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configurações',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.notifications_outlined,
                    title: 'Notificações',
                    subtitle: 'Gerenciar alertas',
                    onTap: () {
                      context.go('/notifications');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.security_outlined,
                    title: 'Segurança e Privacidade',
                    subtitle: 'Proteção da conta',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.help_outline,
                    title: 'Central de Ajuda',
                    subtitle: 'Dúvidas e suporte',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: Icons.info_outline,
                    title: 'Sobre o App',
                    subtitle: 'Versão e informações',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showLogoutDialog();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStat({required String label, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildMenuOption({
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sair'),
            content: const Text('Tem certeza que deseja sair da sua conta?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implementar logout
                  context.go('/login');
                },
                child: const Text(
                  'Sair',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
  }
}
