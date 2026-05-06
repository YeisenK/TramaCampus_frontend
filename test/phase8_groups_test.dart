import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trama_campus_frontend/data/mock/mock_data.dart';
import 'package:trama_campus_frontend/data/models/group.dart';
import 'package:trama_campus_frontend/data/models/task.dart';
import 'package:trama_campus_frontend/features/groups/create_group_sheet.dart';
import 'package:trama_campus_frontend/features/groups/group_detail_screen.dart';
import 'package:trama_campus_frontend/features/groups/groups_discover_screen.dart';
import 'package:trama_campus_frontend/features/groups/widgets/group_card.dart';
import 'package:trama_campus_frontend/features/groups/widgets/group_hero.dart';
import 'package:trama_campus_frontend/features/groups/widgets/task_row.dart';

Widget _app(Widget child) => MaterialApp(home: child);
Widget _scaffold(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('Phase 8 — Mock data', () {
    test('mockGroups has at least 4 groups', () {
      expect(MockData.mockGroups.length, greaterThanOrEqualTo(4));
    });

    test('mockGroupTasks has 6 tasks', () {
      expect(MockData.mockGroupTasks.length, 6);
    });

    test('mockGroups contains at least one featured group', () {
      expect(MockData.mockGroups.any((g) => g.featured), isTrue);
    });

    test('myGroupIds references valid group IDs', () {
      final allIds = MockData.mockGroups.map((g) => g.id).toSet();
      for (final id in MockData.myGroupIds) {
        expect(allIds.contains(id), isTrue);
      }
    });

    test('Group model has required fields', () {
      final g = MockData.mockGroups.first;
      expect(g.id.isNotEmpty, isTrue);
      expect(g.name.isNotEmpty, isTrue);
      expect(g.tagline.isNotEmpty, isTrue);
    });

    test('Task model has required fields', () {
      final t = MockData.mockGroupTasks.first;
      expect(t.id.isNotEmpty, isTrue);
      expect(t.code.isNotEmpty, isTrue);
      expect(t.title.isNotEmpty, isTrue);
    });

    test('GroupKind labels are non-empty', () {
      for (final k in GroupKind.values) {
        expect(k.label.isNotEmpty, isTrue);
      }
    });

    test('GroupAccess labels are non-empty', () {
      for (final a in GroupAccess.values) {
        expect(a.label.isNotEmpty, isTrue);
      }
    });
  });

  group('Phase 8 — GroupsDiscoverScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_app(const GroupsDiscoverScreen(embedded: true)));
      await tester.pump();
      expect(find.byType(GroupsDiscoverScreen), findsOneWidget);
    });

    testWidgets('renders GRUPOS kicker', (tester) async {
      await tester.pumpWidget(_app(const GroupsDiscoverScreen(embedded: true)));
      await tester.pump();
      expect(find.text('GRUPOS'), findsOneWidget);
    });

    testWidgets('renders Descubrir headline', (tester) async {
      await tester.pumpWidget(_app(const GroupsDiscoverScreen(embedded: true)));
      await tester.pump();
      expect(find.text('Descubrir'), findsOneWidget);
    });

    testWidgets('renders Todos filter chip', (tester) async {
      await tester.pumpWidget(_app(const GroupsDiscoverScreen(embedded: true)));
      await tester.pump();
      expect(find.text('Todos'), findsOneWidget);
    });

    testWidgets('renders group cards', (tester) async {
      await tester.pumpWidget(_app(const GroupsDiscoverScreen(embedded: true)));
      await tester.pumpAndSettle();
      expect(find.byType(GroupCard), findsWidgets);
    });

    testWidgets('renders first group name', (tester) async {
      await tester.pumpWidget(_app(const GroupsDiscoverScreen(embedded: true)));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(MockData.mockGroups.first.name.substring(0, 8)),
        findsWidgets,
      );
    });
  });

  group('Phase 8 — GroupCard', () {
    testWidgets('renders without error', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_scaffold(GroupCard(group: group)));
      await tester.pump();
      expect(find.byType(GroupCard), findsOneWidget);
    });

    testWidgets('renders group name', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_scaffold(GroupCard(group: group)));
      await tester.pump();
      expect(find.textContaining(group.name.substring(0, 8)), findsOneWidget);
    });

    testWidgets('renders member count', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_scaffold(GroupCard(group: group)));
      await tester.pump();
      expect(find.text('${group.memberCount}'), findsOneWidget);
    });

    testWidgets('renders verified icon when verified', (tester) async {
      final verified = MockData.mockGroups.firstWhere((g) => g.verified);
      await tester.pumpWidget(_scaffold(GroupCard(group: verified)));
      await tester.pump();
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });
  });

  group('Phase 8 — GroupHero', () {
    testWidgets('renders without error', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_scaffold(GroupHero(group: group)));
      await tester.pump();
      expect(find.byType(GroupHero), findsOneWidget);
    });

    testWidgets('renders group name', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_scaffold(GroupHero(group: group)));
      await tester.pump();
      expect(
        find.textContaining(group.name.substring(0, 8)),
        findsOneWidget,
      );
    });
  });

  group('Phase 8 — TaskRow', () {
    testWidgets('renders without error', (tester) async {
      final task = MockData.mockGroupTasks.first;
      await tester.pumpWidget(_scaffold(TaskRow(task: task)));
      await tester.pump();
      expect(find.byType(TaskRow), findsOneWidget);
    });

    testWidgets('renders task code', (tester) async {
      final task = MockData.mockGroupTasks.first;
      await tester.pumpWidget(_scaffold(TaskRow(task: task)));
      await tester.pump();
      expect(find.text(task.code), findsOneWidget);
    });

    testWidgets('renders task title', (tester) async {
      final task = MockData.mockGroupTasks.first;
      await tester.pumpWidget(_scaffold(TaskRow(task: task)));
      await tester.pump();
      expect(find.text(task.title), findsOneWidget);
    });

    testWidgets('done task renders with line-through decoration', (tester) async {
      const doneTask = Task(
        id: 'tx',
        code: 'TX-01',
        title: 'Done task title',
        status: TaskStatus.done,
        assigneeName: 'Test',
        due: 'Hoy',
        priority: TaskPriority.low,
      );
      await tester.pumpWidget(_scaffold(const TaskRow(task: doneTask)));
      await tester.pump();
      final textWidgets = tester.widgetList<Text>(find.text('Done task title'));
      final hasStrikethrough = textWidgets.any(
        (w) =>
            w.style?.decoration == TextDecoration.lineThrough,
      );
      expect(hasStrikethrough, isTrue);
    });
  });

  group('Phase 8 — GroupDetailScreen', () {
    testWidgets('renders without error', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_app(GroupDetailScreen(group: group)));
      await tester.pump();
      expect(find.byType(GroupDetailScreen), findsOneWidget);
    });

    testWidgets('renders Tablero tab', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_app(GroupDetailScreen(group: group)));
      await tester.pump();
      expect(find.text('Tablero'), findsOneWidget);
    });

    testWidgets('renders Miembros tab', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_app(GroupDetailScreen(group: group)));
      await tester.pump();
      expect(find.text('Miembros'), findsOneWidget);
    });

    testWidgets('renders task rows on Tablero tab', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_app(GroupDetailScreen(group: group)));
      await tester.pumpAndSettle();
      expect(find.byType(TaskRow), findsWidgets);
    });

    testWidgets('tapping Miembros tab switches view', (tester) async {
      final group = MockData.mockGroups.first;
      await tester.pumpWidget(_app(GroupDetailScreen(group: group)));
      await tester.pump();
      await tester.tap(find.text('Miembros'));
      await tester.pumpAndSettle();
      expect(find.textContaining('miembros'), findsOneWidget);
    });
  });

  group('Phase 8 — CreateGroupSheet', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_scaffold(
        const SingleChildScrollView(child: CreateGroupSheet()),
      ));
      await tester.pump();
      expect(find.byType(CreateGroupSheet), findsOneWidget);
    });

    testWidgets('renders Arma tu grupo headline', (tester) async {
      await tester.pumpWidget(_scaffold(
        const SingleChildScrollView(child: CreateGroupSheet()),
      ));
      await tester.pump();
      expect(find.text('Arma tu grupo'), findsOneWidget);
    });

    testWidgets('renders type options', (tester) async {
      await tester.pumpWidget(_scaffold(
        const SingleChildScrollView(child: CreateGroupSheet()),
      ));
      await tester.pump();
      expect(find.text('Estudio'), findsOneWidget);
      expect(find.text('Proyecto'), findsOneWidget);
    });

    testWidgets('renders access radio options', (tester) async {
      await tester.pumpWidget(_scaffold(
        const SingleChildScrollView(child: CreateGroupSheet()),
      ));
      await tester.pump();
      expect(find.text('Abierto'), findsOneWidget);
      expect(find.text('Con solicitud'), findsOneWidget);
    });

    testWidgets('renders Crear grupo button', (tester) async {
      await tester.pumpWidget(_scaffold(
        const SingleChildScrollView(child: CreateGroupSheet()),
      ));
      await tester.pump();
      expect(find.text('Crear grupo'), findsOneWidget);
    });
  });
}
