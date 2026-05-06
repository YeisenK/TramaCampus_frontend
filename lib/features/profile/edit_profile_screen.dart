import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/selection/selection_experience.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_avatar.dart';
import '../../core/widgets/t_chip.dart';
import '../../core/widgets/t_text_field.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/modality.dart';
import '../../data/models/modality_bucket.dart';
import '../../data/models/profile/profile.dart';
import '../../data/models/profile/profile_attribute.dart';
import '../../data/repositories/app_state_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _bioCtrl;
  late String _firstName;
  late String _lastName;
  late String _username;
  late String _careerId;
  late String _campusId;
  late int _semester;
  late Set<String> _goals;
  late Set<String> _skills;
  late Set<String> _modalityBuckets;
  late Set<String> _availableDays;
  late String _genderPreference;
  late Set<String> _hobbies;
  late Set<String> _sportIds;
  late Map<String, SportFrequency> _sportFrequencies;
  late Set<String> _personalityIds;
  late Set<String> _musicIds;
  late Set<String> _dietIds;
  late Set<String> _researchIds;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = AppStateRepository.instance.profile;
    _bioCtrl = TextEditingController(text: p.base.bio);
    _firstName = p.base.firstName;
    _lastName = p.base.lastName;
    _username = p.base.username;
    _careerId = p.base.careerId;
    _campusId = p.base.universityId;
    _semester = p.base.semester;
    _goals = p.preferences.goals.toSet();
    _skills = p.preferences.skills.toSet();
    _modalityBuckets = p.preferences.uiModality
        .split(',')
        .where((s) => s.isNotEmpty)
        .toSet();
    _availableDays = p.preferences.availableDays.toSet();
    _genderPreference = p.base.genderPreference;
    _hobbies = p.hobbyIds.toSet();
    _sportIds = p.sports.map((s) => s.sportId).toSet();
    _sportFrequencies = {for (final s in p.sports) s.sportId: s.frequency};
    _personalityIds = p.personalityTraitIds.toSet();
    _musicIds = p.musicGenreIds.toSet();
    _dietIds = p.dietIds.toSet();
    _researchIds = p.preferences.researchInterests.toSet();
  }

  @override
  void dispose() {
    _bioCtrl.dispose();
    super.dispose();
  }

  // ── Computed ──────────────────────────────────────────────────────────────

  double _completionScore(String bioText) {
    double score = 0;
    if (_goals.isNotEmpty) score += 0.20;
    if (_skills.length >= 3) score += 0.20;
    if (_modalityBuckets.isNotEmpty) score += 0.15;
    if (_availableDays.isNotEmpty) score += 0.10;
    if (bioText.trim().length >= 20) score += 0.10;
    if (_hobbies.isNotEmpty) score += 0.10;
    if (_personalityIds.isNotEmpty) score += 0.10;
    if (_musicIds.isNotEmpty || _dietIds.isNotEmpty) score += 0.05;
    return score.clamp(0.0, 1.0);
  }

  String _nextInsight(String bioText) {
    if (_goals.isEmpty) return 'Agrega objetivos para mejorar tus matches';
    if (_skills.length < 3) {
      return 'Completa tus habilidades para destacar en el feed';
    }
    if (_modalityBuckets.isEmpty) {
      return 'Define cómo quieres conectar con otros';
    }
    if (_availableDays.isEmpty) {
      return 'Agrega disponibilidad para más conexiones';
    }
    if (bioText.trim().length < 20) {
      return 'Escribe una bio para presentarte mejor';
    }
    if (_hobbies.isEmpty) {
      return 'Agrega intereses para mejores recomendaciones';
    }
    if (_personalityIds.isEmpty) {
      return 'Completa tu personalidad para matches más precisos';
    }
    return 'Perfil sólido. Siempre puedes seguir refinando.';
  }

  List<ModalityBucketId> get _buckets => ModalityBucketId.values
      .where((b) => _modalityBuckets.contains(b.name))
      .toList();

  // ── Catalog pickers (full-screen) ─────────────────────────────────────────

  Future<void> _openPicker({
    required String title,
    required String catalogName,
    required SelectionVariant variant,
    required Set<String> initialSelected,
    int min = 0,
    int max = 50,
    Map<String, SportFrequency>? sportFrequencies,
  }) async {
    final result = await Navigator.of(context).push<_PickerResult>(
      MaterialPageRoute(
        builder: (_) => _SelectionPickerPage(
          title: title,
          catalogName: catalogName,
          variant: variant,
          initialSelected: initialSelected,
          careerId: _careerId,
          campusId: _campusId,
          activeBuckets: _buckets,
          currentGoals: _goals,
          min: min,
          max: max,
          sportFrequencies: sportFrequencies ?? const {},
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      switch (catalogName) {
        case 'skill':
          _skills = result.selected;
        case 'hobby':
          _hobbies = result.selected;
        case 'sport':
          _sportIds = result.selected;
          if (result.sportFrequencies != null) {
            _sportFrequencies = result.sportFrequencies!;
          }
        case 'personality_trait':
          _personalityIds = result.selected;
        case 'music_genre':
          _musicIds = result.selected;
        case 'diet':
          _dietIds = result.selected;
        case 'research_interest':
          _researchIds = result.selected;
        case 'goal':
          _goals = result.selected;
      }
    });
  }

  void _openAvailabilityPicker() async {
    final result = await Navigator.of(context).push<Set<String>>(
      MaterialPageRoute(
        builder: (_) =>
            _AvailabilityPickerPage(selected: Set.from(_availableDays)),
      ),
    );
    if (result != null && mounted) setState(() => _availableDays = result);
  }

  // ── Bottom sheets ─────────────────────────────────────────────────────────

  void _openBioSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          _BioSheet(controller: _bioCtrl, onSave: () => Navigator.pop(ctx)),
    );
  }

  void _openModalitySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ModalitySheet(
        selected: Set.from(_modalityBuckets),
        onSave: (s) {
          setState(() => _modalityBuckets = s);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _openSemesterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SemesterSheet(
        value: _semester,
        onChanged: (v) {
          setState(() => _semester = v);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _openGenderPrefSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _GenderPrefSheet(
        value: _genderPreference,
        onChanged: (v) {
          setState(() => _genderPreference = v);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final existing = AppStateRepository.instance.profile;
    final updated = Profile(
      base: existing.base.copyWith(
        firstName: _firstName,
        lastName: _lastName,
        displayName: '$_firstName $_lastName',
        username: _username,
        bio: _bioCtrl.text.trim(),
        careerId: _careerId,
        universityId: _campusId,
        semester: _semester,
        genderPreference: _genderPreference,
      ),
      preferences: existing.preferences.copyWith(
        goals: _goals.toList(),
        skills: _skills.toList(),
        uiModality: _modalityBuckets.join(','),
        availableDays: _availableDays.toList(),
        researchInterests: _researchIds.toList(),
      ),
      attributes: [
        ..._hobbies.map((id) => HobbyAttribute(hobbyId: id)),
        ..._sportIds.map(
          (id) => SportAttribute(
            sportId: id,
            frequency: _sportFrequencies[id] ?? SportFrequency.casual,
          ),
        ),
        ..._personalityIds.map((id) => PersonalityAttribute(traitId: id)),
        ..._musicIds.map((id) => MusicAttribute(genreId: id)),
        ..._dietIds.map((id) => DietAttribute(dietId: id)),
      ],
    );
    await AppStateRepository.instance.updateProfile(updated);
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
    Navigator.of(context).pop();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = MockData.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar perfil',
          style: AppTextStyles.titleMd(cs.onSurface),
        ),
        centerTitle: false,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.space4),
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : TextButton(
                    onPressed: _save,
                    child: Text(
                      'Guardar',
                      style: AppTextStyles.titleMd(cs.primary),
                    ),
                  ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header responds to bio text changes without rebuilding the whole screen.
          SliverToBoxAdapter(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _bioCtrl,
              builder: (ctx, bioValue, _) => _ProfileHeader(
                firstName: _firstName,
                lastName: _lastName,
                username: _username,
                hue: user.hue,
                photoUrl: user.photoUrl,
                completionScore: _completionScore(bioValue.text),
                insight: _nextInsight(bioValue.text),
              ),
            ),
          ),

          // --- Alta prioridad ---
          SliverToBoxAdapter(child: _GroupLabel(label: 'Para mejor matching')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space5),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionCard(
                  icon: Icons.flag_outlined,
                  title: 'Objetivos',
                  emptyHint: 'Define qué buscas en Trama',
                  impactLabel: 'Alta prioridad',
                  isFilled: _goals.isNotEmpty,
                  previewItems: _goals.take(3).map(_label).toList(),
                  overflow: _goals.length > 3 ? _goals.length - 3 : 0,
                  onTap: () => _openPicker(
                    title: 'Objetivos',
                    catalogName: 'goal',
                    variant: SelectionVariant.chipCloud,
                    initialSelected: _goals,
                    min: 1,
                    max: 5,
                  ),
                ),
                _SectionCard(
                  icon: Icons.auto_awesome_outlined,
                  title: 'Habilidades',
                  emptyHint: 'Muestra en qué eres bueno',
                  impactLabel: 'Alta prioridad',
                  isFilled: _skills.isNotEmpty,
                  previewItems: _skills.take(3).map(_label).toList(),
                  overflow: _skills.length > 3 ? _skills.length - 3 : 0,
                  onTap: () => _openPicker(
                    title: 'Habilidades',
                    catalogName: 'skill',
                    variant: SelectionVariant.bucketed,
                    initialSelected: _skills,
                    min: 0,
                    max: 50,
                  ),
                ),
                _SectionCard(
                  icon: Icons.explore_outlined,
                  title: 'Modalidad',
                  emptyHint: 'Cómo quieres conectar con otros',
                  impactLabel: 'Alta prioridad',
                  isFilled: _modalityBuckets.isNotEmpty,
                  previewItems: _modalityBuckets.map((b) {
                    return Modality.all
                            .where((m) => m.type.name == b)
                            .firstOrNull
                            ?.label ??
                        b;
                  }).toList(),
                  overflow: 0,
                  onTap: _openModalitySheet,
                ),
                _SectionCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Disponibilidad',
                  emptyHint: 'Cuándo puedes conectar con otros',
                  impactLabel: 'Alta prioridad',
                  isFilled: _availableDays.isNotEmpty,
                  previewItems: _availableDays.isEmpty
                      ? []
                      : ['${_availableDays.length} horarios disponibles'],
                  overflow: 0,
                  onTap: _openAvailabilityPicker,
                ),
              ]),
            ),
          ),

          // --- Personalización ---
          SliverToBoxAdapter(child: _GroupLabel(label: 'Personalización')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space5),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionCard(
                  icon: Icons.person_outline,
                  title: 'Bio',
                  emptyHint: 'Preséntate en unas líneas',
                  impactLabel: 'Media prioridad',
                  isFilled: _bioCtrl.text.trim().length >= 20,
                  previewItems: const [],
                  previewText: _bioCtrl.text.trim().isEmpty
                      ? null
                      : _bioCtrl.text.trim(),
                  overflow: 0,
                  onTap: _openBioSheet,
                ),
                _SectionCard(
                  icon: Icons.interests_outlined,
                  title: 'Intereses',
                  emptyHint: 'Hobbies y actividades que disfrutas',
                  impactLabel: 'Media prioridad',
                  isFilled: _hobbies.isNotEmpty,
                  previewItems: _hobbies.take(3).map(_label).toList(),
                  overflow: _hobbies.length > 3 ? _hobbies.length - 3 : 0,
                  onTap: () => _openPicker(
                    title: 'Intereses',
                    catalogName: 'hobby',
                    variant: SelectionVariant.bucketed,
                    initialSelected: _hobbies,
                    min: 0,
                    max: 30,
                  ),
                ),
                _SectionCard(
                  icon: Icons.sports_outlined,
                  title: 'Deportes',
                  emptyHint: 'Actividades físicas que practicas',
                  impactLabel: null,
                  isFilled: _sportIds.isNotEmpty,
                  previewItems: _sportIds.take(3).map(_label).toList(),
                  overflow: _sportIds.length > 3 ? _sportIds.length - 3 : 0,
                  onTap: () => _openPicker(
                    title: 'Deportes',
                    catalogName: 'sport',
                    variant: SelectionVariant.chipCloud,
                    initialSelected: _sportIds,
                    min: 0,
                    max: 6,
                    sportFrequencies: _sportFrequencies,
                  ),
                ),
                _SectionCard(
                  icon: Icons.psychology_outlined,
                  title: 'Personalidad',
                  emptyHint: 'Cómo te describirías a ti mismo',
                  impactLabel: 'Media prioridad',
                  isFilled: _personalityIds.isNotEmpty,
                  previewItems: _personalityIds.take(3).map(_label).toList(),
                  overflow: _personalityIds.length > 3
                      ? _personalityIds.length - 3
                      : 0,
                  onTap: () => _openPicker(
                    title: 'Personalidad',
                    catalogName: 'personality_trait',
                    variant: SelectionVariant.traitCards,
                    initialSelected: _personalityIds,
                    min: 0,
                    max: 5,
                  ),
                ),
                // Academic (read-only campus/career, editable semester)
                _SectionCard(
                  icon: Icons.school_outlined,
                  title: 'Académico',
                  emptyHint: 'Tu carrera y semestre actual',
                  impactLabel: null,
                  isFilled: true,
                  previewItems: [_careerId, 'Sem. $_semester'],
                  overflow: 0,
                  onTap: _openSemesterSheet,
                ),
              ]),
            ),
          ),

          // --- Opcionales ---
          SliverToBoxAdapter(child: _GroupLabel(label: 'Opcional')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space5),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionCard(
                  icon: Icons.music_note_outlined,
                  title: 'Música',
                  emptyHint: 'Géneros que escuchas',
                  impactLabel: null,
                  isFilled: _musicIds.isNotEmpty,
                  previewItems: _musicIds.take(3).map(_label).toList(),
                  overflow: _musicIds.length > 3 ? _musicIds.length - 3 : 0,
                  onTap: () => _openPicker(
                    title: 'Música',
                    catalogName: 'music_genre',
                    variant: SelectionVariant.chipCloud,
                    initialSelected: _musicIds,
                    min: 0,
                    max: 8,
                  ),
                ),
                _SectionCard(
                  icon: Icons.restaurant_menu_outlined,
                  title: 'Dieta',
                  emptyHint: 'Tu preferencia alimentaria',
                  impactLabel: null,
                  isFilled: _dietIds.isNotEmpty,
                  previewItems: _dietIds.map(_label).toList(),
                  overflow: 0,
                  onTap: () => _openPicker(
                    title: 'Dieta',
                    catalogName: 'diet',
                    variant: SelectionVariant.iconCards,
                    initialSelected: _dietIds,
                    min: 0,
                    max: 1,
                  ),
                ),
                _SectionCard(
                  icon: Icons.science_outlined,
                  title: 'Investigación',
                  emptyHint: 'Temas académicos que te interesan',
                  impactLabel: null,
                  isFilled: _researchIds.isNotEmpty,
                  previewItems: _researchIds.take(3).map(_label).toList(),
                  overflow: _researchIds.length > 3
                      ? _researchIds.length - 3
                      : 0,
                  onTap: () => _openPicker(
                    title: 'Investigación',
                    catalogName: 'research_interest',
                    variant: SelectionVariant.facultyFaceted,
                    initialSelected: _researchIds,
                    min: 0,
                    max: 8,
                  ),
                ),
                _SectionCard(
                  icon: Icons.tune_outlined,
                  title: 'Preferencias de match',
                  emptyHint: 'Con quién prefieres conectar',
                  impactLabel: null,
                  isFilled: _genderPreference != 'any',
                  previewItems: _genderPreference == 'any'
                      ? []
                      : [_genderLabel(_genderPreference)],
                  overflow: 0,
                  onTap: _openGenderPrefSheet,
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.space10)),
        ],
      ),
    );
  }

  static String _label(String id) => id
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
      .join(' ');

  static String _genderLabel(String pref) => switch (pref) {
    'F' => 'Mujeres',
    'M' => 'Hombres',
    _ => 'Todos',
  };
}

