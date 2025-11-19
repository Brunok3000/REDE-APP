// Core Service: Supabase Service
// Temporarily ignore some analyzer errors here because supabase API versions vary
// and Supabase integration will be completed in a later step.
// ignore_for_file: undefined_method, argument_type_not_assignable
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  late SupabaseClient _client;

  SupabaseClient get client => _client;

  User? get currentUser => _client.auth.currentUser;

  bool get isAuthenticated => _client.auth.currentUser != null;

  Future<void> initialize() async {
    _client = Supabase.instance.client;
  }

  // ========== Auth Methods ==========

  /// Registrar novo usuário (user ou partner)
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String userType, // 'user' or 'partner'
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'user_type': userType},
      );

      if (response.user != null) {
        // Criar registro do usuário na tabela public.users
        await _client.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
          'user_type': userType,
          'is_verified': false,
        });
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Login com email e password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Logout
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Recuperar senha
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // ========== User Methods ==========

  /// Obter dados do usuário atual
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final response =
          await _client
              .from('users')
              .select()
              .eq('id', currentUser!.id)
              .single();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Atualizar perfil do usuário
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      await _client
          .from('users')
          .update({
            if (fullName != null) 'full_name': fullName,
            if (username != null) 'username': username,
            if (bio != null) 'bio': bio,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // ========== Establishment Methods ==========

  /// Obter todos os estabelecimentos ativos
  Future<List<Map<String, dynamic>>> getEstablishments({
    String? category,
    String? city,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      var query = _client
          .from('establishments')
          .select()
          .eq('is_active', true)
          .range(offset, offset + limit - 1);

      if (category != null) {
        query = query.eq('category', category);
      }
      if (city != null) {
        query = query.eq('city', city);
      }

      return await query;
    } catch (e) {
      rethrow;
    }
  }

  /// Buscar estabelecimentos por localização (geosearch)
  Future<List<Map<String, dynamic>>> getNearbyEstablishments({
    required double latitude,
    required double longitude,
    double radiusKm = 5,
  }) async {
    try {
      return await _client.rpc(
        'nearby_establishments',
        params: {
          'user_lat': latitude,
          'user_lon': longitude,
          'radius_km': radiusKm,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Busca full-text em estabelecimentos
  Future<List<Map<String, dynamic>>> searchEstablishments(String query) async {
    try {
      return await _client
          .from('establishments')
          .select()
          .textSearch('search_vector', query)
          .eq('is_active', true);
    } catch (e) {
      rethrow;
    }
  }

  /// Obter detalhes de um estabelecimento
  Future<Map<String, dynamic>> getEstablishmentDetail(
    String establishmentId,
  ) async {
    try {
      return await _client
          .from('establishments')
          .select()
          .eq('id', establishmentId)
          .single();
    } catch (e) {
      rethrow;
    }
  }

  /// Criar novo estabelecimento (para parceiros)
  Future<String> createEstablishment({
    required String name,
    required String category,
    required String address,
    required String city,
    required String state,
    String? description,
    String? phone,
    String? email,
    double? latitude,
    double? longitude,
    bool offersDelivery = false,
    bool offersReservation = false,
    bool offersEvents = false,
    bool offersServices = false,
  }) async {
    try {
      final response =
          await _client
              .from('establishments')
              .insert({
                'partner_id': currentUser!.id,
                'name': name,
                'category': category,
                'address': address,
                'city': city,
                'state': state,
                'description': description,
                'phone': phone,
                'email': email,
                'latitude': latitude,
                'longitude': longitude,
                'offers_delivery': offersDelivery,
                'offers_reservation': offersReservation,
                'offers_events': offersEvents,
                'offers_services': offersServices,
              })
              .select()
              .single();

      return response['id'];
    } catch (e) {
      rethrow;
    }
  }

  // ========== Post Methods ==========

  /// Obter feed de posts com realtime
  Stream<List<Map<String, dynamic>>> getPostsFeed({
    int limit = 20,
    int offset = 0,
  }) {
    return _client
        .from('posts_with_user')
        .stream(primaryKey: ['id'])
        .eq('is_public', true)
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1)
        .map((event) => List<Map<String, dynamic>>.from(event));
  }

  /// Criar novo post
  Future<String> createPost({
    required String content,
    List<String> imageUrls = const [],
    bool isPublic = true,
    String? establishmentId,
  }) async {
    try {
      final response =
          await _client
              .from('posts')
              .insert({
                'user_id': currentUser!.id,
                'establishment_id': establishmentId,
                'content': content,
                'image_urls': imageUrls,
                'is_public': isPublic,
              })
              .select()
              .single();

      return response['id'];
    } catch (e) {
      rethrow;
    }
  }

  /// Dar like em um post
  Future<void> likePost(String postId) async {
    try {
      await _client.from('likes').insert({
        'user_id': currentUser!.id,
        'post_id': postId,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Remover like de um post
  Future<void> unlikePost(String postId) async {
    try {
      await _client
          .from('likes')
          .delete()
          .eq('user_id', currentUser!.id)
          .eq('post_id', postId);
    } catch (e) {
      rethrow;
    }
  }

  /// Comentar em um post
  Future<String> commentPost(String postId, String content) async {
    try {
      final response =
          await _client
              .from('comments')
              .insert({
                'post_id': postId,
                'user_id': currentUser!.id,
                'content': content,
              })
              .select()
              .single();

      return response['id'];
    } catch (e) {
      rethrow;
    }
  }

  // ========== Reservation Methods ==========

  /// Criar reserva (quartos, mesas, serviços)
  Future<String> createReservation({
    required String establishmentId,
    required String reservationType, // 'room', 'table', 'service', 'event'
    required double totalPrice,
    String? roomId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? numberOfGuests,
    String? tableNumber,
    DateTime? reservationTime,
    int? partySize,
    String? serviceId,
    DateTime? scheduledDate,
    String? notes,
  }) async {
    try {
      final response =
          await _client
              .from('reservations')
              .insert({
                'user_id': currentUser!.id,
                'establishment_id': establishmentId,
                'reservation_type': reservationType,
                'total_price': totalPrice,
                'room_id': roomId,
                'check_in_date': checkInDate?.toIso8601String(),
                'check_out_date': checkOutDate?.toIso8601String(),
                'number_of_guests': numberOfGuests,
                'table_number': tableNumber,
                'reservation_time': reservationTime?.toIso8601String(),
                'party_size': partySize,
                'service_id': serviceId,
                'scheduled_date': scheduledDate?.toIso8601String(),
                'notes': notes,
              })
              .select()
              .single();

      return response['id'];
    } catch (e) {
      rethrow;
    }
  }

  /// Obter minhas reservas
  Future<List<Map<String, dynamic>>> getMyReservations() async {
    try {
      return await _client
          .from('reservations_details')
          .select()
          .eq('user_id', currentUser!.id)
          .order('created_at', ascending: false);
    } catch (e) {
      rethrow;
    }
  }

  /// Cancelar reserva
  Future<void> cancelReservation(String reservationId) async {
    try {
      await _client
          .from('reservations')
          .update({
            'status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', reservationId);
    } catch (e) {
      rethrow;
    }
  }

  // ========== Order Methods ==========

  /// Criar pedido
  Future<String> createOrder({
    required String establishmentId,
    required String orderType, // 'delivery', 'takeaway'
    required double totalPrice,
    String? deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? specialInstructions,
  }) async {
    try {
      final response =
          await _client
              .from('orders')
              .insert({
                'user_id': currentUser!.id,
                'establishment_id': establishmentId,
                'order_type': orderType,
                'total_price': totalPrice,
                'delivery_address': deliveryAddress,
                'delivery_latitude': deliveryLatitude,
                'delivery_longitude': deliveryLongitude,
                'special_instructions': specialInstructions,
              })
              .select()
              .single();

      return response['id'];
    } catch (e) {
      rethrow;
    }
  }

  /// Obter meus pedidos
  Future<List<Map<String, dynamic>>> getMyOrders() async {
    try {
      return await _client
          .from('orders_details')
          .select()
          .eq('user_id', currentUser!.id)
          .order('created_at', ascending: false);
    } catch (e) {
      rethrow;
    }
  }

  // ========== Storage Methods (Upload de imagens) ==========

  /// Upload de imagem para post
  Future<String> uploadPostImage(String filePath) async {
    try {
      final file = await _readFile(filePath);
      final fileName =
          'posts/${currentUser!.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await _client.storage.from('posts').uploadBinary(fileName, file);

      final url = _client.storage.from('posts').getPublicUrl(fileName);
      return url;
    } catch (e) {
      rethrow;
    }
  }

  /// Upload de avatar de usuário
  Future<String> uploadAvatar(String filePath) async {
    try {
      final file = await _readFile(filePath);
      final fileName = 'avatars/${currentUser!.id}.jpg';

      await _client.storage
          .from('avatars')
          .uploadBinary(
            fileName,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      final url = _client.storage.from('avatars').getPublicUrl(fileName);
      return url;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> _readFile(String filePath) async {
    // Implementar leitura real de arquivo quando integrado com image_picker
    return [];
  }
}
