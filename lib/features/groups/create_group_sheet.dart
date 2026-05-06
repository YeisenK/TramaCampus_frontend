import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_grab_bar.dart';
import '../../data/models/group.dart';
import '../../data/repositories/app_state_repository.dart';

class CreateGroupSheet extends StatefulWidget {
  const CreateGroupSheet({super.key});

  @override
  State<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<CreateGroupSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  GroupKind _kind = GroupKind.study;
  GroupAccess _access = GroupAccess.open;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final group = Group(
      id: 'ug_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      tagline: _descCtrl.text.trim().isNotEmpty
          ? _descCtrl.text.trim()
          : '${_kind.label} · creado por ti',
      kind: _kind,
      access: _access,
      verified: false,
      featured: false,
      hue: (DateTime.now().millisecondsSinceEpoch % 360).toDouble(),
      memberCount: 1,
      activity: 'Nuevo',
      nextAction: 'Invita a tu primer miembro',
      leader: 'Tú',
      description: _descCtrl.text.trim(),
    );
    await AppStateRepository.instance.createGroup(group);
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.of(context).pushNamed(AppRouter.groupDetail, arguments: group);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space5,
            AppSpacing.space3,
            AppSpacing.space5,
            AppSpacing.space5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: TGrabBar()),
              const SizedBox(height: AppSpacing.space4),
              Text(
                'Nuevo grupo',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Arma tu grupo',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  letterSpacing: -0.02 * 26,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.space5),
              _SectionLabel(text: 'TIPO', cs: cs),
              const SizedBox(height: AppSpacing.space2),
              _KindGrid(
                selected: _kind,
                onChanged: (k) => setState(() => _kind = k),
              ),
              const SizedBox(height: AppSpacing.space5),
              _SheetField(
                controller: _nameCtrl,
                label: 'NOMBRE',
                hint: 'Ej. Filosofía de la mente',
              ),
              const SizedBox(height: AppSpacing.space4),
              _SheetField(
                controller: _descCtrl,
                label: 'DESCRIPCIÓN',
                hint: 'Describe tu grupo y sus objetivos…',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.space5),
              _SectionLabel(text: 'ACCESO', cs: cs),
              const SizedBox(height: AppSpacing.space1),
              _AccessList(
                selected: _access,
                onChanged: (v) => setState(() => _access = v),
              ),
              const SizedBox(height: AppSpacing.space6),
              TButton(
                label: 'Crear grupo',
                icon: Icons.check,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text, required this.cs});
  final String text;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: cs.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _KindGrid extends StatelessWidget {
  const _KindGrid({required this.selected, required this.onChanged});
  final GroupKind selected;
  final ValueChanged<GroupKind> onChanged;

  static const _items = [
    (
      GroupKind.study,
      Icons.menu_book_outlined,
      'Estudio',
      'Curso, materia o lectura.',
    ),
    (
      GroupKind.project,
      Icons.code_outlined,
      'Proyecto',
      'Equipo con entregables y fechas.',
    ),
    (
      GroupKind.club,
      Icons.groups_outlined,
      'Club',
      'Comunidad recurrente, abierta.',
    ),
    (
      GroupKind.sport,
      Icons.sports_outlined,
      'Deporte',
      'Entrenos y quedadas.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.space2,
        mainAxisSpacing: AppSpacing.space2,
        mainAxisExtent: 132,
      ),
      itemCount: _items.length,
      itemBuilder: (context, i) {
        final (kind, icon, label, desc) = _items[i];
        return _KindCard(
          icon: icon,
          label: label,
          desc: desc,
          isActive: selected == kind,
          onTap: () => onChanged(kind),
        );
      },
    );
  }
}

class _KindCard extends StatelessWidget {
  const _KindCard({
    required this.icon,
    required this.label,
    required this.desc,
    required this.isActive,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String desc;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = isActive ? cs.surface : cs.onSurface;
    final muted = isActive
        ? cs.surface.withValues(alpha: 0.72)
        : cs.onSurfaceVariant;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: isActive ? cs.onSurface : cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: isActive
              ? null
              : Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive
                    ? cs.surface.withValues(alpha: 0.12)
                    : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 18, color: fg),
            ),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: fg,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: muted,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessList extends StatelessWidget {
  const _AccessList({required this.selected, required this.onChanged});
  final GroupAccess selected;
  final ValueChanged<GroupAccess> onChanged;

  static const _items = [
    (
      GroupAccess.open,
      Icons.public_outlined,
      'Abierto',
      'Visible en Descubrir. Cualquier estudiante se une al instante.',
    ),
    (
      GroupAccess.request,
      Icons.how_to_reg_outlined,
      'Solicitar acceso',
      'Visible en Descubrir. Tú apruebas cada nueva solicitud.',
    ),
    (
      GroupAccess.invite,
      Icons.lock_outline,
      'Privado',
      'Solo por invitación. No aparece en Descubrir.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ghost = isDark
        ? AppColors.darkOutlineGhost
        : AppColors.lightOutlineGhost;
    return Column(
      children: List.generate(_items.length, (i) {
        final (access, icon, label, desc) = _items[i];
        final isActive = selected == access;
        return Container(
          decoration: i == 0
              ? null
              : BoxDecoration(
                  border: Border(top: BorderSide(color: ghost, width: 1)),
                ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(access),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.space3,
              ),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: cs.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          desc,
                          style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space2),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? cs.primary : Colors.transparent,
                      border: isActive
                          ? null
                          : Border.all(
                              color: cs.outlineVariant,
                              width: 1.5,
                            ),
                    ),
                    alignment: Alignment.center,
                    child: isActive
                        ? Icon(
                            Icons.check,
                            size: 12,
                            color: cs.onPrimary,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: cs.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyMd(cs.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMd(cs.onSurfaceVariant),
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space3,
              vertical: AppSpacing.space3,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
