import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../models/post.dart';

class PostRepositoryMock {
  final Map<String, Post> _store = {};
  final _uuid = Uuid();

  // simple stream controller so UI can listen if desired
  final StreamController<List<Post>> _controller = StreamController.broadcast();

  PostRepositoryMock();

  Future<List<Post>> listAll() async {
    // return newest first
    final all =
        _store.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Future.value(all);
  }

  Stream<List<Post>> watchAll() => _controller.stream;

  Future<Post> create({
    required String authorId,
    required String authorName,
    String? authorAvatar,
    required String content,
  }) async {
    final id = _uuid.v4();
    final post = Post(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorAvatar: authorAvatar,
      content: content,
      likedBy: <String>[],
      commentsCount: 0,
      createdAt: DateTime.now(),
    );
    _store[id] = post;
    _emit();
    return Future.value(post);
  }

  Future<void> like(String id, String userId) async {
    final p = _store[id];
    if (p != null) {
      if (!p.likedBy.contains(userId)) {
        p.likedBy.add(userId);
        _store[id] = p;
        _emit();
      }
    }
  }

  Future<void> unlike(String id, String userId) async {
    final p = _store[id];
    if (p != null) {
      if (p.likedBy.contains(userId)) {
        p.likedBy.remove(userId);
        _store[id] = p;
        _emit();
      }
    }
  }

  Future<Post?> getById(String id) async {
    return _store[id];
  }

  void _emit() {
    try {
      final all =
          _store.values.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (!_controller.isClosed) _controller.add(all);
    } catch (_) {}
  }

  void dispose() {
    _controller.close();
  }
}
