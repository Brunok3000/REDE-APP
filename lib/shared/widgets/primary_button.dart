import 'package:flutter/material.dart';

/// Botão primário reutilizável com variantes (filled, outlined, text)
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool outlined;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
    this.outlined = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        color: filled ? Colors.white : theme.colorScheme.primary,
      ),
    );

    final ButtonStyle style =
        filled
            ? ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )
            : outlined
            ? OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )
            : TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            );

    final button =
        filled
            ? ElevatedButton(onPressed: onPressed, style: style, child: child)
            : outlined
            ? OutlinedButton(onPressed: onPressed, style: style, child: child)
            : TextButton(onPressed: onPressed, style: style, child: child);

    return SizedBox(width: width, child: button);
  }
}
