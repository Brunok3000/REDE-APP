import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:rede/models/testimonial.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';
import '../../../core/theme/app_colors.dart';

class TestimonialForm extends StatefulWidget {
  final String targetId; // target user or partner owner's userId
  final String targetType; // 'user'|'partner'
  const TestimonialForm({
    super.key,
    required this.targetId,
    this.targetType = 'partner',
  });

  @override
  State<TestimonialForm> createState() => _TestimonialFormState();
}

class _TestimonialFormState extends State<TestimonialForm> {
  final _controller = TextEditingController();
  bool _isSecret = false;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _loading = true);
    final uuid = Uuid();
    final current = await userRepositoryMock.getCurrentUser();
    final t = Testimonial(
      id: uuid.v4(),
      authorId: current?.id ?? 'anonymous',
      targetUserId: widget.targetId,
      content: _controller.text.trim(),
      isSecret: _isSecret,
      approved: false,
    );
    await partnerRepositoryMock.addTestimonial(t);

    // If secret, notify owner
    if (_isSecret) {
      // find partner owner's userId if needed
      // we assume targetId is owner userId when submitting for partner
      await notificationRepositoryMock.addNotification(
        userId: widget.targetId,
        title: 'Novo depoimento secreto',
        body: 'Você tem um depoimento pendente.',
      );
    }

    setState(() => _loading = false);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Escreva seu depoimento',
            ),
            maxLines: 4,
          ),
          Row(
            children: [
              Checkbox(
                value: _isSecret,
                onChanged: (v) => setState(() => _isSecret = v ?? false),
              ),
              const Text('Enviar como secreto (precisa de aprovação)'),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loading ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child:
                _loading
                    ? const CircularProgressIndicator()
                    : const Text('Enviar depoimento'),
          ),
        ],
      ),
    );
  }
}
