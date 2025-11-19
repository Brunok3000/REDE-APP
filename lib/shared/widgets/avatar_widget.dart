import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
      );
    }

    final text =
        (initials ?? '')
            .split(' ')
            .where((e) => e.isNotEmpty)
            .map((e) => e[0].toUpperCase())
            .take(2)
            .join();

    return CircleAvatar(
      radius: radius,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
