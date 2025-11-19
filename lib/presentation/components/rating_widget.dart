import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final Map<String, int>? categories; // category -> value
  const RatingWidget({super.key, this.categories});

  @override
  Widget build(BuildContext context) {
    final cats = categories ?? {'legal': 0, 'sexy': 0, 'confiavel': 0};
    return Row(
      children:
          cats.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Text(e.key, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    e.value.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
