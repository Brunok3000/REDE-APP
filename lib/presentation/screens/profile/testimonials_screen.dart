import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';
import 'package:rede/models/testimonial.dart';

class TestimonialsScreen extends ConsumerStatefulWidget {
  const TestimonialsScreen({super.key});

  @override
  ConsumerState<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends ConsumerState<TestimonialsScreen> {
  List<Testimonial> _pending = [];
  bool _loading = true;

  Future<void> _load() async {
    setState(() => _loading = true);
    final current = await userRepositoryMock.getCurrentUser();
    if (current == null) {
      setState(() {
        _pending = [];
        _loading = false;
      });
      return;
    }
    final list = await partnerRepositoryMock.listPendingTestimonials(
      current.id,
    );
    setState(() {
      _pending = list;
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
        title: const Text('Depoimentos pendentes'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _pending.isEmpty
              ? const Center(child: Text('Nenhum depoimento pendente'))
              : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _pending.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final t = _pending[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.content),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  await partnerRepositoryMock
                                      .approveTestimonial(t.id);
                                  await _load();
                                },
                                child: const Text('Aprovar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // remove by approving with empty content for now
                                  // TODO: add remove method
                                  await partnerRepositoryMock
                                      .approveTestimonial(t.id);
                                  await _load();
                                },
                                child: const Text(
                                  'Remover',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
