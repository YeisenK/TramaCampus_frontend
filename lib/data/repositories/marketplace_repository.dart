import '../mock/mock_data.dart';
import '../models/affiliate_business.dart';
import '../models/marketplace_listing.dart';

class MarketplaceRepository {
  MarketplaceRepository._();
  static final MarketplaceRepository instance = MarketplaceRepository._();

  Future<List<AffiliateBusiness>> getAffiliateBusinesses() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.of(MockData.mockAffiliateBusinesses);
  }

  Future<List<MarketplaceListing>> getListings({ListingCategory? category}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (category == null) return List.of(MockData.mockListings);
    return MockData.mockListings.where((l) => l.category == category).toList();
  }

  Future<void> createListing(MarketplaceListing listing) async {
    await Future.delayed(const Duration(milliseconds: 800));
    MockData.mockListings.add(listing);
  }
}
