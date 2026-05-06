import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trama_campus_frontend/core/widgets/t_bottom_nav.dart';

Widget _wrapNav({int index = 0, void Function(int)? onTap}) {
  return MaterialApp(
    home: Scaffold(
      bottomNavigationBar: TBottomNav(
        currentIndex: index,
        onTap: onTap ?? (_) {},
      ),
    ),
  );
}

void main() {
  group('Phase 3 — TBottomNav', () {
    testWidgets('renders 5 tabs', (tester) async {
      await tester.pumpWidget(_wrapNav());
      // 5 GestureDetectors inside the nav bar row
      final navItems = find.descendant(
        of: find.byType(TBottomNav),
        matching: find.byType(GestureDetector),
      );
      expect(navItems, findsNWidgets(5));
    });

    testWidgets('second tab label is Conexiones (not Match)', (tester) async {
      await tester.pumpWidget(_wrapNav(index: 1));
      await tester.pump();
      expect(find.text('Conexiones'), findsOneWidget);
      expect(find.text('Match'), findsNothing);
    });

    testWidgets('active tab label is visible, inactive are hidden', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapNav(index: 0));
      await tester.pump();
      // "Descubrir" should be visible (active tab)
      expect(find.text('Descubrir'), findsOneWidget);
      // "Conexiones" should NOT be visible (inactive)
      expect(find.text('Conexiones'), findsNothing);
      expect(find.text('Market'), findsNothing);
    });

    testWidgets('active tab shows filled icon', (tester) async {
      await tester.pumpWidget(_wrapNav(index: 0));
      await tester.pump();
      expect(find.byIcon(Icons.explore), findsOneWidget);
      expect(find.byIcon(Icons.explore_outlined), findsNothing);
    });

    testWidgets('inactive tab shows outlined icon', (tester) async {
      await tester.pumpWidget(_wrapNav(index: 0));
      await tester.pump();
      // Tab 1 (Conexiones) should show outlined icon when inactive
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
    });

    testWidgets('tapping a tab fires onTap with correct index', (tester) async {
      int tapped = -1;
      await tester.pumpWidget(_wrapNav(index: 0, onTap: (i) => tapped = i));
      // Tap the third tab (Market at index 2)
      await tester.tap(find.byIcon(Icons.storefront_outlined));
      expect(tapped, 2);
    });

    testWidgets(
      'tabs in order: Descubrir/Conexiones/Market/Chats/Perfil icons',
      (tester) async {
        await tester.pumpWidget(_wrapNav(index: 0));
        await tester.pump();
        // Active (index 0) = filled explore; others outlined
        expect(find.byIcon(Icons.explore), findsOneWidget);
        expect(find.byIcon(Icons.people_outline), findsOneWidget);
        expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
        expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      },
    );
  });
}
