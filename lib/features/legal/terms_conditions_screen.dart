import 'package:flutter/material.dart';
import '../../core/widgets/static_text_page.dart';

// Replace with legal-approved copy before launch.
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const _sections = [
    StaticSection(
      title: '1. Aceptación de los términos',
      body: 'Al registrarte y utilizar Trama Campus, aceptas estos Términos y Condiciones en su totalidad. Si no estás de acuerdo con alguna disposición, debes abstenerte de usar la plataforma.',
    ),
    StaticSection(
      title: '2. Elegibilidad',
      body: 'Para usar Trama Campus debes ser estudiante activo de una universidad afiliada con un correo institucional válido. Debes tener al menos 17 años de edad.',
    ),
    StaticSection(
      title: '3. Cuenta y seguridad',
      body: 'Eres responsable de mantener la confidencialidad de tus credenciales. No debes compartir tu cuenta con terceros. Cualquier actividad realizada desde tu cuenta es tu responsabilidad.',
    ),
    StaticSection(
      title: '4. Uso aceptable',
      body: 'Te comprometes a usar la plataforma de manera respetuosa y en conformidad con las Normas de la Comunidad. Está prohibido el spam, acoso, suplantación de identidad, o publicación de contenido ilegal.',
    ),
    StaticSection(
      title: '5. Propiedad intelectual',
      body: 'Todo el contenido de Trama Campus, incluyendo el diseño, logos, código y textos, son propiedad de Trama Campus y están protegidos por leyes de propiedad intelectual.',
    ),
    StaticSection(
      title: '6. Limitación de responsabilidad',
      body: 'Trama Campus no garantiza la disponibilidad continua del servicio. En ningún caso seremos responsables de daños indirectos, incidentales o consecuentes derivados del uso de la plataforma.',
    ),
    StaticSection(
      title: '7. Modificaciones',
      body: 'Nos reservamos el derecho de modificar estos términos en cualquier momento. Los cambios entrarán en vigor al publicarse en la aplicación. El uso continuado implica aceptación.',
    ),
    StaticSection(
      title: '8. Contacto',
      body: 'Para cualquier duda sobre estos términos, escríbenos a legal@tramacampus.mx.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const StaticTextPage(
      title: 'Términos y condiciones',
      sections: _sections,
    );
  }
}
