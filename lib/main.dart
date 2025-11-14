import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'services/supabase_client.dart';
import 'screens/feed/feed_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/discover/discover_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'widgets/bottom_nav/bottom_nav.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/discover/establishment_profile_screen.dart';
import 'models/establishment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientService.init();
  // Initialize Firebase for push notifications (FCM)
  try {
    await Firebase.initializeApp();
    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Request permission (mobile/web will prompt as needed)
    await FirebaseMessaging.instance.requestPermission();
    // If user already logged, register token to profiles
    await SupabaseClientService.registerFcmToken();
    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // For now, just print. UI can listen to events if needed.
      debugPrint(
        'FCM onMessage: ${message.notification?.title} - ${message.notification?.body}',
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM opened app: ${message.messageId}');
    });
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  runApp(const ProviderScope(child: RedeApp()));
}

// Top level background handler required by firebase_messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background message: ${message.messageId}');
}

class RedeApp extends StatelessWidget {
  const RedeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = _buildRouter();
    return MaterialApp.router(
      title: 'rede',
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}

GoRouter _buildRouter() {
  return GoRouter(
    redirect: (context, state) {
      // Simple guard using current Supabase user. If not logged we redirect to /login
      final user = SupabaseClientService.getCurrentUser();
      final loggedIn = user != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      if (!loggedIn && !isAuthRoute) return '/login';
      if (loggedIn && state.matchedLocation == '/login') return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/establishment/:id',
        builder: (context, state) {
          // Refetch establishment a partir do ID
          final estId = state.pathParameters['id'] ?? '';
          return _EstablishmentProfileWrapper(establishmentId: estId);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => BottomNav(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const FeedScreen()),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/discover',
            builder: (context, state) => const DiscoverScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}

// Wrapper para refetch establishment
class _EstablishmentProfileWrapper extends StatelessWidget {
  final String establishmentId;

  const _EstablishmentProfileWrapper({required this.establishmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carregando...')),
      body: FutureBuilder(
        future: SupabaseClientService.client
            .from('establishments')
            .select()
            .eq('id', establishmentId)
            .single(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Estabelecimento não encontrado'));
          }

          final establishment =
              Establishment.fromJson(snapshot.data as Map<String, dynamic>);
          return EstablishmentProfileScreen(establishment: establishment);
        },
      ),
    );
  }
}
