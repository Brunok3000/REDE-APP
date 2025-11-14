import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../providers/auth/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _role = 'consumer';

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    ref.listen(authProvider, (prev, next) {
      next.whenOrNull(error: (e, _) => Fluttertoast.showToast(msg: e.toString()));
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _password, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: _role,
            items: const [
              DropdownMenuItem(value: 'consumer', child: Text('Consumidor')),
              DropdownMenuItem(value: 'partner', child: Text('Parceiro')),
            ],
            onChanged: (v) => setState(() => _role = v ?? 'consumer'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: auth.isLoading
                ? null
                : () async {
                    final navigator = Navigator.of(context);
                    await ref.read(authProvider.notifier).register(_email.text, _password.text, _role);
                    navigator.pop();
                  },
            child: const Text('Criar conta'),
          ),
        ]),
      ),
    );
  }
}