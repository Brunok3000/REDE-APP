import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';
import 'package:rede/models/partner_profile.dart';

class UnifiedSearchScreen extends ConsumerStatefulWidget {
  const UnifiedSearchScreen({super.key});

  @override
  ConsumerState<UnifiedSearchScreen> createState() =>
      _UnifiedSearchScreenState();
}

class _UnifiedSearchScreenState extends ConsumerState<UnifiedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<PartnerProfile>> _loadResults() async {
    final all = await partnerRepositoryMock.listAll();
    if (_query.trim().isEmpty) return all;
    final q = _query.toLowerCase();
    return all
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              (p.description ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar hotéis, restaurantes, eventos, serviços...',
            border: InputBorder.none,
          ),
          onSubmitted: (v) => setState(() => _query = v),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Todos')),
                Chip(label: Text('Hotéis')),
                Chip(label: Text('Restaurantes')),
                Chip(label: Text('Eventos')),
                Chip(label: Text('Serviços')),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<PartnerProfile>>(
                future: _loadResults(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final results = snapshot.data ?? [];
                  if (results.isEmpty) {
                    return const Center(child: Text('Nenhum resultado'));
                  }
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final p = results[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading:
                              p.gallery.isNotEmpty
                                  ? Image.network(
                                    p.gallery.first,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  )
                                  : Container(
                                    width: 56,
                                    height: 56,
                                    color: AppColors.border,
                                  ),
                          title: Text(p.name),
                          subtitle: Text(p.description ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              // TODO: navigate to partner public page
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
