import 'package:flutter/material.dart';
import '../../core/widgets/static_text_page.dart';

// Replace with legal-approved copy before launch.
class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  static const _sections = [
    StaticSection(
      title: 'Respeto y autenticidad',
      body:
          'Trama Campus es un espacio para conexiones genuinas. Sé auténtico en tu perfil, usa tu nombre real y sube fotos tuyas. No crees perfiles falsos ni te hagas pasar por otra persona.',
    ),
    StaticSection(
      title: 'Comunicación respetuosa',
      body:
          'Trata a todos con respeto y dignidad. No toleramos lenguaje ofensivo, discriminatorio, acoso, amenazas ni intimidación de ningún tipo. El acoso continuado resultará en suspensión permanente.',
    ),
    StaticSection(
      title: 'Contenido apropiado',
      body:
          'Comparte contenido que sea relevante y apropiado para un entorno universitario. Está prohibido compartir material explícito, violento o ilegal. El contenido debe cumplir con las leyes aplicables.',
    ),
    StaticSection(
      title: 'Privacidad ajena',
      body:
          'Respeta la privacidad de otros usuarios. No compartas sin permiso información personal, fotos ni conversaciones privadas de otras personas.',
    ),
    StaticSection(
      title: 'Conexiones genuinas',
      body:
          'Usa Trama Campus para conocer personas con intenciones honestas. No uses la plataforma para spam, marketing no solicitado, reclutamiento engañoso ni actividades comerciales no autorizadas.',
    ),
    StaticSection(
      title: 'Reporte de violaciones',
      body:
          'Si encuentras contenido o comportamiento que viole estas normas, repórtalo usando el botón de reporte en el perfil del usuario. Revisamos todos los reportes y tomamos acción cuando corresponde.',
    ),
    StaticSection(
      title: 'Consecuencias',
      body:
          'Las violaciones a estas normas pueden resultar en advertencias, suspensiones temporales o eliminación permanente de la cuenta, dependiendo de la gravedad.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const StaticTextPage(
      title: 'Normas de la comunidad',
      sections: _sections,
    );
  }
}
