import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rede/models/menu_item.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';

class MenuItemForm extends ConsumerStatefulWidget {
  final MenuItem? item;
  final String partnerId;
  const MenuItemForm({super.key, this.item, required this.partnerId});

  @override
  ConsumerState<MenuItemForm> createState() => _MenuItemFormState();
}

class _MenuItemFormState extends ConsumerState<MenuItemForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  late double _price;

  @override
  void initState() {
    super.initState();
    _title = widget.item?.title ?? '';
    _description = widget.item?.description;
    _price = widget.item?.price ?? 0.0;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final m = MenuItem(
      id: widget.item?.id ?? '',
      partnerId: widget.partnerId,
      title: _title,
      description: _description,
      price: _price,
    );
    if (widget.item == null) {
      await menuRepositoryMock.create(m);
    } else {
      await menuRepositoryMock.update(m);
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Nome do prato'),
                validator:
                    (v) =>
                        (v == null || v.isEmpty) ? 'Informe um título' : null,
                onSaved: (v) => _title = v ?? '',
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (v) => _description = v,
                maxLines: 3,
              ),
              TextFormField(
                initialValue: _price == 0.0 ? '' : _price.toString(),
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator:
                    (v) =>
                        (v == null || double.tryParse(v) == null)
                            ? 'Preço inválido'
                            : null,
                onSaved: (v) => _price = double.tryParse(v ?? '0') ?? 0.0,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
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
