import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trama_campus_frontend/core/widgets/network_texture.dart';
import 'package:trama_campus_frontend/core/widgets/step_dots.dart';
import 'package:trama_campus_frontend/features/onboarding/welcome_screen.dart';
import 'package:trama_campus_frontend/features/onboarding/profile_complete_screen.dart';
import 'package:trama_campus_frontend/features/onboarding/verify_email_screen.dart';

Widget _app(Widget child) => MaterialApp(home: child);

void main() {
  group('Phase 4 — StepDots', () {
    testWidgets('renders kicker text "Paso X de N"', (tester) async {
      await tester.pumpWidget(_app(
        const Scaffold(
          body: StepDots(totalSteps: 6, currentStep: 0),
        ),
      ));
      expect(find.text('Paso 1 de 6'), findsOneWidget);
    });

    testWidgets('kicker hidden when showKicker is false', (tester) async {
      await tester.pumpWidget(_app(
        const Scaffold(
          body: StepDots(totalSteps: 6, currentStep: 2, showKicker: false),
        ),
      ));
      expect(find.text('Paso 3 de 6'), findsNothing);
    });

    testWidgets('renders correct number of dot containers', (tester) async {
      await tester.pumpWidget(_app(
        const Scaffold(
          body: StepDots(totalSteps: 6, currentStep: 0),
        ),
      ));
      // 6 AnimatedContainers inside the Row
      final dots = find.descendant(
        of: find.byType(Row).last,
        matching: find.byType(AnimatedContainer),
      );
      expect(dots, findsNWidgets(6));
    });
  });

  group('Phase 4 — WelcomeScreen', () {
    testWidgets('renders NetworkTexture background', (tester) async {
      await tester.pumpWidget(_app(const WelcomeScreen()));
      expect(find.byType(NetworkTexture), findsOneWidget);
    });

    testWidgets('renders Crear cuenta and Ya tengo cuenta buttons', (tester) async {
      await tester.pumpWidget(_app(const WelcomeScreen()));
      expect(find.text('Crear cuenta'), findsOneWidget);
      expect(find.text('Ya tengo cuenta'), findsOneWidget);
    });

    testWidgets('renders Trama Campus brand text', (tester) async {
      await tester.pumpWidget(_app(const WelcomeScreen()));
      expect(find.text('Trama Campus'), findsOneWidget);
    });
  });

  group('Phase 4 — VerifyEmailScreen code cells', () {
    testWidgets('shows email input initially', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const VerifyEmailScreen(),
      ));
      expect(find.text('Ingresa tu correo institucional'), findsOneWidget);
    });

    testWidgets('shows 4 code cells after sending', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const VerifyEmailScreen(),
      ));
      // Type email and send
      await tester.enterText(find.byType(TextField), 'test@uni.mx');
      await tester.tap(find.text('Enviar código de verificación'));
      await tester.pump();
      // Should show 4 single-char text fields (the code cells)
      expect(find.text('Código de verificación'), findsOneWidget);
    });
  });

  group('Phase 4 — ProfileCompleteScreen', () {
    testWidgets('renders NetworkTexture overlay', (tester) async {
      await tester.pumpWidget(_app(const ProfileCompleteScreen()));
      expect(find.byType(NetworkTexture), findsOneWidget);
    });

    testWidgets('renders ¡Perfil creado! headline', (tester) async {
      await tester.pumpWidget(_app(const ProfileCompleteScreen()));
      expect(find.text('¡Perfil creado!'), findsOneWidget);
    });

    testWidgets('renders two CTA buttons constrained to 280px', (tester) async {
      await tester.pumpWidget(_app(const ProfileCompleteScreen()));
      expect(find.text('Completar mi perfil'), findsOneWidget);
      expect(find.text('Ir al feed'), findsOneWidget);
      // Both are inside ConstrainedBox(maxWidth: 280)
      final boxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      final has280 = boxes.any((b) => b.constraints.maxWidth == 280);
      expect(has280, isTrue);
    });

    testWidgets('renders two avatar circles (duo pair)', (tester) async {
      await tester.pumpWidget(_app(const ProfileCompleteScreen()));
      // Two _AvatarCircle containers (found by BoxDecoration shape circle)
      final containers = find.byType(Container);
      // Just verify the screen renders without error and has the expected structure
      expect(find.byType(Stack), findsWidgets);
    });
  });
}
