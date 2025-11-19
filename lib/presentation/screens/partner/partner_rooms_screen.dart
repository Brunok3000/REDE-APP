// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
// removed unused flutter_riverpod import
import '../../../core/theme/app_colors.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';
import 'room_form.dart';
import '../../components/basic_card.dart';
import '../../../models/room.dart';
import '../../../models/partner_profile.dart';

class PartnerRoomsScreen extends StatefulWidget {
  const PartnerRoomsScreen({super.key});

  @override
  State<PartnerRoomsScreen> createState() => _PartnerRoomsScreenState();
}

class _PartnerRoomsScreenState extends State<PartnerRoomsScreen> {
  Future<List<Room>> _loadRooms() async {
    final current = await userRepositoryMock.getCurrentUser();
    if (current == null) return [];
    final partners = await partnerRepositoryMock.listAll();
    PartnerProfile? partnerFound;
    for (final p in partners) {
      if (p.userId == current.id) {
        partnerFound = p;
        break;
      }
    }
    final pid = partnerFound?.id ?? '';
    if (pid.isEmpty) return [];
    return await roomRepositoryMock.listByPartner(pid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quartos'),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final current = await userRepositoryMock.getCurrentUser();
                if (current == null) return;
                if (!mounted) return;
                final partners = await partnerRepositoryMock.listAll();
                PartnerProfile? partnerFound;
                for (final p in partners) {
                  if (p.userId == current.id) {
                    partnerFound = p;
                    break;
                  }
                }
                final pid = partnerFound?.id ?? '';
                final res = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) => RoomForm(partnerId: pid),
                );
                if (!mounted) return;
                if (res == true) setState(() {});
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar quarto (mock)'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Room>>(
                future: _loadRooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('Nenhum quarto cadastrado'),
                    );
                  }
                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final r = items[index];
                      return BasicCard(
                        child: ListTile(
                          title: Text(r.title),
                          subtitle: Text(r.description ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final res = await showModalBottomSheet<bool>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder:
                                        (_) => RoomForm(
                                          room: r,
                                          partnerId: r.partnerId,
                                        ),
                                  );
                                  if (!mounted) return;
                                  if (res == true) setState(() {});
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await roomRepositoryMock.delete(r.id);
                                  if (!mounted) return;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete),
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
          ],
        ),
      ),
    );
  }
}
