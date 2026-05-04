import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_chip.dart';
import '../../core/widgets/t_text_field.dart';
import '../../data/mock/mock_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _programCtrl;
  late int _semester;
  late Set<String> _interests;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = MockData.currentUser;
    _nameCtrl = TextEditingController(text: user.name);
    _bioCtrl = TextEditingController(text: user.bio);
    _programCtrl = TextEditingController(text: user.program);
    _semester = user.semester;
    _interests = user.interests.toSet();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _programCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Editar perfil'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space6,
            AppSpacing.space4,
            AppSpacing.space6,
            AppSpacing.space10,
          ),
          children: [
            TTextField(
              controller: _nameCtrl,
              label: 'Nombre',
              hint: 'Tu nombre completo',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'El nombre es requerido'
                  : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.space5),
            TTextField(
              controller: _programCtrl,
              label: 'Carrera',
              hint: 'Ej. Ingeniería en Sistemas',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.space5),
            Text('Semestre', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.space2),
            _SemesterSelector(
              value: _semester,
              onChanged: (v) => setState(() => _semester = v),
            ),
            const SizedBox(height: AppSpacing.space5),
            TTextField(
              controller: _bioCtrl,
              label: 'Bio',
              hint: 'Cuéntanos sobre ti (máx. 200 caracteres)',
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              validator: (v) {
                if (v != null && v.length > 200) return 'Máximo 200 caracteres';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.space5),
            Text(
              'Intereses',
              style: AppTextStyles.labelSm(cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.space3),
            _InterestPicker(
              selected: _interests,
              onToggle: (tag) => setState(() {
                if (_interests.contains(tag)) {
                  _interests.remove(tag);
                } else if (_interests.length < 10) {
                  _interests.add(tag);
                }
              }),
            ),
            const SizedBox(height: AppSpacing.space8),
            TButton(
              label: 'Guardar cambios',
              onPressed: _save,
              isLoading: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}

class _SemesterSelector extends StatelessWidget {
  const _SemesterSelector({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.space2,
      runSpacing: AppSpacing.space2,
      children: List.generate(10, (i) {
        final s = i + 1;
        return TChip(
          label: 'Sem. $s',
          selected: value == s,
          onTap: () => onChanged(s),
        );
      }),
    );
  }
}

class _InterestPicker extends StatelessWidget {
  const _InterestPicker({required this.selected, required this.onToggle});
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  static const _tags = [
    'Tecnología',
    'Diseño',
    'Música',
    'Deportes',
    'Arte',
    'Cine',
    'Literatura',
    'Fotografía',
    'Viajes',
    'Cocina',
    'Gaming',
    'Ciencia',
    'Emprendimiento',
    'Idiomas',
    'Yoga',
    'Danza',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.space2,
      runSpacing: AppSpacing.space2,
      children: _tags
          .map(
            (tag) => TChip(
              label: tag,
              selected: selected.contains(tag),
              onTap: () => onToggle(tag),
            ),
          )
          .toList(),
    );
  }
}