// ── Profile header ────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.hue,
    required this.photoUrl,
    required this.completionScore,
    required this.insight,
  });

  final String firstName;
  final String lastName;
  final String username;
  final double hue;
  final String? photoUrl;
  final double completionScore;
  final String insight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final displayName = [
      firstName,
      lastName,
    ].where((s) => s.isNotEmpty).join(' ');
    final initials = displayName.isNotEmpty
        ? displayName
              .split(' ')
              .where((w) => w.isNotEmpty)
              .map((w) => w[0].toUpperCase())
              .take(2)
              .join()
        : '?';
    final pct = (completionScore * 100).round();

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space5,
        AppSpacing.space5,
        AppSpacing.space5,
        AppSpacing.space4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TAvatar(
                initials: initials,
                hue: hue,
                photoUrl: photoUrl,
                size: 56,
              ),
              const SizedBox(width: AppSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName.isNotEmpty ? displayName : 'Tu nombre',
                      style: AppTextStyles.titleMd(cs.onSurface),
                    ),
                    if (username.isNotEmpty)
                      Text(
                        '@$username',
                        style: AppTextStyles.bodySm(cs.primary),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.space4),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          value: completionScore,
                          strokeWidth: 5,
                          backgroundColor: cs.surfaceContainerHigh,
                          valueColor: AlwaysStoppedAnimation(cs.primary),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        '$pct%',
                        style: AppTextStyles.titleMd(
                          cs.onSurface,
                        ).copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    'completado',
                    style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space4,
              vertical: AppSpacing.space3,
            ),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: cs.onPrimaryContainer,
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: Text(
                    insight,
                    style: AppTextStyles.bodySm(cs.onPrimaryContainer),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Group label ───────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space5,
        AppSpacing.space5,
        AppSpacing.space5,
        AppSpacing.space3,
      ),
      child: Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
    );
  }
}

