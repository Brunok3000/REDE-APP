import 'package:geolocator/geolocator.dart';
import 'supabase_client.dart';

class GeoService {
  // Obter localização atual do usuário
  static Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // Calcular distância entre dois pontos (em km)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  // Buscar estabelecimentos próximos usando PostGIS (ST_DWithin)
  // Retorna estabelecimentos dentro de um raio (em metros)
  static Future<List<Map<String, dynamic>>> searchNearbyEstablishments({
    required double latitude,
    required double longitude,
    double radiusMeters = 5000, // 5km padrão
    String? type,
    bool? b2bOnly,
  }) async {
    try {
      // Nota: .rpc() não está disponível em supabase_flutter
      // Vamos usar fallback que filtra localmente
      return _fallbackSearch(latitude, longitude, radiusMeters, type, b2bOnly);
    } catch (e) {
      return _fallbackSearch(latitude, longitude, radiusMeters, type, b2bOnly);
    }
  }

  // Fallback: busca sem PostGIS (filtra localmente)
  static Future<List<Map<String, dynamic>>> _fallbackSearch(
    double latitude,
    double longitude,
    double radiusMeters,
    String? type,
    bool? b2bOnly,
  ) async {
    try {
      var query = SupabaseClientService.client.from('establishments').select();

      if (type != null && type.isNotEmpty) {
        query = query.eq('type', type);
      }

      final all = await query;
      final results = <Map<String, dynamic>>[];

      for (var est in all) {
        final location = est['location_point'];
        if (location == null) continue;

        // Extrair lat/lng do geometry (formato pode variar)
        double? estLat;
        double? estLng;

        if (location is Map) {
          estLat = location['coordinates']?[1]?.toDouble();
          estLng = location['coordinates']?[0]?.toDouble();
        }

        if (estLat == null || estLng == null) continue;

        final distance = calculateDistance(latitude, longitude, estLat, estLng);
        if (distance * 1000 <= radiusMeters) {
          // Filtrar B2B se necessário
          if (b2bOnly == true) {
            final services = est['services_json'] as Map<String, dynamic>?;
            if (services?['b2b'] != true) continue;
          }

          results.add({
            ...est,
            'distance_km': distance,
          });
        }
      }

      // Ordenar por distância
      results.sort((a, b) =>
          (a['distance_km'] as double).compareTo(b['distance_km'] as double));

      return results;
    } catch (e) {
      return [];
    }
  }

  // Obter localização aproximada por IP (fallback)
  static Future<Map<String, double>?> getLocationByIP() async {
    try {
      // Usar serviço externo para obter localização por IP
      // Exemplo: ipapi.co, ip-api.com, etc.
      // Por enquanto retorna null (pode implementar depois)
      return null;
    } catch (e) {
      return null;
    }
  }
}
