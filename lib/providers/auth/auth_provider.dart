import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/supabase_client.dart';

class AuthState {
  final String? userId;
  final String? role;
  const AuthState({this.userId, this.role});
}

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  AuthNotifier() : super(const AsyncValue.data(AuthState())) {
    _safeLoad();
  }

  Future<void> _safeLoad() async {
    try {
      final user = SupabaseClientService.getCurrentUser();
      // If no user, set empty state
      if (user == null) {
        state = const AsyncValue.data(AuthState());
        return;
      }

      // Try to read role from metadata, fallback to profiles table if missing
      String? role;
      try {
        role = (user.userMetadata != null && user.userMetadata!['role'] != null)
            ? user.userMetadata!['role'] as String?
            : null;
      } catch (_) {
        role = null;
      }

      if (role == null) {
        try {
          final resp = await SupabaseClientService.client
              .from('profiles')
              .select('role')
              .eq('id', user.id)
              .maybeSingle();
          if (resp != null) {
            role = resp['role'] as String?;
          }
        } catch (_) {
          // ignore lookup errors, role remains null
        }
      }

      state = AsyncValue.data(AuthState(userId: user.id, role: role));
    } catch (_) {}
  }

  Future<void> loginEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await SupabaseClientService.signInEmail(email: email, password: password);
      await _safeLoad();
      try {
        await SupabaseClientService.registerFcmToken();
      } catch (_) {}
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginGoogle() async {
    state = const AsyncValue.loading();
    try {
      await SupabaseClientService.signInWithGoogle();
      // After social sign-in, refresh current user state
      await _safeLoad();
      try {
        await SupabaseClientService.registerFcmToken();
      } catch (_) {}
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      await SupabaseClientService.signUpWithRole(
        email: email,
        password: password,
        role: role,
      );
      await _safeLoad();
      try {
        await SupabaseClientService.registerFcmToken();
      } catch (_) {}
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    try {
      await SupabaseClientService.client.auth.signOut();
    } catch (_) {}
    state = const AsyncValue.data(AuthState());
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>(
  (ref) => AuthNotifier(),
);
