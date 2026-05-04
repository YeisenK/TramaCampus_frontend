enum AffiliateServiceType {
  restaurant,
  gym,
  salon,
  copyshop,
  laundry,
  tutoring,
  brand,
  rental,
}

extension AffiliateServiceTypeLabel on AffiliateServiceType {
  String get label => switch (this) {
    AffiliateServiceType.restaurant => 'Restaurante',
    AffiliateServiceType.gym => 'Gym',
    AffiliateServiceType.salon => 'Salón / Barbería',
    AffiliateServiceType.copyshop => 'Copistería',
    AffiliateServiceType.laundry => 'Lavandería',
    AffiliateServiceType.tutoring => 'Tutorías',
    AffiliateServiceType.brand => 'Marca / Sponsor',
    AffiliateServiceType.rental => 'Renta / Roomie',
  };
}

class AffiliateBusiness {
  const AffiliateBusiness({
    required this.id,
    required this.name,
    required this.description,
    required this.serviceType,
    this.isVerified = true,
    this.menuPdfUrl,
    required this.promotions,
    required this.acceptsReservations,
    required this.acceptsOrders,
    required this.contactChannel,
  });

  final String id;
  final String name;
  final String description;
  final AffiliateServiceType serviceType;
  final bool isVerified;
  final String? menuPdfUrl;
  final List<String> promotions;
  final bool acceptsReservations;
  final bool acceptsOrders;
  final String contactChannel;
}
