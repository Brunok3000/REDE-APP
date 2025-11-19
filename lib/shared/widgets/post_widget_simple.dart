import 'dart:async';

import 'package:flutter/material.dart';
import '../models/post.dart';
import 'custom_image.dart';

/// Widget simples para exibir um post (UI-only).
/// Use callbacks para integrar com SupabaseService ou repositórios.
class PostWidgetSimple extends StatefulWidget {
  final PostModel post;
  final VoidCallback? onTapUser;
  final VoidCallback? onDelete;
  final FutureOr<void> Function()? onLike;
  final FutureOr<void> Function(String comment)? onComment;

  const PostWidgetSimple({
    super.key,
    required this.post,
    this.onTapUser,
    this.onDelete,
    this.onLike,
    this.onComment,
  });

  @override
  State<PostWidgetSimple> createState() => _PostWidgetSimpleState();
}

class _PostWidgetSimpleState extends State<PostWidgetSimple> {
  late int likeCount;
  late bool isLiked;
  late Map<String, dynamic> likes;
  bool showHeart = false;

  @override
  void initState() {
    super.initState();
    likes = Map<String, dynamic>.from(widget.post.likes);
    likeCount = widget.post.getLikeCount();
    // isLiked initial unknown; default false — caller can sync via callbacks
    isLiked = false;
  }

  void _handleLike() async {
    // toggle optimistic UI
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      showHeart = isLiked;
    });

    if (widget.onLike != null) {
      try {
        await widget.onLike!();
      } catch (e) {
        // rollback on error
        setState(() {
          isLiked = !isLiked;
          likeCount += isLiked ? 1 : -1;
          showHeart = false;
        });
      }
    }

    if (showHeart) {
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => showHeart = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(p.mediaUrl),
            backgroundColor: Colors.grey.shade200,
          ),
          title: GestureDetector(
            onTap: widget.onTapUser,
            child: Text(
              p.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(p.location),
          trailing:
              widget.onDelete != null
                  ? IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.more_vert),
                  )
                  : null,
        ),

        // Image + heart
        GestureDetector(
          onDoubleTap: _handleLike,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 260,
                width: double.infinity,
                child: customNetworkImageWrapper(p.mediaUrl),
              ),
              if (showHeart)
                const Icon(Icons.favorite, size: 80, color: Colors.red),
            ],
          ),
        ),

        // Footer actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: _handleLike,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  // open comment UI externally
                  if (widget.onComment != null) await widget.onComment!('');
                },
                icon: const Icon(Icons.chat, color: Colors.blueAccent),
              ),
              const Spacer(),
              Text(
                '$likeCount likes',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                p.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(p.description)),
            ],
          ),
        ),
      ],
    );
  }
}

// Helper wrapper to call cachedNetworkImage but keep a small API boundary
Widget customNetworkImageWrapper(String url) =>
    url.isEmpty
        ? Container(color: Colors.grey.shade200)
        : cachedNetworkImage(url);
