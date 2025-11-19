import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class Style9BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final List<NavBarItem> items;

  const Style9BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        // use 'surface' em vez de 'background' (background está deprecado em Material 3)
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.neutral30.withAlpha((0.5 * 255).round()),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral60.withAlpha((0.2 * 255).round()),
            blurRadius: 3.r,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: AppColors.primaryAccent,
          unselectedItemColor: AppColors.neutral60,
          items:
              items.map((item) {
                return BottomNavigationBarItem(
                  icon: item.icon,
                  label: item.title,
                  activeIcon: item.icon,
                  backgroundColor: theme.colorScheme.surface,
                );
              }).toList(),
        ),
      ),
    );
  }
}

class NavBarItem {
  final Widget icon;
  final String title;

  NavBarItem({required this.icon, required this.title});
}
