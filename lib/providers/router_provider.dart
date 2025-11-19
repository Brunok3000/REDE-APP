import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/home/home_screen.dart';
// removed unused import of search_screen.dart
import '../presentation/screens/search/unified_search_screen.dart';
import '../presentation/screens/discover/discover_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/notifications/notifications_screen.dart';
import '../presentation/screens/orders/orders_screen.dart';
import '../presentation/screens/reservations/reservations_screen.dart';
import '../presentation/screens/auth/partner_register_screen.dart';
import '../presentation/screens/partner/partner_dashboard_screen.dart';
import '../presentation/screens/partner/partner_edit_screen.dart';
import '../presentation/screens/partner/partner_rooms_screen.dart';
import '../presentation/screens/partner/partner_menu_screen.dart';
import '../presentation/screens/partner/partner_bookings_screen.dart';
import '../core/guards/partner_guard.dart';
import '../presentation/screens/profile/testimonials_screen.dart';
import '../presentation/screens/profile/visitors_screen.dart';
import '../presentation/screens/partner/partner_public_screen.dart';

import '../core/config/app_config.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: AppConfig.demoMode ? '/' : '/login',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const UnifiedSearchScreen(),
      ),
      GoRoute(
        path: '/discover',
        name: 'discover',
        builder: (context, state) => const DiscoverScreen(),
      ),
      GoRoute(
        path: '/feed',
        name: 'feed',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/reservations',
        name: 'reservations',
        builder: (context, state) => const ReservationsScreen(),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/partner-register',
        name: 'partner-register',
        builder: (context, state) => const PartnerRegisterScreen(),
      ),
      GoRoute(
        path: '/partner-dashboard',
        name: 'partner-dashboard',
        builder:
            (context, state) =>
                const PartnerGuard(child: PartnerDashboardScreen()),
      ),
      GoRoute(
        path: '/partner-edit',
        name: 'partner-edit',
        builder:
            (context, state) => const PartnerGuard(child: PartnerEditScreen()),
      ),
      GoRoute(
        path: '/partner-rooms',
        name: 'partner-rooms',
        builder:
            (context, state) => const PartnerGuard(child: PartnerRoomsScreen()),
      ),
      GoRoute(
        path: '/partner-menu',
        name: 'partner-menu',
        builder:
            (context, state) => const PartnerGuard(child: PartnerMenuScreen()),
      ),
      GoRoute(
        path: '/partner-bookings',
        name: 'partner-bookings',
        builder:
            (context, state) =>
                const PartnerGuard(child: PartnerBookingsScreen()),
      ),
      GoRoute(
        path: '/partner-public',
        name: 'partner-public',
        builder: (context, state) => const PartnerPublicScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/testimonials',
        name: 'testimonials',
        builder: (context, state) => const TestimonialsScreen(),
      ),
      GoRoute(
        path: '/visitors',
        name: 'visitors',
        builder: (context, state) => const VisitorsScreen(),
      ),
    ],
  );
});
