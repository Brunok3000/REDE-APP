import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';

class VisitorsScreen extends ConsumerStatefulWidget {
  const VisitorsScreen({super.key});

  @override
  ConsumerState<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends ConsumerState<VisitorsScreen> {
  bool _loading = true;
  List visitors = [];

  Future<void> _load() async {
    setState(() => _loading = true);
    final current = await userRepositoryMock.getCurrentUser();
    if (current == null) {
      setState(() {
        visitors = [];
        _loading = false;
      });
      return;
    }
    final list = await profileVisitRepositoryMock.listForUser(current.id);
    setState(() {
      visitors = list;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quem visitou seu perfil'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : visitors.isEmpty
              ? const Center(child: Text('Ninguém visitou ainda'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: visitors.length,
                itemBuilder: (context, index) {
                  final v = visitors[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(v.visitorId ?? 'Anônimo'),
                    subtitle: Text(v.createdAt.toLocal().toString()),
                  );
                },
              ),
    );
  }
}
