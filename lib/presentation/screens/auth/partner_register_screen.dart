import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';
import 'package:rede/models/partner_profile.dart';
import 'package:uuid/uuid.dart';

class PartnerRegisterScreen extends StatefulWidget {
  const PartnerRegisterScreen({super.key});

  @override
  State<PartnerRegisterScreen> createState() => _PartnerRegisterScreenState();
}

class _PartnerRegisterScreenState extends State<PartnerRegisterScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreatePartner(String? userIdFromQuery) async {
    setState(() => _isLoading = true);
    final uuid = Uuid();
    // determine owner user id: prefer provided value, else current user, else generate
    String ownerId = userIdFromQuery ?? '';
    if (ownerId.isEmpty) {
      final current = await userRepositoryMock.getCurrentUser();
      ownerId = current?.id ?? uuid.v4();
    }
    final partner = PartnerProfile(
      id: uuid.v4(),
      userId: ownerId,
      name:
          _nameController.text.isEmpty
              ? 'Meu Estabelecimento'
              : _nameController.text,
      description: _descriptionController.text,
      active: false,
    );
    await partnerRepositoryMock.createPartner(partner);
    if (mounted) {
      context.go('/partner-dashboard?partnerId=${partner.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // owner user id will be resolved from current user if available
    final userId = null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        title: const Text('Cadastro de Parceiro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Estabelecimento',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _handleCreatePartner(userId),
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Criar Perfil de Parceiro'),
            ),
          ],
        ),
      ),
    );
  }
}
