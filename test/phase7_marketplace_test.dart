import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trama_campus_frontend/data/mock/mock_data.dart';
import 'package:trama_campus_frontend/features/marketplace/marketplace_screen.dart';
import 'package:trama_campus_frontend/features/marketplace/publish_sheet.dart';
import 'package:trama_campus_frontend/features/marketplace/widgets/business_card.dart';
import 'package:trama_campus_frontend/features/marketplace/widgets/featured_strip.dart';
import 'package:trama_campus_frontend/features/marketplace/widgets/listing_card_editorial.dart';
import 'package:trama_campus_frontend/features/marketplace/widgets/listing_card_grid.dart';
import 'package:trama_campus_frontend/features/marketplace/widgets/listing_card_list.dart';

Widget _app(Widget child) => MaterialApp(home: child);
Widget _scaffold(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('Phase 7 — MarketplaceScreen editorial header', () {
    testWidgets('renders MARKET kicker', (tester) async {
      await tester.pumpWidget(_app(const MarketplaceScreen(embedded: true)));
      await tester.pump();
      expect(find.text('MARKET'), findsOneWidget);
    });

    testWidgets('renders Marketplace headline', (tester) async {
      await tester.pumpWidget(_app(const MarketplaceScreen(embedded: true)));
      await tester.pump();
      expect(find.text('Marketplace'), findsOneWidget);
    });

    testWidgets('renders category filter chips', (tester) async {
      await tester.pumpWidget(_app(const MarketplaceScreen(embedded: true)));
      await tester.pump();
      expect(find.text('Todos'), findsOneWidget);
      expect(find.text('Apuntes'), findsOneWidget);
    });

    testWidgets('renders variant switcher options', (tester) async {
      await tester.pumpWidget(_app(const MarketplaceScreen(embedded: true)));
      await tester.pump();
      expect(find.text('Editorial'), findsOneWidget);
      expect(find.text('Lista'), findsOneWidget);
      expect(find.text('Grid'), findsOneWidget);
    });

    testWidgets('renders without error and data loads', (tester) async {
      await tester.pumpWidget(_app(const MarketplaceScreen(embedded: true)));
      await tester.pumpAndSettle();
      expect(find.byType(MarketplaceScreen), findsOneWidget);
    });
  });

  group('Phase 7 — FeaturedStrip', () {
    testWidgets('renders without error', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(_scaffold(FeaturedStrip(listing: listing)));
      await tester.pump();
      expect(find.byType(FeaturedStrip), findsOneWidget);
    });

    testWidgets('renders DESTACADO label', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(_scaffold(FeaturedStrip(listing: listing)));
      await tester.pump();
      expect(find.text('DESTACADO'), findsOneWidget);
    });

    testWidgets('renders listing title', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(_scaffold(FeaturedStrip(listing: listing)));
      await tester.pump();
      expect(find.text(listing.title), findsOneWidget);
    });
  });

  group('Phase 7 — ListingCardEditorial', () {
    testWidgets('renders without error', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(
        _scaffold(ListingCardEditorial(listing: listing)),
      );
      await tester.pump();
      expect(find.byType(ListingCardEditorial), findsOneWidget);
    });

    testWidgets('renders seller name', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(
        _scaffold(
          SingleChildScrollView(child: ListingCardEditorial(listing: listing)),
        ),
      );
      await tester.pump();
      expect(find.text(listing.sellerName), findsOneWidget);
    });

    testWidgets('save button shows bookmark_border when not saved', (
      tester,
    ) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(
        _scaffold(ListingCardEditorial(listing: listing, isSaved: false)),
      );
      await tester.pump();
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('save button shows bookmark when saved', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(
        _scaffold(ListingCardEditorial(listing: listing, isSaved: true)),
      );
      await tester.pump();
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });
  });

  group('Phase 7 — ListingCardList', () {
    testWidgets('renders without error', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(_scaffold(ListingCardList(listing: listing)));
      await tester.pump();
      expect(find.byType(ListingCardList), findsOneWidget);
    });

    testWidgets('renders listing title', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(_scaffold(ListingCardList(listing: listing)));
      await tester.pump();
      expect(find.text(listing.title), findsOneWidget);
    });

    testWidgets('renders price in MXN', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(_scaffold(ListingCardList(listing: listing)));
      await tester.pump();
      expect(find.textContaining('MXN'), findsOneWidget);
    });
  });

  group('Phase 7 — ListingCardGrid', () {
    testWidgets('renders without error', (tester) async {
      final listing = MockData.mockListings.first;
      await tester.pumpWidget(
        _scaffold(
          SizedBox(
            width: 160,
            height: 200,
            child: ListingCardGrid(listing: listing),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(ListingCardGrid), findsOneWidget);
    });
  });

  group('Phase 7 — BusinessCard', () {
    testWidgets('renders without error', (tester) async {
      final business = MockData.mockAffiliateBusinesses.first;
      await tester.pumpWidget(_scaffold(BusinessCard(business: business)));
      await tester.pump();
      expect(find.byType(BusinessCard), findsOneWidget);
    });

    testWidgets('renders business name', (tester) async {
      final business = MockData.mockAffiliateBusinesses.first;
      await tester.pumpWidget(_scaffold(BusinessCard(business: business)));
      await tester.pump();
      expect(find.text(business.name), findsOneWidget);
    });

    testWidgets('renders verified icon', (tester) async {
      final business = MockData.mockAffiliateBusinesses.first;
      await tester.pumpWidget(_scaffold(BusinessCard(business: business)));
      await tester.pump();
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });
  });

  group('Phase 7 — PublishSheet', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        _scaffold(SingleChildScrollView(child: PublishSheet())),
      );
      await tester.pump();
      expect(find.byType(PublishSheet), findsOneWidget);
    });

    testWidgets('renders Publicar anuncio title', (tester) async {
      await tester.pumpWidget(
        _scaffold(SingleChildScrollView(child: PublishSheet())),
      );
      await tester.pump();
      expect(find.text('Publicar anuncio'), findsOneWidget);
    });

    testWidgets('renders category options', (tester) async {
      await tester.pumpWidget(
        _scaffold(SingleChildScrollView(child: PublishSheet())),
      );
      await tester.pump();
      expect(find.text('Apuntes'), findsOneWidget);
      expect(find.text('Servicios'), findsOneWidget);
    });

    testWidgets('renders Publicar submit button', (tester) async {
      await tester.pumpWidget(
        _scaffold(SingleChildScrollView(child: PublishSheet())),
      );
      await tester.pump();
      expect(find.text('Publicar'), findsOneWidget);
    });
  });
}
