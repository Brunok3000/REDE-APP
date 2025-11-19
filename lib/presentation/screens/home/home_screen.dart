import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../repositories/mock/mock_singleton.dart';
import 'create_post_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    // load current demo user
    userRepositoryMock.getCurrentUser().then((u) {
      setState(() => _currentUser = u);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            gradient: AppColors.purpleGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: const Text(
            '🌐 Rede',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.primary,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            color: AppColors.primary,
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar estabelecimentos, usuários...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onTap: () {
                    // TODO: Navegar para tela de busca
                  },
                ),
              ),
              // Quick Access Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildQuickAccessButton(
                      icon: Icons.event,
                      label: 'Eventos',
                      color: AppColors.primary,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    _buildQuickAccessButton(
                      icon: Icons.restaurant,
                      label: 'Restaurantes',
                      color: AppColors.primaryLight,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    _buildQuickAccessButton(
                      icon: Icons.hotel,
                      label: 'Hospedagem',
                      color: AppColors.secondary,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Feed Posts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Feed Social',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Dynamic Feed
              FutureBuilder<List<Post>>(
                future: postRepositoryMock.listAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final posts = snapshot.data ?? [];
                  if (posts.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Nenhum post encontrado',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children:
                        posts.map((p) {
                          return Column(
                            children: [
                              _buildPostCardFromModel(context, p),
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final created = await Navigator.of(context).push<bool?>(
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );
          if (created == true) setState(() {});
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Busca'),
              NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'Reservas'),
              NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'Pedidos'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha((0.3 * 255).round())),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCardFromModel(BuildContext context, Post post) {
    // Card estilo rede social: branco sobre fundo cinza, ações com espaçamento e ícones maiores
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
  boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.02 * 255).round()), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.purpleGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(child: Text(post.authorAvatar ?? '👤', style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorName, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(_niceTimestamp(post.createdAt), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz), color: AppColors.textTertiary),
            ],
          ),
          const SizedBox(height: 10),
          // Conteúdo do post
          Text(post.content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary)),
          if (postHasImagePlaceholder(post)) ...[
            const SizedBox(height: 10),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Imagem do post', style: Theme.of(context).textTheme.bodyMedium)),
            ),
          ],
          const SizedBox(height: 12),
          // Actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final user = await userRepositoryMock.getCurrentUser();
                    if (user != null) {
                      if (post.likedBy.contains(user.id)) {
                        await postRepositoryMock.unlike(post.id, user.id);
                      } else {
                        await postRepositoryMock.like(post.id, user.id);
                      }
                      setState(() {});
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (_currentUser != null && post.likedBy.contains(_currentUser!.id)) ? Icons.favorite : Icons.favorite_border,
                        color: (_currentUser != null && post.likedBy.contains(_currentUser!.id)) ? AppColors.error : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(post.likes.toString(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.chat_bubble_outline, color: AppColors.primary), const SizedBox(width: 8), Text(post.commentsCount.toString(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary))]),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.share_outlined, color: AppColors.textSecondary), const SizedBox(width: 8), Text('Compartilhar', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary))]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool postHasImagePlaceholder(Post p) {
    // placeholder: futuramente checar p.images != null
    return false;
  }

  String _niceTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    return 'há ${diff.inDays}d';
  }
}
