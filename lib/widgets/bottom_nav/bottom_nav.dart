import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth/auth_provider.dart';

class BottomNav extends ConsumerStatefulWidget {
  final Widget child;
  const BottomNav({super.key, required this.child});

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final role = auth.value?.role;
    final isPartner = role == 'partner';

    // Destinos diferentes baseado no role
    final destinations = isPartner
        ? const [
            NavigationDestination(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.point_of_sale),
              label: 'POS',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long),
              label: 'Pedidos',
            ),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Config'),
          ]
        : const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
            NavigationDestination(
              icon: Icon(Icons.explore),
              label: 'Descobrir',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long),
              label: 'Pedidos',
            ),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Config'),
          ];

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        destinations: destinations,
        onDestinationSelected: (i) {
          setState(() => index = i);
          if (isPartner) {
            // Navegação para parceiros
            switch (i) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/pos');
                break;
              case 2:
                context.go('/orders');
                break;
              case 3:
                context.go('/settings');
                break;
            }
          } else {
            // Navegação para consumidores
            switch (i) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/search');
                break;
              case 2:
                context.go('/discover');
                break;
              case 3:
                context.go('/orders');
                break;
              case 4:
                context.go('/settings');
                break;
            }
          }
        },
      ),
    );
  }
}
