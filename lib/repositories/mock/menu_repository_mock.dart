import 'dart:collection';
import 'package:uuid/uuid.dart';
import '../../models/menu_item.dart';

class MenuRepositoryMock {
  final Map<String, MenuItem> _store = {};
  final Uuid _uuid = Uuid();

  Future<MenuItem> create(MenuItem m) async {
    final id = m.id.isEmpty ? _uuid.v4() : m.id;
    final item = MenuItem(
      id: id,
      partnerId: m.partnerId,
      title: m.title,
      description: m.description,
      price: m.price,
      photos: m.photos,
      tags: m.tags,
    );
    _store[id] = item;
    return item;
  }

  Future<void> update(MenuItem m) async {
    if (_store.containsKey(m.id)) _store[m.id] = m;
  }

  Future<void> delete(String id) async {
    _store.remove(id);
  }

  Future<List<MenuItem>> listByPartner(String partnerId) async =>
      UnmodifiableListView(
        _store.values.where((i) => i.partnerId == partnerId),
      ).toList();
}