// ── Section card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.emptyHint,
    required this.impactLabel,
    required this.isFilled,
    required this.previewItems,
    required this.overflow,
    required this.onTap,
    this.previewText,
  });

  final IconData icon;
  final String title;
  final String emptyHint;
  final String? impactLabel;
  final bool isFilled;
  final List<String> previewItems;
  final int overflow;
  final String? previewText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.space3),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: isFilled ? _buildFilled(cs) : _buildEmpty(cs),
      ),
    );
  }

  Widget _buildEmpty(ColorScheme cs) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconBox(icon: icon, active: false, cs: cs),
        const SizedBox(width: AppSpacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.titleMd(cs.onSurface),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space3,
                      vertical: AppSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.primary),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      'Completar',
                      style: AppTextStyles.labelSm(cs.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space2),
              Text(emptyHint, style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
              if (impactLabel != null) ...[
                const SizedBox(height: AppSpacing.space3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space3,
                    vertical: AppSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    impactLabel!,
                    style: AppTextStyles.labelSm(cs.primary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilled(ColorScheme cs) {
    const iconWidth = 44.0;
    final hasPreview =
        previewText != null || previewItems.isNotEmpty || overflow > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IconBox(icon: icon, active: true, cs: cs),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Text(title, style: AppTextStyles.titleMd(cs.onSurface)),
            ),
            Text('Editar', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
            const SizedBox(width: AppSpacing.space1),
            Icon(Icons.chevron_right, size: 16, color: cs.onSurfaceVariant),
          ],
        ),
        if (hasPreview) ...[
          const SizedBox(height: AppSpacing.space2),
          Padding(
            padding: const EdgeInsets.only(left: iconWidth + AppSpacing.space3),
            child: previewText != null
                ? Text(
                    previewText!,
                    style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : Wrap(
                    spacing: AppSpacing.space2,
                    runSpacing: AppSpacing.space2,
                    children: [
                      ...previewItems.map(
                        (l) => _PreviewChip(label: l, cs: cs),
                      ),
                      if (overflow > 0)
                        _PreviewChip(label: '+$overflow', cs: cs),
                    ],
                  ),
          ),
        ],
      ],
    );
  }
}

