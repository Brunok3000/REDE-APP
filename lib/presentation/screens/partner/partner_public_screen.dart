import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// uuid was removed — not needed here
import '../../../core/theme/app_colors.dart';
import 'package:rede/models/partner_profile.dart';
import 'package:rede/models/testimonial.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';
import '../../components/basic_card.dart';
import '../../components/testimonial_form.dart';

class PartnerPublicScreen extends ConsumerStatefulWidget {
  const PartnerPublicScreen({super.key});

  @override
  ConsumerState<PartnerPublicScreen> createState() =>
      _PartnerPublicScreenState();
}

class _PartnerPublicScreenState extends ConsumerState<PartnerPublicScreen> {
  PartnerProfile? _partner;
  bool _loading = true;

  Future<void> _load() async {
    setState(() => _loading = true);
    final pid = Uri.base.queryParameters['partnerId'];
    if (pid == null) {
      setState(() => _loading = false);
      return;
    }
    final p = await partnerRepositoryMock.getById(pid);
    setState(() {
      _partner = p;
      _loading = false;
    });

    // register profile visit unless owner opted out
    final current = await userRepositoryMock.getCurrentUser();
    if (current != null &&
        !(current.settings['optOutProfileVisits'] ?? false)) {
      // record visit (visitorId is user id)
      await profileVisitRepositoryMock.addVisit(
        visitorId: current.id,
        visitedUserId: p?.userId ?? '',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _doCheckIn() async {
    final current = await userRepositoryMock.getCurrentUser();
    if (current == null) {
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para dar check-in')),
      );
      return;
    }
    final success = await partnerRepositoryMock.tryCheckIn(
      userId: current.id,
      partnerId: _partner!.id,
    );
    if (success) {
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in registrado com sucesso')),
      );
    } else {
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você já fez check-in nas últimas 24h')),
      );
    }
  }

  void _openTestimonialForm() async {
    final ownerUserId = _partner?.userId ?? '';
    // ignore: use_build_context_synchronously
    final res = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: TestimonialForm(
              targetId: ownerUserId,
              targetType: 'partner',
            ),
          ),
    );
    if (res == true) {
      // optionally reload partner data
      if (!mounted) return;
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_partner?.name ?? 'Estabelecimento'),
        backgroundColor: AppColors.surface,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _partner == null
              ? const Center(child: Text('Estabelecimento não encontrado'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_partner!.gallery.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: Image.network(
                          _partner!.gallery.first,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 12),
                    BasicCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _partner!.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_partner!.description ?? ''),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _doCheckIn,
                            child: const Text('Check-in'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _openTestimonialForm,
                          child: const Text('Deixar depoimento'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Depoimentos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<List<Testimonial>>(
                      future: partnerRepositoryMock.listApprovedTestimonials(
                        _partner?.userId ?? '',
                      ),
                      builder: (context, snapshot) {
                        final list = snapshot.data ?? [];
                        if (list.isEmpty) {
                          return const Text('Nenhum depoimento publicado');
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final t = list[index];
                            return Card(
                              child: ListTile(
                                title: Text(t.content),
                                subtitle: Text('por ${t.authorId}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
