enum EstablishmentType { hotel, restaurant, service, store, eventSpace, other }

extension EstablishmentTypeX on EstablishmentType {
  String get name {
    return toString().split('.').last;
  }

  static EstablishmentType fromString(String s) {
    switch (s) {
      case 'hotel':
        return EstablishmentType.hotel;
      case 'restaurant':
        return EstablishmentType.restaurant;
      case 'service':
        return EstablishmentType.service;
      case 'store':
        return EstablishmentType.store;
      case 'event_space':
        return EstablishmentType.eventSpace;
      default:
        return EstablishmentType.other;
    }
  }
}
