import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../models/post.dart';
import '../../services/supabase_client.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Provider para posts
final postsProvider = StreamProvider<List<Post>>((ref) async* {
  final client = SupabaseClientService.client;

  // Stream inicial
  final initial = await client
      .from('posts')
      .select()
      .order('created_at', ascending: false)
      .limit(20);

  yield (initial as List).map((p) => Post.fromJson(p)).toList();

  // Realtime subscription
  final stream = client
      .from('posts')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);

  await for (final data in stream) {
    if (data.isNotEmpty) {
      yield data.map((p) => Post.fromJson(p)).toList();
    }
  }
});

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePostModal(context, ref),
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(
              child: Text('Nenhum post ainda. Seja o primeiro!'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(postsProvider);
            },
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: posts[index]);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erro ao carregar posts: $err'),
              ElevatedButton(
                onPressed: () => ref.invalidate(postsProvider),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePostModal(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authProvider);
    final userId = auth.value?.userId;
    if (userId == null) {
      Fluttertoast.showToast(msg: 'Faça login para criar posts');
      return;
    }

    final contentController = TextEditingController();
    Uint8List? selectedImage;
    String? imagePath;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Criar Post',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    hintText: 'O que está acontecendo?',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                if (selectedImage != null)
                  Image.memory(selectedImage!, height: 200, fit: BoxFit.cover),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          final bytes = await image.readAsBytes();
                          setState(() {
                            selectedImage = bytes;
                            imagePath =
                                'posts/${DateTime.now().millisecondsSinceEpoch}.jpg';
                          });
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Adicionar imagem'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (contentController.text.trim().isEmpty &&
                        selectedImage == null) {
                      Fluttertoast.showToast(msg: 'Adicione texto ou imagem');
                      return;
                    }

                    try {
                      String? imageUrl;
                      if (selectedImage != null && imagePath != null) {
                        imageUrl = await SupabaseClientService.uploadImage(
                          path: imagePath!,
                          bytes: selectedImage!,
                        );
                      }

                      await SupabaseClientService.client.from('posts').insert({
                        'author_id': userId,
                        'content': contentController.text.trim().isEmpty
                            ? null
                            : contentController.text.trim(),
                        'images': imageUrl != null ? [imageUrl] : null,
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: 'Post criado!');
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'Erro: $e');
                    }
                  },
                  child: const Text('Publicar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.content != null) ...[
              Text(post.content!, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),
            ],
            if (post.images != null && post.images!.isNotEmpty)
              ...post.images!.map(
                (img) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CachedNetworkImage(
                    imageUrl: img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // TODO: Implementar like
                  },
                ),
                Text('${post.likes}'),
                const Spacer(),
                if (post.createdAt != null)
                  Text(
                    _formatDate(post.createdAt!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays}d atrás';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h atrás';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m atrás';
    } else {
      return 'Agora';
    }
  }
}
