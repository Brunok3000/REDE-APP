import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../config/env.dart';

class SupabaseClientService {
  static Future<void> init({String? url, String? anonKey}) async {
    final endpoint = url ?? Env.supabaseUrl;
    final key = anonKey ?? Env.supabaseAnonKey;
    if (endpoint.isEmpty || key.isEmpty) {
      // Fail fast: missing configuration should be explicit
      throw Exception(
        'Supabase URL or ANON_KEY not configured. Set SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define or env.',
      );
    }

    try {
      await Supabase.initialize(
        url: endpoint,
        anonKey: key,
      );
    } catch (e) {
      // Bubble up initialization errors so the app can react (and tests can fail fast)
      rethrow;
    }
  }

  static SupabaseClient get client => Supabase.instance.client;

  // Auth
  static Future<AuthResponse> signInEmail({
    required String email,
    required String password,
  }) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> signInWithGoogle() async {
    // TODO: Implementar OAuth com Google
    // await client.auth.signInWithOAuth(Provider.google);
    throw UnimplementedError('Google OAuth não implementado ainda');
  }

  static Future<AuthResponse> signUpWithRole({
    required String email,
    required String password,
    required String role,
  }) async {
    final resp = await client.auth.signUp(email: email, password: password);
    final user = resp.user;
    if (user != null) {
      await client.auth.updateUser(UserAttributes(data: {'role': role}));
      // create profile row (best-effort)
      try {
        await client.from('profiles').upsert({
          'id': user.id,
          'role': role,
          'name': null,
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {}
    }
    return resp;
  }

  static User? getCurrentUser() => client.auth.currentUser;

  // Storage helper: uploads image to 'posts' bucket and returns public URL
  static Future<String?> uploadImage({
    required String path,
    required Uint8List bytes,
  }) async {
    final filePath = path;
    try {
      await client.storage.from('posts').uploadBinary(filePath, bytes);
    } catch (e) {
      return null;
    }
    try {
      final publicUrl = client.storage.from('posts').getPublicUrl(filePath);
      return publicUrl.toString();
    } catch (e) {
      return null;
    }
  }

  // Subscribe to orders for an establishment (realtime) - returns a StreamSubscription or channel handle
  static dynamic subscribeOrders(
    String establishmentId,
    Function(dynamic) callback,
  ) {
    try {
      final stream = client
          .from('orders')
          .stream(primaryKey: ['id'])
          .eq('establishment_id', establishmentId);
      final sub = stream.listen((event) {
        try {
          // event may be SupabaseStreamEvent or a list of rows depending on API version
          callback(event);
        } catch (_) {}
      });
      return sub;
    } catch (e) {
      // fallback: return null if API differs
      return null;
    }
  }

  // Simple helper to call Edge Function
  static Future<dynamic> notifyNewOrder(Map<String, dynamic> order) async {
    try {
      final functions = client.functions;
      final resp = await functions.invoke(
        'new_order_notification',
        body: order,
      );
      return resp;
    } catch (e) {
      return null;
    }
  }

  // Register current device FCM token into profiles.fcm_token for the current user
  static Future<void> registerFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      final user = client.auth.currentUser;
      if (user == null) return;
      // Upsert profile with fcm_token (best-effort)
      await client.from('profiles').upsert({
        'id': user.id,
        'fcm_token': token,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // ignore errors - non-fatal
    }
  }
}
