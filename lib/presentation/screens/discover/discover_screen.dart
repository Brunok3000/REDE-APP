import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';
import 'package:rede/models/partner_profile.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubra'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Em alta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: FutureBuilder<List<PartnerProfile>>(
                future: partnerRepositoryMock.listAll(),
                builder: (context, snapshot) {
                  final items = snapshot.data ?? [];
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final p = items[index];
                      return SizedBox(
                        width: 220,
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child:
                                    p.gallery.isNotEmpty
                                        ? Image.network(
                                          p.gallery.first,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                        : Container(color: AppColors.border),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'O que os amigos estão comentando',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<PartnerProfile>>(
                future: partnerRepositoryMock.listAll(),
                builder: (context, snapshot) {
                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('Sem recomendações no momento'),
                    );
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final p = items[index];
                      return ListTile(
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
