import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_chip.dart';
import '../../core/widgets/t_text_field.dart';
import '../../data/repositories/onboarding_draft_repository.dart';
import '../../data/repositories/username_registry.dart';

class IdentityScreen extends StatefulWidget {
  const IdentityScreen({super.key});

  @override
  State<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();

  String? _gender;
  DateTime? _birthDate;

  // Username async validation state
  bool _checkingUsername = false;
  bool? _usernameAvailable;
  String? _usernameError;
  List<String> _usernameSuggestions = [];
  Timer? _usernameDebounce;

  static const _genders = [
    ('F', 'Mujer'),
    ('M', 'Hombre'),
    ('prefer_not_say', 'Prefiero no decirlo'),
  ];

  @override
  void initState() {
    super.initState();
    _loadDraft();
    _usernameCtrl.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDraft() async {
    final draft = await OnboardingDraftRepository.instance.load();
    if (!mounted) return;
    setState(() {
      _firstNameCtrl.text = draft.firstName ?? '';
      _lastNameCtrl.text = draft.lastName ?? '';
      _usernameCtrl.text = draft.username ?? '';
      _gender = draft.gender;
      _birthDate = draft.birthDate;
    });
  }

  void _onUsernameChanged() {
    _usernameDebounce?.cancel();
    final raw = _usernameCtrl.text;
    final shapeError = validateUsernameShape(raw);
    if (shapeError != null) {
      setState(() {
        _usernameError = shapeError;
        _usernameAvailable = null;
        _usernameSuggestions = [];
        _checkingUsername = false;
      });
      return;
    }
    setState(() {
      _usernameError = null;
      _usernameAvailable = null;
      _checkingUsername = true;
      _usernameSuggestions = [];
    });
    // Debounce: wait 300ms before firing the async check — avoids N futures on fast typing.
    _usernameDebounce = Timer(const Duration(milliseconds: 300), () {
      _checkAvailability(raw.trim().toLowerCase());
    });
  }

  Future<void> _checkAvailability(String handle) async {
    final available = await MockUsernameRegistry.instance.isAvailable(handle);
    if (!mounted || _usernameCtrl.text.trim().toLowerCase() != handle) return;
    if (!available) {
      final suggestions = await MockUsernameRegistry.instance.suggest(handle);
      if (!mounted) return;
      setState(() {
        _usernameAvailable = false;
        _usernameError = 'Este usuario ya está tomado';
        _usernameSuggestions = suggestions;
        _checkingUsername = false;
      });
    } else {
      setState(() {
        _usernameAvailable = true;
        _usernameError = null;
        _usernameSuggestions = [];
        _checkingUsername = false;
      });
    }
  }

  bool get _canContinue {
    final firstName = _firstNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final username = _usernameCtrl.text.trim();
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        validateUsernameShape(username) == null &&
        _usernameAvailable == true &&
        _gender != null &&
        _birthDate != null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 19),
      firstDate: DateTime(now.year - 60),
      lastDate: DateTime(now.year - 14),
      helpText: 'Fecha de nacimiento',
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _continue() async {
    final draft = await OnboardingDraftRepository.instance.load();
    final first = _firstNameCtrl.text.trim();
    final last = _lastNameCtrl.text.trim();
    draft
      ..firstName = first
      ..lastName = last
      ..displayName = '$first $last'
      ..username = _usernameCtrl.text.trim().toLowerCase()
      ..gender = _gender
      ..birthDate = _birthDate
      ..lastCompletedStep = 'identity';
    await OnboardingDraftRepository.instance.save(draft);
    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRouter.selectUni);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(cs),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.space5),
                  children: [
                    _buildNameRow(cs),
                    const SizedBox(height: AppSpacing.space5),
                    _buildUsernameField(cs),
                    const SizedBox(height: AppSpacing.space5),
                    _buildDateField(cs),
                    const SizedBox(height: AppSpacing.space5),
                    _buildGenderSelector(cs),
                  ],
                ),
              ),
            ),
            ListenableBuilder(
              listenable: Listenable.merge([_firstNameCtrl, _lastNameCtrl]),
              builder: (ctx, _) => Padding(
                padding: const EdgeInsets.all(AppSpacing.space5),
                child: TButton(
                  label: 'Continuar',
                  onPressed: _canContinue ? _continue : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) => Container(
    width: double.infinity,
    color: cs.surfaceDim,
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.space5,
      AppSpacing.space6,
      AppSpacing.space5,
      AppSpacing.space5,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: cs.onSurface,
              ),
            ),
            const Spacer(),
            const StepDots(totalSteps: 8, currentStep: 0),
          ],
        ),
        const SizedBox(height: AppSpacing.space5),
        Text('Tu identidad', style: AppTextStyles.headlineSm(cs.onSurface)),
        const SizedBox(height: AppSpacing.space2),
        Text(
          'Cómo te conocerán en Trama',
          style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
        ),
      ],
    ),
  );

  Widget _buildNameRow(ColorScheme cs) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: TTextField(
          controller: _firstNameCtrl,
          label: 'Nombre',
          hint: 'Yeisen',
          textInputAction: TextInputAction.next,
        ),
      ),
      const SizedBox(width: AppSpacing.space3),
      Expanded(
        child: TTextField(
          controller: _lastNameCtrl,
          label: 'Apellido',
          hint: 'Martínez',
          textInputAction: TextInputAction.next,
        ),
      ),
    ],
  );

  Widget _buildUsernameField(ColorScheme cs) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Usuario', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
      const SizedBox(height: AppSpacing.space2),
      TextField(
        controller: _usernameCtrl,
        keyboardType: TextInputType.text,
        autocorrect: false,
        textInputAction: TextInputAction.done,
        style: AppTextStyles.bodyMd(cs.onSurface),
        decoration: InputDecoration(
          hintText: '@yeisen',
          hintStyle: AppTextStyles.bodyMd(
            cs.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          prefixText: '@',
          prefixStyle: AppTextStyles.bodyMd(cs.primary),
          suffixIcon: _checkingUsername
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : _usernameAvailable == true
              ? Icon(Icons.check_circle, color: cs.primary, size: 20)
              : _usernameAvailable == false
              ? Icon(Icons.cancel, color: cs.error, size: 20)
              : null,
          filled: true,
          fillColor: cs.surfaceContainerLowest,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(color: cs.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(
              color: _usernameAvailable == false
                  ? cs.error
                  : _usernameAvailable == true
                  ? cs.primary
                  : cs.outlineVariant,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(color: cs.primary, width: 1.5),
          ),
        ),
      ),
      if (_usernameError != null) ...[
        const SizedBox(height: AppSpacing.space1),
        Text(_usernameError!, style: AppTextStyles.bodySm(cs.error)),
      ] else if (_usernameAvailable == true) ...[
        const SizedBox(height: AppSpacing.space1),
        Text(
          '@${_usernameCtrl.text.trim().toLowerCase()} está disponible',
          style: AppTextStyles.bodySm(cs.primary),
        ),
      ],
      if (_usernameSuggestions.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.space2),
        Text('Sugerencias:', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.space2),
        Wrap(
          spacing: AppSpacing.space2,
          children: _usernameSuggestions
              .map(
                (s) => TChip(
                  label: '@$s',
                  selected: false,
                  onTap: () {
                    _usernameCtrl.text = s;
                    _onUsernameChanged();
                  },
                ),
              )
              .toList(),
        ),
      ],
    ],
  );

  Widget _buildDateField(ColorScheme cs) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Fecha de nacimiento',
        style: AppTextStyles.labelSm(cs.onSurfaceVariant),
      ),
      const SizedBox(height: AppSpacing.space2),
      GestureDetector(
        onTap: _pickDate,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space4,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.space3),
              Text(
                _birthDate == null
                    ? 'Seleccionar fecha'
                    : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                style: _birthDate == null
                    ? AppTextStyles.bodyMd(
                        cs.onSurfaceVariant.withValues(alpha: 0.6),
                      )
                    : AppTextStyles.bodyMd(cs.onSurface),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildGenderSelector(ColorScheme cs) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Género', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
      const SizedBox(height: AppSpacing.space3),
      Wrap(
        spacing: AppSpacing.space2,
        runSpacing: AppSpacing.space2,
        children: _genders
            .map(
              (g) => TChip(
                label: g.$2,
                selected: _gender == g.$1,
                onTap: () => setState(() => _gender = g.$1),
              ),
            )
            .toList(),
      ),
    ],
  );
}
