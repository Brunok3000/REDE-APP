import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../providers/auth/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    ref.listen(authProvider, (prev, next) {
      // Navegar para trás quando o auth tiver um usuário válido (login bem-sucedido)
      try {
        next.when(
          data: (s) {
            final prevUserId = prev?.value?.userId;
            final newUserId = s.userId;
            if (newUserId != null && newUserId != prevUserId) {
              if (mounted) Navigator.of(context).pop();
            }
          },
          loading: () {},
          error: (e, st) {
            Fluttertoast.showToast(msg: e.toString());
          },
        );
      } catch (_) {
        // ignore
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      final notifier = ref.read(authProvider.notifier);
                      try {
                        await notifier.loginEmail(_email.text, _password.text);

                        // Após o login, o listener acima (ref.listen) irá
                        // detectar a mudança de estado e cuidar da navegação.
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: 'Erro ao entrar: ${e.toString()}',
                        );
                      }
                    },
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).loginGoogle();
              },
              child: const Text('Entrar com Google'),
            ),
          ],
        ),
      ),
    );
  }
}
