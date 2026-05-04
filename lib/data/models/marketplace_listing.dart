import 'affiliate_business.dart';

enum ListingCategory { apuntes, servicios, articulos, freelance }

enum ListingType { studentListing, affiliateBusiness }

extension ListingCategoryLabel on ListingCategory {
  String get label => switch (this) {
        ListingCategory.apuntes => 'Apuntes',
        ListingCategory.servicios => 'Servicios',
        ListingCategory.articulos => 'Artículos',
        ListingCategory.freelance => 'Freelance',
      };
}

class MarketplaceListing {
  const MarketplaceListing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.type,
    required this.isBoosted,
    required this.isAffiliate,
    required this.sellerName,
    this.sellerAvatarUrl,
    this.serviceType,
    required this.imageUrls,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final ListingCategory category;
  final ListingType type;
  final bool isBoosted;
  final bool isAffiliate;
  final String sellerName;
  final String? sellerAvatarUrl;
  final AffiliateServiceType? serviceType;
  final List<String> imageUrls;
  final DateTime publishedAt;
}