// ── Small widgets ─────────────────────────────────────────────────────────────

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.active, required this.cs});
  final IconData icon;
  final bool active;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: active
          ? cs.primary.withValues(alpha: 0.12)
          : cs.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
    alignment: Alignment.center,
    child: Icon(
      icon,
      size: 22,
      color: active ? cs.primary : cs.onSurfaceVariant,
    ),
  );
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({required this.label, required this.cs});
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.space3,
      vertical: AppSpacing.space1,
    ),
    decoration: BoxDecoration(
      color: cs.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppRadius.pill),
    ),
    child: Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
  );
}

// ── Bottom sheets ─────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: AppSpacing.space5),
        decoration: BoxDecoration(
          color: cs.onSurfaceVariant.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SheetContainer extends StatelessWidget {
  const _SheetContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.space5,
        AppSpacing.space4,
        AppSpacing.space5,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.space6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const _SheetHandle(), child],
      ),
    );
  }
}

// Bio sheet

class _BioSheet extends StatelessWidget {
  const _BioSheet({required this.controller, required this.onSave});
  final TextEditingController controller;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _SheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bio', style: AppTextStyles.titleMd(cs.onSurface)),
          const SizedBox(height: AppSpacing.space4),
          TTextField(
            controller: controller,
            label: '',
            hint: 'Preséntate en unas líneas (máx. 280 caracteres)',
            maxLines: 5,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: AppSpacing.space5),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onSave, child: const Text('Listo')),
          ),
        ],
      ),
    );
  }
}

