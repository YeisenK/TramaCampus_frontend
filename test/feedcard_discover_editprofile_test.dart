import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trama_campus_frontend/core/widgets/feed_card.dart';
import 'package:trama_campus_frontend/data/mock/mock_data.dart';
import 'package:trama_campus_frontend/data/models/modality.dart';
import 'package:trama_campus_frontend/data/models/student.dart';
import 'package:trama_campus_frontend/features/discover/discover_screen.dart';
import 'package:trama_campus_frontend/features/discover/views/feed_view.dart';
import 'package:trama_campus_frontend/features/discover/widgets/discover_variant_switch.dart';
import 'package:trama_campus_frontend/core/widgets/selection/selection_experience.dart';
import 'package:trama_campus_frontend/features/profile/edit_profile_screen.dart';

Widget _app(Widget child) => MaterialApp(home: child);

const _student = Student(
  id: 'tx1',
  name: 'Ana Torres',
  age: 21,
  program: 'Diseño Gráfico',
  semester: 4,
  hue: 120.0,
  intent: ModalityType.estudio,
  bio: 'Me apasiona la tipografía y el diseño editorial.',
  interests: ['Arte', 'Música', 'Diseño'],
  reasons: ['Mismo semestre', 'Intereses en diseño'],
  compatibilityScore: 88,
);

const _noScore = Student(
  id: 'tx2',
  name: 'Luis Mora',
  age: 20,
  program: 'Contaduría',
  semester: 2,
  hue: 200.0,
  intent: ModalityType.estudio,
  bio: '',
  interests: [],
  reasons: [],
  compatibilityScore: 0,
);

