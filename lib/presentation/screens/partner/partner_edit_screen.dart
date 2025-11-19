import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
// removed unused mock_singleton import

class PartnerEditScreen extends ConsumerStatefulWidget {
  const PartnerEditScreen({super.key});

  @override
  ConsumerState<PartnerEditScreen> createState() => _PartnerEditScreenState();
}

class _PartnerEditScreenState extends ConsumerState<PartnerEditScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil do Parceiro'),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome do estabelecimento',
                ),
                initialValue: '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                initialValue: '',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _formKey.currentState?.save();
                    // TODO: persist via partnerRepositoryMock
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Salvo (mock)')),
                    );
                  },
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
