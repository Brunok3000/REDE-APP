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
    return GestureDetector(
      onTap: () {
        // TODO: Navegar para detalhes do estabelecimento
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(gradient: AppColors.purpleGradient),
              child: Center(
                child: Text(image, style: const TextStyle(fontSize: 60)),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isOpen
                                  ? AppColors.successLight
                                  : AppColors.errorLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isOpen ? 'Aberto' : 'Fechado',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: isOpen ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Rating and Distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: AppColors.warning, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($reviews avaliações)',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            distance,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Fazer reserva/pedir
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Ver Detalhes',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}