// ─────────────────────────────────────────────────────────────────────────────
// FeedCard — diseño TC2
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  group('FeedCard — tipografía TC2', () {
    testWidgets('nombre es 19 px Manrope 700', (tester) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: FeedCard(student: _student, onTap: () {}, onSave: () {}),
          ),
        ),
      );

      final nameWidget = tester.widget<Text>(find.text('Ana Torres, 21'));
      expect(
        nameWidget.style?.fontSize,
        19.0,
        reason: 'TC2 spec: .nm { font: 700 19px Manrope }',
      );
      expect(
        nameWidget.style?.fontWeight,
        FontWeight.w700,
        reason: 'TC2 spec: weight 700',
      );
    });

    testWidgets('bio aparece dentro de un bloque quote (Container visible)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: FeedCard(student: _student, onTap: () {}, onSave: () {}),
          ),
        ),
      );

      // El texto de la bio debe empezar con comillas y estar en un Container
      final quoteText = find.textContaining('"Me apasiona la tipografía');
      expect(
        quoteText,
        findsOneWidget,
        reason: 'bio debe mostrarse entre comillas dobles',
      );

      // El Container del quote block debe existir como ancestro del texto
      final quoteContainer = find.ancestor(
        of: quoteText,
        matching: find.byType(Container),
      );
      expect(
        quoteContainer,
        findsWidgets,
        reason: 'bio debe estar dentro de un Container (quote block TC2)',
      );
    });

    testWidgets('bio vacía no muestra bloque quote', (tester) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: FeedCard(student: _noScore, onTap: () {}, onSave: () {}),
          ),
        ),
      );

      // Ningún texto entre comillas dobles
      expect(find.textContaining('"'), findsNothing);
    });

    testWidgets(
      'pill de compatibilidad usa tinte primary sin ShaderMask (no gradiente)',
      (tester) async {
        await tester.pumpWidget(
          _app(
            Scaffold(
              body: FeedCard(student: _student, onTap: () {}, onSave: () {}),
            ),
          ),
        );

        expect(find.text('88%'), findsOneWidget);

        // El porcentaje NO debe estar dentro de un ShaderMask (que implicaría gradient)
        final shaderAncestors = find.ancestor(
          of: find.text('88%'),
          matching: find.byType(ShaderMask),
        );
        expect(
          shaderAncestors,
          findsNothing,
          reason: 'TC2 spec: pill usa primary@12%, no gradiente completo',
        );
      },
    );

    testWidgets('compatibilityScore cero no muestra el pill', (tester) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: FeedCard(student: _noScore, onTap: () {}, onSave: () {}),
          ),
        ),
      );

      expect(find.text('0%'), findsNothing);
    });

    testWidgets('razones usan check_circle_outline (icono TC2)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: FeedCard(student: _student, onTap: () {}, onSave: () {}),
          ),
        ),
      );

      expect(
        find.byIcon(Icons.check_circle_outline),
        findsWidgets,
        reason: 'TC2 spec: .reason .ic usa check_circle_outline',
      );
    });

    testWidgets('callback onSave se dispara al tocar el botón guardar', (
      tester,
    ) async {
      var fired = false;
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: FeedCard(
              student: _student,
              onTap: () {},
              onSave: () => fired = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.bookmark_border));
      expect(fired, isTrue);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Discover — solo feed
  // ─────────────────────────────────────────────────────────────────────────
  group('Discover — solo feed, sin variantes', () {
    testWidgets('DiscoverVariantSwitch NO aparece en el árbol', (tester) async {
      await tester.pumpWidget(_app(const DiscoverScreen()));
      await tester.pump();

      expect(
        find.byType(DiscoverVariantSwitch),
        findsNothing,
        reason: 'La pantalla solo tiene feed; el variant switch fue eliminado',
      );
    });

    testWidgets('DiscoverFeedView SÍ está en el árbol', (tester) async {
      await tester.pumpWidget(_app(const DiscoverScreen()));
      await tester.pump();

      expect(find.byType(DiscoverFeedView), findsOneWidget);
    });

    testWidgets('feed vacío muestra mensaje Sin resultados', (tester) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: DiscoverFeedView(
              students: const [],
              saved: const {},
              onTap: (_) {},
              onSave: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Sin resultados'), findsOneWidget);
    });

    testWidgets('feed con estudiantes renderiza FeedCards', (tester) async {
      final students = MockData.students.take(2).toList();
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: DiscoverFeedView(
              students: students,
              saved: const {},
              onTap: (_) {},
              onSave: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(FeedCard), findsNWidgets(2));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // EditProfileScreen — versión simple (MockData)
  // ─────────────────────────────────────────────────────────────────────────
  group('EditProfileScreen — premium rewrite (TC2)', () {
    testWidgets('renders user display name in header', (tester) async {
      await tester.pumpWidget(_app(const EditProfileScreen()));
      await tester.pump();

      final name = MockData.currentProfile.base.firstName;
      expect(
        find.textContaining(name),
        findsWidgets,
        reason: 'header must show user first name',
      );
    });

    testWidgets('renders circular progress ring', (tester) async {
      await tester.pumpWidget(_app(const EditProfileScreen()));
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsWidgets,
        reason: 'progress ring must be present in header',
      );
    });

    testWidgets('renders group label Para mejor matching', (tester) async {
      await tester.pumpWidget(_app(const EditProfileScreen()));
      await tester.pump();

      expect(find.text('Para mejor matching'), findsOneWidget);
    });

    testWidgets('renders Objetivos section card', (tester) async {
      await tester.pumpWidget(_app(const EditProfileScreen()));
      await tester.pump();

      expect(find.text('Objetivos'), findsOneWidget);
    });

    testWidgets('renders Habilidades section card', (tester) async {
      await tester.pumpWidget(_app(const EditProfileScreen()));
      await tester.pump();

      expect(find.text('Habilidades'), findsOneWidget);
    });

    testWidgets('renders Guardar action in app bar', (tester) async {
      await tester.pumpWidget(_app(const EditProfileScreen()));
      await tester.pump();

      expect(find.text('Guardar'), findsOneWidget);
    });

    testWidgets(
      'NO contiene SelectionExperience inline (pickers son full-screen)',
      (tester) async {
        await tester.pumpWidget(_app(const EditProfileScreen()));
        await tester.pump();

        expect(
          find.byType(SelectionExperience),
          findsNothing,
          reason:
              'catalog pickers are pushed as full-screen routes, not inline',
        );
      },
    );
  });
}
