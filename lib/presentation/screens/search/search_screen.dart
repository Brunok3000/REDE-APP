import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  bool _showFilters = false;
  String _selectedCategory = 'Todos';
  double _selectedDistance = 10;
  double _selectedRating = 3.0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Buscar Estabelecimentos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Restaurante, hotel, serviço...',
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
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          _showFilters ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: _showFilters ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filters
          if (_showFilters)
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter
                  Text(
                    'Categoria',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                          'Todos',
                          'Restaurantes',
                          'Hotels',
                          'Eventos',
                          'Serviços',
                        ].map((category) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _selectedCategory == category
                                        ? AppColors.primary
                                        : AppColors.border,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.copyWith(
                                  color:
                                      _selectedCategory == category
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Distance Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Distância',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_selectedDistance.toStringAsFixed(1)} km',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _selectedDistance,
                    min: 1,
                    max: 50,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.border,
                    onChanged: (value) {
                      setState(() {
                        _selectedDistance = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Rating Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Avaliação mínima',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: AppColors.warning, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            _selectedRating.toStringAsFixed(1),
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Slider(
                    value: _selectedRating,
                    min: 1,
                    max: 5,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.border,
                    onChanged: (value) {
                      setState(() {
                        _selectedRating = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          // Results
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildEstablishmentCard(
                  context,
                  name: 'Restaurante Italiano Premium',
                  category: 'Restaurante',
                  rating: 4.8,
                  reviews: 256,
                  distance: '1.2 km',
                  image: '🍝',
                  isOpen: true,
                ),
                const SizedBox(height: 12),
                _buildEstablishmentCard(
                  context,
                  name: 'Hotel Vista Mar',
                  category: 'Hotel',
                  rating: 4.6,
                  reviews: 189,
                  distance: '2.5 km',
                  image: '🏨',
                  isOpen: true,
                ),
                const SizedBox(height: 12),
                _buildEstablishmentCard(
                  context,
                  name: 'Salão de Beleza Elegância',
                  category: 'Serviço',
                  rating: 4.9,
                  reviews: 342,
                  distance: '0.8 km',
                  image: '💅',
                  isOpen: true,
                ),
                const SizedBox(height: 12),
                _buildEstablishmentCard(
                  context,
                  name: 'Pizzaria Tradicional',
                  category: 'Restaurante',
                  rating: 4.5,
                  reviews: 128,
                  distance: '3.1 km',
                  image: '🍕',
                  isOpen: false,
                ),
                const SizedBox(height: 12),
                _buildEstablishmentCard(
                  context,
                  name: 'Pousada do Vale',
                  category: 'Hotel',
                  rating: 4.7,
                  reviews: 95,
                  distance: '5.2 km',
                  image: '🏩',
                  isOpen: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstablishmentCard(
    BuildContext context, {
    required String name,
    required String category,
    required double rating,
    required int reviews,
    required String distance,
    required String image,
    required bool isOpen,
  }) {
    // Card redesenhado: imagem com gradiente + conteúdo legível sobre o card branco
    return GestureDetector(
      onTap: () {
        // Navegar para detalhes do estabelecimento (se houver rota)
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
                BoxShadow(
              color: Colors.black.withAlpha((0.04 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem de topo com gradiente para legibilidade
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: AppColors.purpleGradient,
              ),
              child: Stack(
                children: [
                  // Emoji ou imagem centralizada
                  Center(child: Text(image, style: const TextStyle(fontSize: 52))),
                  // Distância no canto superior direito
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha((0.45 * 255).round()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            distance,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(category, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                                const SizedBox(width: 8),
                                _buildTag('OPEN', isOpen ? Colors.green.shade50 : Colors.red.shade50, isOpen ? Colors.green : Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: AppColors.warning, size: 16),
                              const SizedBox(width: 6),
                              Text(rating.toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('$reviews avaliações', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Ver Detalhes', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
