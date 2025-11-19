import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Serviço reutilizável para geolocalização
/// Adapta as chamadas legadas (Geolocator()) para a API atual.
class GeolocationService {
  /// Requisita permissões de localização e retorna true se concedidas.
  static Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Retorna a posição atual do dispositivo (lança exceção se serviço/permissão inválida).
  static Future<Position> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    final hasPermission = await requestPermission();
    if (!hasPermission) {
      throw Exception('Location permission denied.');
    }

    // A API mais nova recomenda usar LocationSettings ao invés de desiredAccuracy
    final settings = LocationSettings(accuracy: accuracy);
    return await Geolocator.getCurrentPosition(locationSettings: settings);
  }

  /// Converte uma [Position] em um endereço formatado (ex: 'Cidade, País').
  static Future<String> getAddressFromPosition(Position pos) async {
    final placemarks = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );
    if (placemarks.isEmpty) return '';
    final p = placemarks.first;
    final parts = <String>[];
    if (p.locality != null && p.locality!.isNotEmpty) parts.add(p.locality!);
    if (p.country != null && p.country!.isNotEmpty) parts.add(p.country!);
    return parts.join(', ');
  }
}