// Semester sheet

class _SemesterSheet extends StatelessWidget {
  const _SemesterSheet({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _SheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Semestre', style: AppTextStyles.titleMd(cs.onSurface)),
          const SizedBox(height: AppSpacing.space4),
          Wrap(
            spacing: AppSpacing.space2,
            runSpacing: AppSpacing.space2,
            children: List.generate(12, (i) {
              final s = i + 1;
              return TChip(
                label: 'Sem. $s',
                selected: value == s,
                onTap: () => onChanged(s),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Modality sheet

class _ModalitySheet extends StatefulWidget {
  const _ModalitySheet({required this.selected, required this.onSave});
  final Set<String> selected;
  final ValueChanged<Set<String>> onSave;

  @override
  State<_ModalitySheet> createState() => _ModalitySheetState();
}

class _ModalitySheetState extends State<_ModalitySheet> {
  late Set<String> _current;

  @override
  void initState() {
    super.initState();
    _current = Set.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _SheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Modalidad', style: AppTextStyles.titleMd(cs.onSurface)),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Puedes seleccionar más de una opción',
            style: AppTextStyles.bodySm(cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space4),
          Wrap(
            spacing: AppSpacing.space2,
            runSpacing: AppSpacing.space2,
            children: Modality.all.map((m) {
              final sel = _current.contains(m.type.name);
              return TChip(
                label: m.label,
                selected: sel,
                onTap: () => setState(() {
                  if (sel) {
                    _current.remove(m.type.name);
                  } else {
                    _current.add(m.type.name);
                  }
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.space5),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => widget.onSave(_current),
              child: const Text('Listo'),
            ),
          ),
        ],
      ),
    );
  }
}

// Gender preference sheet

class _GenderPrefSheet extends StatelessWidget {
  const _GenderPrefSheet({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  static const _options = [
    ('any', 'Todos'),
    ('F', 'Mujeres'),
    ('M', 'Hombres'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _SheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prefiero conectar con',
            style: AppTextStyles.titleMd(cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.space4),
          Wrap(
            spacing: AppSpacing.space2,
            children: _options
                .map(
                  (opt) => TChip(
                    label: opt.$2,
                    selected: value == opt.$1,
                    onTap: () => onChanged(opt.$1),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Availability picker page ──────────────────────────────────────────────────

class _AvailabilityPickerPage extends StatefulWidget {
  const _AvailabilityPickerPage({required this.selected});
  final Set<String> selected;

  @override
  State<_AvailabilityPickerPage> createState() =>
      _AvailabilityPickerPageState();
}

class _AvailabilityPickerPageState extends State<_AvailabilityPickerPage> {
  late Set<String> _current;

  static const _days = [
    ('mon', 'Lun'),
    ('tue', 'Mar'),
    ('wed', 'Mié'),
    ('thu', 'Jue'),
    ('fri', 'Vie'),
    ('sat', 'Sáb'),
    ('sun', 'Dom'),
  ];
  static const _slots = [('am', 'Mañana'), ('pm', 'Tarde'), ('night', 'Noche')];

  @override
  void initState() {
    super.initState();
    _current = Set.from(widget.selected);
  }

  void _toggle(String id) => setState(() {
    if (_current.contains(id)) {
      _current.remove(id);
    } else {
      _current.add(id);
    }
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: TAppBar(
        title: 'Disponibilidad',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_current),
            child: const Text('Listo'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona cuándo estás disponible',
              style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.space5),
            // Header row
            Row(
              children: [
                const SizedBox(width: 44),
                ..._slots.map(
                  (slot) => Expanded(
                    child: Text(
                      slot.$2,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space3),
            // Day rows
            ..._days.map(
              (day) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      child: Text(
                        day.$2,
                        style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                      ),
                    ),
                    ..._slots.map((slot) {
                      final id = '${day.$1}_${slot.$1}';
                      final sel = _current.contains(id);
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _toggle(id),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 44,
                            decoration: BoxDecoration(
                              color: sel
                                  ? cs.primary.withValues(alpha: 0.15)
                                  : cs.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              border: Border.all(
                                color: sel ? cs.primary : cs.outlineVariant,
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Catalog picker page ────────────────────────────────────────────────────────

class _PickerResult {
  const _PickerResult({required this.selected, this.sportFrequencies});
  final Set<String> selected;
  final Map<String, SportFrequency>? sportFrequencies;
}

class _SelectionPickerPage extends StatefulWidget {
  const _SelectionPickerPage({
    required this.title,
    required this.catalogName,
    required this.variant,
    required this.initialSelected,
    required this.careerId,
    required this.campusId,
    required this.activeBuckets,
    required this.currentGoals,
    required this.min,
    required this.max,
    required this.sportFrequencies,
  });

  final String title;
  final String catalogName;
  final SelectionVariant variant;
  final Set<String> initialSelected;
  final String? careerId;
  final String? campusId;
  final List<ModalityBucketId> activeBuckets;
  final Set<String> currentGoals;
  final int min;
  final int max;
  final Map<String, SportFrequency> sportFrequencies;

  @override
  State<_SelectionPickerPage> createState() => _SelectionPickerPageState();
}

class _SelectionPickerPageState extends State<_SelectionPickerPage> {
  late Set<String> _current;
  late Map<String, SportFrequency> _frequencies;

  @override
  void initState() {
    super.initState();
    _current = Set.from(widget.initialSelected);
    _frequencies = Map.from(widget.sportFrequencies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: widget.title,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(
              _PickerResult(
                selected: _current,
                sportFrequencies: widget.catalogName == 'sport'
                    ? _frequencies
                    : null,
              ),
            ),
            child: const Text('Listo'),
          ),
        ],
      ),
      body: SelectionExperience(
        catalogName: widget.catalogName,
        variant: widget.variant,
        initialSelected: _current,
        onChanged: (s) => _current = s,
        careerId: widget.careerId,
        campusId: widget.campusId,
        activeBuckets: widget.activeBuckets,
        currentGoals: widget.currentGoals,
        min: widget.min,
        max: widget.max,
        sportFrequencies: _frequencies,
        onSportFrequencyChanged: (sportId, freq) =>
            setState(() => _frequencies[sportId] = freq),
      ),
    );
  }
}
