import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BasicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const BasicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
