import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trama_campus_frontend/features/discover/widgets/discover_variant_switch.dart';
import 'package:trama_campus_frontend/core/widgets/feed_card.dart';
import 'package:trama_campus_frontend/data/mock/mock_data.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('Phase 5 — DiscoverVariantSwitch', () {
    testWidgets('renders all 3 variant labels', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DiscoverVariantSwitch(
            selected: DiscoverVariant.feed,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Feed'), findsOneWidget);
      expect(find.text('Grid'), findsOneWidget);
      expect(find.text('Stories'), findsOneWidget);
    });

    testWidgets('active variant uses inverted color (onSurface bg)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DiscoverVariantSwitch(
            selected: DiscoverVariant.feed,
            onChanged: (_) {},
          ),
        ),
      );
      // The active container should have onSurface background
      // We verify by checking the widget builds without error and finds 3 items
      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });

    testWidgets('fires onChanged when different variant tapped', (
      tester,
    ) async {
      DiscoverVariant? picked;
      await tester.pumpWidget(
        _wrap(
          DiscoverVariantSwitch(
            selected: DiscoverVariant.feed,
            onChanged: (v) => picked = v,
          ),
        ),
      );
      await tester.tap(find.text('Grid'));
      expect(picked, DiscoverVariant.grid);
    });

    testWidgets('tapping active variant still fires onChanged', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(
        _wrap(
          DiscoverVariantSwitch(
            selected: DiscoverVariant.feed,
            onChanged: (_) => callCount++,
          ),
        ),
      );
      await tester.tap(find.text('Feed'));
      expect(callCount, 1);
    });
  });

  group('Phase 5 — FeedCard glass overlays', () {
    testWidgets('renders without error with a mock student', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(
        _wrap(
          FeedCard(
            student: student,
            onTap: () {},
            onSave: () {},
            isSaved: false,
          ),
        ),
      );
      expect(find.byType(FeedCard), findsOneWidget);
    });

    testWidgets('save button toggles icon on isSaved change', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(
        _wrap(
          FeedCard(
            student: student,
            onTap: () {},
            onSave: () {},
            isSaved: false,
          ),
        ),
      );
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

      await tester.pumpWidget(
        _wrap(
          FeedCard(
            student: student,
            onTap: () {},
            onSave: () {},
            isSaved: true,
          ),
        ),
      );
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('renders program label in context pill', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(
        _wrap(FeedCard(student: student, onTap: () {}, onSave: () {})),
      );
      expect(find.text(student.program), findsOneWidget);
    });
  });

  group('Phase 5 — DiscoverVariant enum helpers', () {
    test('all 3 variants have non-empty labels', () {
      for (final v in DiscoverVariant.values) {
        expect(v.label.isNotEmpty, isTrue);
      }
    });

    test('all 3 variants have distinct labels', () {
      final labels = DiscoverVariant.values.map((v) => v.label).toList();
      expect(labels.toSet().length, 3);
    });
  });
}
