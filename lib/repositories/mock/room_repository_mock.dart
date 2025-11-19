import 'dart:collection';
import 'package:uuid/uuid.dart';
import '../../models/room.dart';

class RoomRepositoryMock {
  final Map<String, Room> _store = {};
  final Uuid _uuid = Uuid();

  Future<Room> create(Room r) async {
    final id = r.id.isEmpty ? _uuid.v4() : r.id;
    final room = Room(
      id: id,
      partnerId: r.partnerId,
      title: r.title,
      description: r.description,
      photos: r.photos,
      price: r.price,
      capacity: r.capacity,
      availability: r.availability,
    );
    _store[id] = room;
    return room;
  }

  Future<void> update(Room r) async {
    if (_store.containsKey(r.id)) _store[r.id] = r;
  }

  Future<void> delete(String id) async {
    _store.remove(id);
  }

  Future<List<Room>> listByPartner(String partnerId) async =>
      UnmodifiableListView(
        _store.values.where((r) => r.partnerId == partnerId),
      ).toList();
}
