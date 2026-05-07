import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/t_app_bar.dart';
import '../legal_documents_data.dart';
import 'legal_callout.dart';
import 'legal_meta_chip.dart';

class LegalDocumentLayout extends StatefulWidget {
  const LegalDocumentLayout({
    super.key,
    required this.document,
  });

  final LegalDocument document;

  @override
  State<LegalDocumentLayout> createState() => _LegalDocumentLayoutState();
}

class _LegalDocumentLayoutState extends State<LegalDocumentLayout> {
  final _scrollController = ScrollController();
  late final List<GlobalKey> _sectionKeys;

  @override
  void initState() {
    super.initState();
    _sectionKeys = List.generate(
      widget.document.sections.length,
      (_) => GlobalKey(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(BuildContext sheetContext, int index) {
    Navigator.of(sheetContext).pop();
    final ctx = _sectionKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        alignment: 0.05,
      );
    }
  }

  void _showToc() {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetCtx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, sc) {
            return Column(
              children: [
                const SizedBox(height: AppSpacing.space3),
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space6,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tabla de contenidos',
                      style: AppTextStyles.titleMd(cs.onSurface),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space3),
                Expanded(
                  child: ListView.separated(
                    controller: sc,
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.space6,
                      0,
                      AppSpacing.space6,
                      AppSpacing.space6 +
                          MediaQuery.of(sheetCtx).padding.bottom,
                    ),
                    itemCount: widget.document.sections.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.space1),
                    itemBuilder: (_, i) {
                      final s = widget.document.sections[i];
                      return InkWell(
                        onTap: () => _scrollToSection(sheetCtx, i),
                        borderRadius:
                            BorderRadius.circular(AppRadius.sm),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.space3,
                            horizontal: AppSpacing.space2,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.title,
                                  style:
                                      AppTextStyles.bodyMd(cs.onSurface),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: cs.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _copyDocument() {
    final buf = StringBuffer();
    buf.writeln(widget.document.title);
    buf.writeln(
      'Versión ${widget.document.version} · Vigente desde ${widget.document.effectiveDate}',
    );
    buf.writeln();
    for (final s in widget.document.sections) {
      buf.writeln(s.title);
      buf.writeln(s.body);
      buf.writeln();
    }
    Clipboard.setData(ClipboardData(text: buf.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Documento copiado al portapapeles')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final doc = widget.document;

    return Scaffold(
      appBar: TAppBar(
        title: doc.title,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_outlined, size: 20),
            tooltip: 'Copiar documento',
            onPressed: _copyDocument,
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.edgePadding,
              AppSpacing.space4,
              AppSpacing.edgePadding,
              120,
            ),
            itemCount: doc.sections.length + 2,
            separatorBuilder: (_, i) {
              if (i == 0) return const SizedBox(height: AppSpacing.space5);
              return const SizedBox(height: AppSpacing.space6);
            },
            itemBuilder: (_, i) {
              if (i == 0) return _buildDocHeader(cs, doc);
              if (i == doc.sections.length + 1) {
                return _buildDocFooter(cs, doc);
              }
              final section = doc.sections[i - 1];
              return _buildSection(cs, section, _sectionKeys[i - 1]);
            },
          ),
          Positioned(
            bottom: 24,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (doc.showArcoButton)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                    child: _ArcoFab(),
                  ),
                FloatingActionButton.small(
                  heroTag: 'toc_${doc.id}',
                  onPressed: _showToc,
                  tooltip: 'Tabla de contenidos',
                  backgroundColor: cs.surfaceContainerHighest,
                  foregroundColor: cs.onSurfaceVariant,
                  elevation: 2,
                  child: const Icon(Icons.list_outlined, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocHeader(ColorScheme cs, LegalDocument doc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(doc.icon, size: 28, color: cs.primary),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Text(
                doc.title,
                style: AppTextStyles.headlineSm(cs.onSurface),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space3),
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: [
            LegalMetaChip(
              label: 'v${doc.version}',
              icon: Icons.bookmark_outline,
            ),
            LegalMetaChip(
              label: 'Vigente: ${doc.effectiveDate}',
              icon: Icons.calendar_today_outlined,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space4),
        Divider(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ],
    );
  }

  Widget _buildSection(
    ColorScheme cs,
    LegalSection section,
    GlobalKey key,
  ) {
    if (section.isCallout) {
      return Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.title, style: AppTextStyles.titleMd(cs.onSurface)),
          const SizedBox(height: AppSpacing.space3),
          LegalCallout(
            text: section.body,
            icon: section.calloutIcon,
          ),
        ],
      );
    }

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title, style: AppTextStyles.titleMd(cs.onSurface)),
        const SizedBox(height: AppSpacing.space3),
        Text(section.body, style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildDocFooter(ColorScheme cs, LegalDocument doc) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space5),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contacto',
            style: AppTextStyles.titleMd(cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.space3),
          _FooterContactRow(
            icon: Icons.mail_outline,
            label: 'Privacidad',
            value: 'privacidad@tramacampus.mx',
            cs: cs,
          ),
          const SizedBox(height: AppSpacing.space2),
          _FooterContactRow(
            icon: Icons.gavel,
            label: 'Derechos ARCO',
            value: 'arco@tramacampus.mx',
            cs: cs,
          ),
          const SizedBox(height: AppSpacing.space4),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.4)),
          const SizedBox(height: AppSpacing.space3),
          Text(
            'Este documento tiene validez legal. Para el texto con fuerza normativa completa '
            'consulta la versión publicada en la app. Última revisión: ${doc.effectiveDate}.',
            style: AppTextStyles.bodySm(cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ArcoFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.primary,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      elevation: 3,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(AppRouter.arcoRequest),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space3,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.gavel, size: 16, color: cs.onPrimary),
              const SizedBox(width: AppSpacing.space2),
              Text(
                'Solicitud ARCO',
                style: AppTextStyles.labelSm(cs.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterContactRow extends StatelessWidget {
  const _FooterContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
  });

  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: cs.onSurfaceVariant),
        const SizedBox(width: AppSpacing.space2),
        Text('$label: ', style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
        Flexible(
          child: Text(value, style: AppTextStyles.bodySm(cs.primary)),
        ),
      ],
    );
  }
}
