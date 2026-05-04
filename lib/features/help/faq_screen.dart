import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _items = [
    _FaqItem(
      category: 'Cuenta',
      question: '¿Cómo verifico mi correo institucional?',
      answer:
          'Al registrarte, recibirás un código de 6 dígitos en tu correo institucional. Ingresa el código en la pantalla de verificación. Si no lo recibiste, revisa tu carpeta de spam o solicita un nuevo código.',
    ),
    _FaqItem(
      category: 'Cuenta',
      question: '¿Puedo cambiar mi universidad?',
      answer:
          'Por el momento no es posible cambiar la universidad una vez verificada. Si cometiste un error, contacta al soporte con tu correo institucional correcto.',
    ),
    _FaqItem(
      category: 'Matching',
      question: '¿Cómo funciona el sistema de compatibilidad?',
      answer:
          'Trama Campus analiza tu carrera, semestre, intereses, habilidades, estilo de vida y objetivos para sugerirte personas afines. El porcentaje de compatibilidad refleja cuántas dimensiones tienen en común.',
    ),
    _FaqItem(
      category: 'Matching',
      question: '¿Qué son las modalidades de conexión?',
      answer:
          'Existen tres modalidades: Estudio (compañeros académicos), Amistad (personas con intereses similares) y Conexión personal (vínculos más profundos). Puedes activar varias simultáneamente.',
    ),
    _FaqItem(
      category: 'Privacidad',
      question: '¿Quién puede ver mi perfil?',
      answer:
          'Por defecto tu perfil es visible para todos los estudiantes de tu universidad. Puedes cambiar esto en Ajustes → Privacidad y limitar la visibilidad a solo estudiantes verificados o desactivarla temporalmente.',
    ),
    _FaqItem(
      category: 'Privacidad',
      question: '¿Cómo bloqueo a alguien?',
      answer:
          'Desde el perfil de la persona, toca los tres puntos (⋯) en la esquina superior derecha y selecciona "Bloquear". El usuario bloqueado no podrá ver tu perfil ni contactarte.',
    ),
    _FaqItem(
      category: 'Técnico',
      question: '¿La app funciona sin internet?',
      answer:
          'Algunas funciones básicas como revisar tu perfil y conversaciones guardadas están disponibles sin conexión. Para descubrir nuevas personas y enviar mensajes necesitas conexión a internet.',
    ),
    _FaqItem(
      category: 'Técnico',
      question: '¿Cómo reporto un error en la app?',
      answer:
          'Ve a Ajustes → Soporte → Reportar un problema. Describe lo que ocurrió y el equipo lo revisará a la brevedad. También puedes escribirnos directamente a soporte@tramacampus.mx.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(title: 'Preguntas frecuentes'),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space6,
          AppSpacing.space4,
          AppSpacing.space6,
          AppSpacing.space10,
        ),
        itemCount: _items.length,
        itemBuilder: (context, i) => _FaqTile(item: _items[i]),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });
  final String category;
  final String question;
  final String answer;
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.item});
  final _FaqItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space2,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.space4,
            0,
            AppSpacing.space4,
            AppSpacing.space4,
          ),
          leading: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space2,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              item.category,
              style: AppTextStyles.labelSm(AppColors.primary),
            ),
          ),
          title: Text(item.question, style: AppTextStyles.bodyMd(cs.onSurface)),
          children: [
            Text(item.answer, style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
