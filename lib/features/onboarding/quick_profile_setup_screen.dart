import 'package:flutter/material.dart';

import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_chip.dart';
import '../../data/models/profile/preferences.dart';
import '../../data/models/profile/profile.dart';
import '../../data/models/profile/profile_attribute.dart';
import '../../data/models/profile/profile_base.dart';
import '../../data/repositories/app_state_repository.dart';
import '../../data/repositories/auth_repository.dart';

/// One-screen profile setup shown right after register or after login
/// when the account doesn't have a saved profile yet. Captures the
/// minimum the local matching engine needs to rank candidates.
class QuickProfileSetupScreen extends StatefulWidget {
  const QuickProfileSetupScreen({super.key});

  @override
  State<QuickProfileSetupScreen> createState() =>
      _QuickProfileSetupScreenState();
}

class _QuickProfileSetupScreenState extends State<QuickProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  DateTime? _birthDate;
  String _gender = 'F';
  String _genderPreference = 'any';
  String _city = 'Oaxaca';
  final Set<String> _interests = {};
  final Set<String> _modes = {};
  final Set<String> _personality = {};
  bool _saving = false;
  String? _error;

  static const _interestCatalog = [
    'música', 'cine', 'fotografía', 'lectura', 'escritura', 'teatro',
    'yoga', 'gym', 'natación', 'fútbol', 'running', 'senderismo',
    'ajedrez', 'videojuegos', 'anime', 'manga', 'cocina', 'café',
    'viajes', 'arte', 'diseño', 'programación', 'emprendimiento',
    'voluntariado', 'política', 'ciencia', 'investigación', 'idiomas',
  ];

  static const _modeOptions = [
    ('estudio', 'Estudio'),
    ('amistad', 'Amistad'),
    ('personal', 'Conexión personal'),
  ];

  static const _personalityCatalog = [
    'curioso', 'creativo', 'analítico', 'sociable', 'reservado',
    'aventurero', 'metódico', 'empático', 'líder', 'reflexivo',
  ];

  static const _cityOptions = [
    'Oaxaca', 'Puebla', 'CDMX', 'Monterrey', 'Guadalajara', 'Querétaro',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = _birthDate ?? DateTime(now.year - 20, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 80),
      lastDate: DateTime(now.year - 13, now.month, now.day),
      helpText: 'Tu fecha de nacimiento',
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  int _ageFromBirthDate(DateTime bd) {
    final now = DateTime.now();
    var years = now.year - bd.year;
    if (now.month < bd.month ||
        (now.month == bd.month && now.day < bd.day)) {
      years--;
    }
    return years;
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Ingresá tu nombre');
      return;
    }
    if (_birthDate == null) {
      setState(() => _error = 'Elegí tu fecha de nacimiento');
      return;
    }
    final age = _ageFromBirthDate(_birthDate!);
    if (age < 16 || age > 99) {
      setState(() => _error = 'La edad calculada debe estar entre 16 y 99');
      return;
    }
    if (_interests.isEmpty) {
      setState(() => _error = 'Elegí al menos un interés');
      return;
    }
    if (_modes.isEmpty) {
      setState(() => _error = 'Elegí al menos una modalidad');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final parts = name.split(RegExp(r'\s+'));
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final email = AuthRepository.instance.currentEmail ?? '';
    final username = email.contains('@')
        ? email.split('@').first.toLowerCase()
        : firstName.toLowerCase();
    final birthDate = _birthDate!;

    final profile = Profile(
      base: ProfileBase(
        displayName: name,
        firstName: firstName,
        lastName: lastName,
        username: username,
        bio: '',
        careerId: '',
        semester: 1,
        universityId: '',
        gender: _gender,
        genderPreference: _genderPreference,
        birthDate: birthDate,
      ),
      preferences: Preferences(
        modes: _modes.toList(),
        uiModality: _modes.join(','),
        goals: const [],
        skills: const [],
        connectivityState: 'active',
      ),
      attributes: [
        ..._interests.map((i) => HobbyAttribute(hobbyId: i)),
        ..._personality.map((t) => PersonalityAttribute(traitId: t)),
      ],
    );

    await AppStateRepository.instance.updateProfile(profile);
    // City is used by the local matching engine; stash it on the
    // app-state side as well so we don't extend the Profile schema.
    AppStateRepository.instance.setCity(_city);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRouter.discover, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space6,
            AppSpacing.space5,
            AppSpacing.space6,
            AppSpacing.space7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu perfil',
                style: AppTextStyles.headlineMd(cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.space2),
              Text(
                'Una vez. Usamos esto para sugerirte personas compatibles.',
                style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space6),

              _SectionLabel(label: 'Nombre completo'),
              _TextField(controller: _nameCtrl, cs: cs, hint: 'Nombre Apellido'),

              const SizedBox(height: AppSpacing.space5),
              _SectionLabel(label: 'Fecha de nacimiento'),
              _DatePickerField(
                value: _birthDate,
                onTap: _pickBirthDate,
                cs: cs,
              ),

              const SizedBox(height: AppSpacing.space5),
              _SectionLabel(label: 'Género'),
              _ChipRow(
                options: const [('F', 'Mujer'), ('M', 'Hombre'), ('NR', 'Prefiero no decir')],
                selected: _gender,
                onSelected: (v) => setState(() => _gender = v),
              ),

              const SizedBox(height: AppSpacing.space5),
              _SectionLabel(label: 'Prefiero conectar con'),
              _ChipRow(
                options: const [('any', 'Cualquiera'), ('F', 'Mujeres'), ('M', 'Hombres')],
                selected: _genderPreference,
                onSelected: (v) => setState(() => _genderPreference = v),
              ),

              const SizedBox(height: AppSpacing.space5),
              _SectionLabel(label: 'Ciudad'),
              _DropdownRow(
                value: _city,
                options: _cityOptions,
                onChanged: (v) => setState(() => _city = v),
                cs: cs,
              ),

              const SizedBox(height: AppSpacing.space6),
              _SectionLabel(label: 'Modalidades de conexión'),
              const SizedBox(height: AppSpacing.space2),
              _MultiSelectChips(
                options: _modeOptions,
                selected: _modes,
                onToggle: (id) => setState(() {
                  _modes.contains(id) ? _modes.remove(id) : _modes.add(id);
                }),
              ),

              const SizedBox(height: AppSpacing.space6),
              _SectionLabel(label: 'Intereses'),
              Text(
                'Elegí al menos 3 que te representen',
                style: AppTextStyles.bodySm(cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space3),
              _MultiSelectChips(
                options: _interestCatalog.map((i) => (i, i)).toList(),
                selected: _interests,
                onToggle: (id) => setState(() {
                  _interests.contains(id)
                      ? _interests.remove(id)
                      : _interests.add(id);
                }),
              ),

              const SizedBox(height: AppSpacing.space6),
              _SectionLabel(label: 'Personalidad'),
              Text(
                'Opcional — ayuda a afinar las sugerencias',
                style: AppTextStyles.bodySm(cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space3),
              _MultiSelectChips(
                options: _personalityCatalog.map((p) => (p, p)).toList(),
                selected: _personality,
                onToggle: (id) => setState(() {
                  _personality.contains(id)
                      ? _personality.remove(id)
                      : _personality.add(id);
                }),
              ),

              if (_error != null) ...[
                const SizedBox(height: AppSpacing.space4),
                Text(_error!, style: AppTextStyles.bodySm(cs.error)),
              ],
              const SizedBox(height: AppSpacing.space7),
              TButton(
                label: _saving ? 'Guardando…' : 'Empezar a explorar',
                onPressed: _saving ? null : _save,
                icon: _saving ? null : Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Text(label, style: AppTextStyles.titleMd(cs.onSurface)),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.cs,
    this.hint,
  });
  final TextEditingController controller;
  final ColorScheme cs;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTextStyles.bodyMd(cs.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: cs.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space4,
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.value,
    required this.onTap,
    required this.cs,
  });

  final DateTime? value;
  final VoidCallback onTap;
  final ColorScheme cs;

  static const _months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  String _format(DateTime d) =>
      '${d.day} de ${_months[d.month - 1]} de ${d.year}';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Text(
                value == null ? 'Elegí tu fecha' : _format(value!),
                style: AppTextStyles.bodyMd(
                  value == null ? cs.onSurfaceVariant : cs.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.options,
    required this.selected,
    required this.onSelected,
  });
  final List<(String, String)> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.space2,
      runSpacing: AppSpacing.space2,
      children: options
          .map(
            (o) => TChip(
              label: o.$2,
              selected: selected == o.$1,
              onTap: () => onSelected(o.$1),
            ),
          )
          .toList(),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  const _DropdownRow({
    required this.value,
    required this.options,
    required this.onChanged,
    required this.cs,
  });
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: cs.onSurfaceVariant),
          items: options
              .map(
                (o) => DropdownMenuItem(
                  value: o,
                  child: Text(o, style: AppTextStyles.bodyMd(cs.onSurface)),
                ),
              )
              .toList(),
          onChanged: (v) => v == null ? null : onChanged(v),
        ),
      ),
    );
  }
}

class _MultiSelectChips extends StatelessWidget {
  const _MultiSelectChips({
    required this.options,
    required this.selected,
    required this.onToggle,
  });
  final List<(String, String)> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.space2,
      runSpacing: AppSpacing.space2,
      children: options
          .map(
            (o) => TChip(
              label: o.$2,
              selected: selected.contains(o.$1),
              onTap: () => onToggle(o.$1),
            ),
          )
          .toList(),
    );
  }
}
