import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trama_campus_frontend/core/widgets/network_texture.dart';
import 'package:trama_campus_frontend/core/widgets/t_schedule_grid.dart';
import 'package:trama_campus_frontend/data/mock/mock_data.dart';
import 'package:trama_campus_frontend/features/connections/match_success_screen.dart';
import 'package:trama_campus_frontend/features/profile/my_profile_screen.dart';
import 'package:trama_campus_frontend/features/chat/chat_list_screen.dart';
import 'package:trama_campus_frontend/features/chat/conversation_screen.dart';

Widget _app(Widget child) => MaterialApp(home: child);

void main() {
  group('Phase 6 — MatchSuccessScreen', () {
    testWidgets('renders NetworkTexture background', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(_app(MatchSuccessScreen(student: student)));
      await tester.pump();
      expect(find.byType(NetworkTexture), findsOneWidget);
    });

    testWidgets('renders ¡Conexión! headline', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(_app(MatchSuccessScreen(student: student)));
      await tester.pump();
      expect(find.text('¡Conexión!'), findsOneWidget);
    });

    testWidgets('background scaffold color is surfaceDim (not null)', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(_app(MatchSuccessScreen(student: student)));
      await tester.pump();
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('shows two action buttons', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(_app(MatchSuccessScreen(student: student)));
      await tester.pump();
      expect(find.text('Iniciar conversación'), findsOneWidget);
      expect(find.text('Seguir explorando'), findsOneWidget);
    });
  });

  group('Phase 6 — MyProfileScreen schedule grid', () {
    testWidgets('renders TScheduleGrid after scrolling', (tester) async {
      await tester.pumpWidget(_app(const MyProfileScreen(embedded: true)));
      await tester.pumpAndSettle();
      // Scroll down to reveal content below the hero
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();
      expect(find.byType(TScheduleGrid), findsOneWidget);
    });

    testWidgets('stats row shows correct labels', (tester) async {
      await tester.pumpWidget(_app(const MyProfileScreen(embedded: true)));
      await tester.pumpAndSettle();
      // Stats row is just below the hero, visible after small scroll
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -340));
      await tester.pumpAndSettle();
      expect(find.text('Matches'), findsOneWidget);
      expect(find.text('Conexiones'), findsOneWidget);
      expect(find.text('Chats'), findsOneWidget);
    });

    testWidgets('renders Disponibilidad semanal after scrolling', (tester) async {
      await tester.pumpWidget(_app(const MyProfileScreen(embedded: true)));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
      await tester.pumpAndSettle();
      expect(find.text('Disponibilidad semanal'), findsOneWidget);
    });
  });

  group('Phase 6 — ChatListScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_app(const ChatListScreen(embedded: true)));
      await tester.pump();
      expect(find.byType(ChatListScreen), findsOneWidget);
    });

    testWidgets('renders Mensajes title', (tester) async {
      await tester.pumpWidget(_app(const ChatListScreen(embedded: true)));
      await tester.pump();
      expect(find.text('Mensajes'), findsOneWidget);
    });
  });

  group('Phase 6 — ConversationScreen glass composer', () {
    testWidgets('renders without error', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(_app(ConversationScreen(student: student)));
      await tester.pump();
      expect(find.byType(ConversationScreen), findsOneWidget);
    });

    testWidgets('renders send button (arrow_upward icon)', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(_app(ConversationScreen(student: student)));
      await tester.pump();
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('renders hint text in composer', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(_app(ConversationScreen(student: student)));
      await tester.pump();
      expect(find.text('Escribe un mensaje...'), findsOneWidget);
    });

    testWidgets('input bar contains a TextField', (tester) async {
      final student = MockData.students.first;
      await tester.pumpWidget(_app(ConversationScreen(student: student)));
      await tester.pump();
      expect(find.byType(TextField), findsWidgets);
    });
  });
}
