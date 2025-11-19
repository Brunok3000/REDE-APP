import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rede/models/room.dart';
import 'package:rede/repositories/mock/mock_singleton.dart';

class RoomForm extends ConsumerStatefulWidget {
  final Room? room;
  final String partnerId;
  const RoomForm({super.key, this.room, required this.partnerId});

  @override
  ConsumerState<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends ConsumerState<RoomForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  late double _price;
  late int _capacity;

  @override
  void initState() {
    super.initState();
    _title = widget.room?.title ?? '';
    _description = widget.room?.description;
    _price = widget.room?.price ?? 0.0;
    _capacity = widget.room?.capacity ?? 1;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final r = Room(
      id: widget.room?.id ?? '',
      partnerId: widget.partnerId,
      title: _title,
      description: _description,
      price: _price,
      capacity: _capacity,
    );
    if (widget.room == null) {
      await roomRepositoryMock.create(r);
    } else {
      await roomRepositoryMock.update(r);
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
                decoration: const InputDecoration(labelText: 'Título'),
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
              TextFormField(
                initialValue: _capacity.toString(),
                decoration: const InputDecoration(labelText: 'Capacidade'),
                keyboardType: TextInputType.number,
                validator:
                    (v) =>
                        (v == null || int.tryParse(v) == null)
                            ? 'Capacidade inválida'
                            : null,
                onSaved: (v) => _capacity = int.tryParse(v ?? '1') ?? 1,
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
