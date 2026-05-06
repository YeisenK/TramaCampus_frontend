import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trama_campus_frontend/core/widgets/t_glass_app_bar.dart';
import 'package:trama_campus_frontend/core/widgets/t_theme_toggle.dart';
import 'package:trama_campus_frontend/core/widgets/network_texture.dart';
import 'package:trama_campus_frontend/core/widgets/t_hero_scaffold.dart';
import 'package:trama_campus_frontend/core/widgets/t_schedule_grid.dart';
import 'package:trama_campus_frontend/core/widgets/t_segmented_underline.dart';
import 'package:trama_campus_frontend/core/widgets/t_grab_bar.dart';
import 'package:trama_campus_frontend/core/widgets/t_button.dart';
import 'package:trama_campus_frontend/core/widgets/t_chip.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('Phase 2 — TGlassAppBar', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: TGlassAppBar(title: 'Trama'),
          body: const SizedBox(),
        ),
      ));
      expect(find.text('Trama'), findsOneWidget);
    });

    testWidgets('reports preferredSize matching kToolbarHeight', (tester) async {
      const bar = TGlassAppBar(title: 'X');
      expect(bar.preferredSize.height, kToolbarHeight);
    });

    testWidgets('renders back button when showBack is true', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: TGlassAppBar(title: 'X', showBack: true),
              body: const SizedBox(),
            ),
          ),
        ),
      ));
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });
  });

  group('Phase 2 — TThemeToggle', () {
    testWidgets('shows dark_mode icon when isDark is false', (tester) async {
      await tester.pumpWidget(_wrap(
        TThemeToggle(isDark: false, onToggle: () {}),
      ));
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });

    testWidgets('shows light_mode icon when isDark is true', (tester) async {
      await tester.pumpWidget(_wrap(
        TThemeToggle(isDark: true, onToggle: () {}),
      ));
      await tester.pump(); // allow AnimatedSwitcher to settle
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    });

    testWidgets('calls onToggle when tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(_wrap(
        TThemeToggle(isDark: false, onToggle: () => called = true),
      ));
      await tester.tap(find.byType(TThemeToggle));
      expect(called, isTrue);
    });
  });

  group('Phase 2 — NetworkTexture', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrap(
        const SizedBox(
          width: 200,
          height: 200,
          child: NetworkTexture(opacity: 0.04),
        ),
      ));
      expect(find.byType(NetworkTexture), findsOneWidget);
    });

    testWidgets('renders child when provided', (tester) async {
      await tester.pumpWidget(_wrap(
        const NetworkTexture(
          opacity: 0.04,
          child: Text('Hello'),
        ),
      ));
      expect(find.text('Hello'), findsOneWidget);
    });
  });

  group('Phase 2 — THeroScaffold', () {
    testWidgets('renders name text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: THeroScaffold(
          name: 'Sofía',
          subtitle: 'Diseño Gráfico',
          body: const SizedBox(),
        ),
      ));
      expect(find.text('Sofía'), findsOneWidget);
      expect(find.text('Diseño Gráfico'), findsOneWidget);
    });

    testWidgets('renders back button when showBack is true', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: THeroScaffold(
          name: 'Ana',
          showBack: true,
          body: const SizedBox(),
        ),
      ));
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });
  });

  group('Phase 2 — TScheduleGrid', () {
    testWidgets('renders day header labels', (tester) async {
      final schedule = List.generate(
        7,
        (_) => List.filled(8, ScheduleState.free),
      );
      await tester.pumpWidget(_wrap(
        SizedBox(
          width: 300,
          child: TScheduleGrid(schedule: schedule),
        ),
      ));
      expect(find.text('L'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });

    testWidgets('renders hour labels', (tester) async {
      final schedule = List.generate(
        7,
        (_) => List.filled(8, ScheduleState.free),
      );
      await tester.pumpWidget(_wrap(
        SizedBox(
          width: 300,
          child: TScheduleGrid(schedule: schedule),
        ),
      ));
      expect(find.text('8'), findsOneWidget);
      expect(find.text('22'), findsOneWidget);
    });
  });

  group('Phase 2 — TSegmentedUnderline', () {
    testWidgets('renders all tab labels', (tester) async {
      await tester.pumpWidget(_wrap(
        TSegmentedUnderline(
          tabs: const ['Uno', 'Dos', 'Tres'],
          selectedIndex: 0,
          onTabChanged: (_) {},
        ),
      ));
      expect(find.text('Uno'), findsOneWidget);
      expect(find.text('Dos'), findsOneWidget);
      expect(find.text('Tres'), findsOneWidget);
    });

    testWidgets('calls onTabChanged when non-active tab tapped', (tester) async {
      int tapped = -1;
      await tester.pumpWidget(_wrap(
        TSegmentedUnderline(
          tabs: const ['A', 'B'],
          selectedIndex: 0,
          onTabChanged: (i) => tapped = i,
        ),
      ));
      await tester.tap(find.text('B'));
      expect(tapped, 1);
    });
  });

  group('Phase 2 — TGrabBar', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrap(const TGrabBar()));
      expect(find.byType(TGrabBar), findsOneWidget);
    });
  });

  group('Phase 2 — TButton size enum', () {
    testWidgets('lg button has 56px height', (tester) async {
      await tester.pumpWidget(_wrap(
        TButton(label: 'X', onPressed: () {}, size: TButtonSize.lg),
      ));
      final box = tester.renderObject<RenderBox>(find.byType(SizedBox).first);
      expect(box.size.height, 56);
    });

    testWidgets('sm button has 40px height', (tester) async {
      await tester.pumpWidget(_wrap(
        TButton(label: 'X', onPressed: () {}, size: TButtonSize.sm),
      ));
      final box = tester.renderObject<RenderBox>(find.byType(SizedBox).first);
      expect(box.size.height, 40);
    });

    testWidgets('md button has 48px height', (tester) async {
      await tester.pumpWidget(_wrap(
        TButton(label: 'X', onPressed: () {}, size: TButtonSize.md),
      ));
      final box = tester.renderObject<RenderBox>(find.byType(SizedBox).first);
      expect(box.size.height, 48);
    });
  });

  group('Phase 2 — TChip size enum', () {
    testWidgets('regular chip renders label', (tester) async {
      await tester.pumpWidget(_wrap(
        const TChip(label: 'Flutter', size: TChipSize.regular),
      ));
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('small chip renders label', (tester) async {
      await tester.pumpWidget(_wrap(
        const TChip(label: 'Python', size: TChipSize.small),
      ));
      expect(find.text('Python'), findsOneWidget);
    });

    testWidgets('selected chip renders without error', (tester) async {
      await tester.pumpWidget(_wrap(
        const TChip(label: 'Dart', selected: true),
      ));
      expect(find.text('Dart'), findsOneWidget);
    });
  });
}
