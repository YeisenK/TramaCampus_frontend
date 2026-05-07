import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_info.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/t_app_bar.dart';
import '../../../core/widgets/t_button.dart';
import 'arco_request_screen.dart';

class ArcoRequestConfirmScreen extends StatefulWidget {
  const ArcoRequestConfirmScreen({super.key, required this.args});

  final ArcoRequestArgs args;

  @override
  State<ArcoRequestConfirmScreen> createState() =>
      _ArcoRequestConfirmScreenState();
}

class _ArcoRequestConfirmScreenState
    extends State<ArcoRequestConfirmScreen> {
  bool _copied = false;

  String _buildEmailBody() {
    final args = widget.args;
    final lines = <String>[
      'SOLICITUD DE DERECHOS ARCO — TRAMA CAMPUS',
      '=' * 50,
      '',
      'Derecho que se ejerce: ${args.type.label}',
      '',
      'Datos del titular:',
      '  Correo registrado en la plataforma: [tu correo institucional]',
      '',
    ];
    if (args.detail.isNotEmpty) {
      lines.addAll([
        'Descripción de la solicitud:',
        args.detail,
        '',
      ]);
    }
    if (args.additionalContext.isNotEmpty) {
      lines.addAll([
        'Información adicional:',
        args.additionalContext,
        '',
      ]);
    }
    lines.addAll([
      'Esta solicitud se presenta conforme a los artículos 28-36 de la LFPDPPP.',
      'El Responsable tiene un plazo de 20 días hábiles para dar respuesta '
          'a partir de la recepción de este correo.',
      '',
      'Fecha: ${DateTime.now().toLocal().toString().substring(0, 16)}',
    ]);
    return lines.join('\n');
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _buildEmailBody()));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Texto copiado. Pégalo en un correo a arco@tramacampus.mx',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final emailBody = _buildEmailBody();

    return Scaffold(
      appBar: const TAppBar(title: 'Revisar y enviar'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.edgePadding,
          AppSpacing.space4,
          AppSpacing.edgePadding,
          120,
        ),
        children: [
          _Header(type: widget.args.type, copied: _copied, cs: cs),
          const SizedBox(height: AppSpacing.space5),
          Text('Borrador del correo', style: AppTextStyles.titleMd(cs.onSurface)),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Revisa el contenido. Copia el texto y pégalo en un correo '
            'dirigido a ${AppInfo.arcoEmail}.',
            style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space4),
          _EmailPreview(body: emailBody, cs: cs),
          const SizedBox(height: AppSpacing.space5),
          SizedBox(
            width: double.infinity,
            child: TButton(
              label: _copied ? 'Copiado' : 'Copiar texto',
              onPressed: _copyToClipboard,
              icon: _copied ? Icons.check : Icons.copy_outlined,
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          _Note(cs: cs),
          if (_copied) ...[
            const SizedBox(height: AppSpacing.space5),
            _SentNote(cs: cs),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.type,
    required this.copied,
    required this.cs,
  });

  final ArcoType type;
  final bool copied;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: copied
            ? cs.primaryContainer.withValues(alpha: 0.3)
            : cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: copied
              ? cs.primary.withValues(alpha: 0.3)
              : cs.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            copied ? Icons.check_circle : type.icon,
            size: 24,
            color: copied ? cs.primary : cs.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Derecho de ${type.label}',
                  style: AppTextStyles.titleMd(cs.onSurface),
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  copied
                      ? 'Texto listo. Ahora envíalo a ${AppInfo.arcoEmail}.'
                      : 'Genera el correo de solicitud formal.',
                  style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailPreview extends StatelessWidget {
  const _EmailPreview({required this.body, required this.cs});

  final String body;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(label: 'Para:', value: AppInfo.arcoEmail, cs: cs),
          const SizedBox(height: AppSpacing.space2),
          _Field(
            label: 'Asunto:',
            value: 'Solicitud de Derecho de [ARCO] — Trama Campus',
            cs: cs,
          ),
          Divider(
            height: AppSpacing.space6,
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
          SelectableText(body, style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, required this.cs});

  final String label;
  final String value;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
        ),
        Expanded(
          child: Text(value, style: AppTextStyles.labelSm(cs.onSurface)),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: AppSpacing.space2),
          Expanded(
            child: Text(
              'Copia el texto y envíalo a ${AppInfo.arcoEmail} desde tu correo institucional '
              'para que podamos verificar tu identidad.',
              style: AppTextStyles.bodySm(cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _SentNote extends StatelessWidget {
  const _SentNote({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space5),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 18, color: cs.primary),
              const SizedBox(width: AppSpacing.space2),
              Text('Plazo de respuesta', style: AppTextStyles.titleMd(cs.onSurface)),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          Text(
            'Una vez que envíes tu correo a ${AppInfo.arcoEmail}, el Responsable '
            'tiene un máximo de 20 días hábiles para responder (artículo 32, LFPDPPP).\n\n'
            'Si no recibes respuesta en ese plazo, puedes presentar una queja '
            'ante el INAI en www.inai.org.mx.',
            style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
