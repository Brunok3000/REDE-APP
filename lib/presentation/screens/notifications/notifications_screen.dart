import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  Future<List> _load() async {
    final current = await userRepositoryMock.getCurrentUser();
    if (current == null) return [];
    final list = await notificationRepositoryMock.listForUser(current.id);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: AppColors.surface,
      ),
      body: FutureBuilder<List>(
        future: _load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('Nenhuma notificação'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final n = list[index];
              final created =
                  (n.createdAt is DateTime)
                      ? n.createdAt as DateTime
                      : DateTime.now();
              final when = DateFormat('dd/MM/yyyy HH:mm').format(created);
              return Card(
                color: AppColors.surface,
                child: ListTile(
                  title: Text(n.title ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(n.body ?? ''),
                      const SizedBox(height: 6),
                      Text(when, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
