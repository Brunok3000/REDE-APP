import 'package:flutter/material.dart';
import '../models/post.dart';
import 'custom_image.dart';

/// Pequeno widget reutilizável que exibe a imagem de um post e aceita um callback
class PostTile extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;

  const PostTile({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
