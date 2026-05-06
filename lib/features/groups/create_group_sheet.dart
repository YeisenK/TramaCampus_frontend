import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_grab_bar.dart';
import '../../data/models/group.dart';

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

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) return;
    Navigator.pop(context);
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
            AppSpacing.space4,
            AppSpacing.space3,
            AppSpacing.space4,
            AppSpacing.space4,
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
              Text(
                'Tipo de grupo',
                style: AppTextStyles.labelSm(cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space2),
              _KindGrid(
                selected: _kind,
                onChanged: (k) => setState(() => _kind = k),
              ),
              const SizedBox(height: AppSpacing.space4),
              _SheetField(
                controller: _nameCtrl,
                label: 'Nombre del grupo',
                hint: 'Ej. Hackathon Nacional · Equipo C',
              ),
              const SizedBox(height: AppSpacing.space3),
              _SheetField(
                controller: _descCtrl,
                label: 'Descripción',
                hint: 'Describe tu grupo y sus objetivos...',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                'Acceso',
                style: AppTextStyles.labelSm(cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space2),
              ...GroupAccess.values.map(
                (a) => _AccessRadio(
                  access: a,
                  selected: _access,
                  onChanged: (v) => setState(() => _access = v),
                ),
              ),
              const SizedBox(height: AppSpacing.space5),
              TButton(
                label: 'Crear grupo',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KindGrid extends StatelessWidget {
  const _KindGrid({required this.selected, required this.onChanged});
  final GroupKind selected;
  final ValueChanged<GroupKind> onChanged;

  static const _items = [
    (GroupKind.study, Icons.menu_book_outlined, 'Estudio'),
    (GroupKind.project, Icons.code_outlined, 'Proyecto'),
    (GroupKind.club, Icons.groups_outlined, 'Club'),
    (GroupKind.sport, Icons.sports_outlined, 'Deporte'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.space2,
        mainAxisSpacing: AppSpacing.space2,
        mainAxisExtent: 64,
      ),
      itemCount: _items.length,
      itemBuilder: (context, i) {
        final (kind, icon, label) = _items[i];
        final isActive = selected == kind;
        return GestureDetector(
          onTap: () => onChanged(kind),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(AppSpacing.space3),
            decoration: BoxDecoration(
              color: isActive ? cs.onSurface : cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive ? cs.surface : cs.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.space2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isActive ? cs.surface : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccessRadio extends StatelessWidget {
  const _AccessRadio({
    required this.access,
    required this.selected,
    required this.onChanged,
  });
  final GroupAccess access;
  final GroupAccess selected;
  final ValueChanged<GroupAccess> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isActive = selected == access;
    return GestureDetector(
      onTap: () => onChanged(access),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? cs.primary : cs.outlineVariant,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: isActive
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.space3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  access.label,
                  style: AppTextStyles.titleMd(cs.onSurface),
                ),
              ],
            ),
          ],
        ),
      ),
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
        Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyMd(cs.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMd(cs.onSurfaceVariant),
            filled: true,
            fillColor: cs.surfaceContainerHigh,
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
