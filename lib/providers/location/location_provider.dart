import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationState {
  final double? lat;
  final double? lng;
  const LocationState({this.lat, this.lng});
}

final locationProvider = StateProvider<LocationState>((ref) => const LocationState());