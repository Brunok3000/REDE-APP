import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Recuperar senha'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed:
                  _isLoading
                      ? null
                      : () async {
                        setState(() {
                          _isLoading = true;
                          _message = null;
                        });
                        // TODO: Implementar envio de recuperação via Supabase
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {
                          _isLoading = false;
                          _message = 'Enviado (mock)';
                        });
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Enviar link de recuperação'),
            ),
            if (_message != null) ...[
              const SizedBox(height: 12),
              Text(_message!),
            ],
          ],
        ),
      ),
    );
  }
}
