import 'package:flutter/material.dart';
import '../../core/widgets/static_text_page.dart';

// Replace with legal-approved copy before launch.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _sections = [
    StaticSection(
      title: '1. Información que recopilamos',
      body:
          'Recopilamos información que nos proporcionas directamente: nombre, correo institucional, carrera, semestre, intereses, y fotos de perfil. También recopilamos datos de uso de la app de forma anónima.',
    ),
    StaticSection(
      title: '2. Cómo usamos tu información',
      body:
          'Usamos tu información para: mostrar tu perfil a otros estudiantes, generar sugerencias de compatibilidad, enviarte notificaciones relevantes y mejorar la experiencia de la plataforma.',
    ),
    StaticSection(
      title: '3. Compartición de datos',
      body:
          'No vendemos ni rentamos tu información personal a terceros. Podemos compartir datos agregados y anonimizados con instituciones académicas para investigación. Tu información visible es solo la que tú eliges mostrar.',
    ),
    StaticSection(
      title: '4. Seguridad',
      body:
          'Implementamos medidas técnicas y organizativas para proteger tu información. Sin embargo, ningún sistema es 100% seguro. Te recomendamos usar contraseñas fuertes y no compartirlas.',
    ),
    StaticSection(
      title: '5. Tus derechos (ARCO)',
      body:
          'Tienes derecho a Acceder, Rectificar, Cancelar u Oponerte al tratamiento de tus datos personales. Para ejercer estos derechos, escríbenos a privacidad@tramacampus.mx.',
    ),
    StaticSection(
      title: '6. Retención de datos',
      body:
          'Conservamos tus datos mientras tu cuenta esté activa. Al eliminar tu cuenta, tus datos personales son eliminados en un plazo máximo de 30 días, salvo obligaciones legales.',
    ),
    StaticSection(
      title: '7. Cambios a esta política',
      body:
          'Podemos actualizar esta política periódicamente. Te notificaremos de cambios significativos por correo o dentro de la app.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const StaticTextPage(
      title: 'Política de privacidad',
      sections: _sections,
    );
  }
}
