import '../mock/mock_data.dart';
import '../models/affiliate_business.dart';
import '../models/marketplace_listing.dart';

class MarketplaceRepository {
  MarketplaceRepository._();
  static final MarketplaceRepository instance = MarketplaceRepository._();

  Future<List<AffiliateBusiness>> getAffiliateBusinesses() async {
    return List.of(MockData.mockAffiliateBusinesses);
  }

  Future<List<MarketplaceListing>> getListings({
    ListingCategory? category,
  }) async {
    if (category == null) return List.of(MockData.mockListings);
    return MockData.mockListings.where((l) => l.category == category).toList();
  }

  Future<void> createListing(MarketplaceListing listing) async {
    MockData.mockListings.add(listing);
  }
}
