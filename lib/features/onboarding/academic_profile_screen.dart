import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_chip.dart';
import '../../core/widgets/t_text_field.dart';
import '../../data/models/catalog/catalog.dart';
import '../../data/models/catalog/catalog_item.dart';
import '../../data/models/catalog/catalog_set.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/onboarding_draft_repository.dart';

class AcademicProfileScreen extends StatefulWidget {
  const AcademicProfileScreen({super.key});

  @override
  State<AcademicProfileScreen> createState() => _AcademicProfileScreenState();
}

class _AcademicProfileScreenState extends State<AcademicProfileScreen> {
  Catalog? _catalog;
  Object? _error;
  String? _selectedId;
  int _semester = 1;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final catalog = await BundledCatalogRepository.instance.load('academic');
      final draft = await OnboardingDraftRepository.instance.load();
      if (!mounted) return;
      setState(() {
        _catalog = catalog;
        _selectedId = draft.careerId;
        _semester = draft.semester ?? 1;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<void> _continue() async {
    final draft = await OnboardingDraftRepository.instance.load();
    draft
      ..careerId = _selectedId
      ..semester = _semester
      ..lastCompletedStep = 'academic';
    await OnboardingDraftRepository.instance.save(draft);
    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRouter.skillsSelect);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            Expanded(child: _buildBody()),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: TButton(
                label: 'Continuar',
                onPressed: _selectedId == null ? null : _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: TextButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
          onPressed: () {
            setState(() => _error = null);
            _load();
          },
        ),
      );
    }
    if (_catalog == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final cs = Theme.of(context).colorScheme;
    final searching = _query.trim().isNotEmpty;
    final flatItems = searching
        ? _catalog!.search(_query)
        : <CatalogItem>[];
    final grouped = searching ? null : _catalog!.groupedBySet();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space5),
      children: [
        Text(
          'Semestre',
          style: AppTextStyles.titleMd(cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.space2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_semester de 12',
              style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: cs.primary,
            thumbColor: cs.primary,
            inactiveTrackColor: cs.surfaceContainerHigh,
            overlayColor: cs.primary.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: _semester.toDouble(),
            min: 1,
            max: 12,
            divisions: 11,
            label: 'Semestre $_semester',
            onChanged: (v) => setState(() => _semester = v.round()),
          ),
        ),
        const SizedBox(height: AppSpacing.space4),
        Text(
          'Carrera o programa',
          style: AppTextStyles.titleMd(cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.space2),
        Text(
          'Selecciona tu programa académico actual',
          style: AppTextStyles.bodySm(cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.space3),
        TTextField(
          controller: _searchCtrl,
          label: '',
          hint: 'Buscar carrera…',
          prefixIcon: Icons.search,
        ),
        const SizedBox(height: AppSpacing.space4),
        if (searching)
          _buildFlatChips(flatItems, cs)
        else
          _buildGrouped(grouped!, cs),
      ],
    );
  }

  Widget _buildFlatChips(List<CatalogItem> items, ColorScheme cs) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space5),
        child: Center(
          child: Text(
            'Sin resultados',
            style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
          ),
        ),
      );
    }
    return Wrap(
      spacing: AppSpacing.space2,
      runSpacing: AppSpacing.space2,
      children: items
          .map((item) => TChip(
                label: item.label,
                selected: _selectedId == item.id,
                onTap: () => setState(() => _selectedId =
                    _selectedId == item.id ? null : item.id),
              ))
          .toList(),
    );
  }

  Widget _buildGrouped(
      Map<CatalogSet, List<CatalogItem>> grouped, ColorScheme cs) {
    final entries = grouped.entries
        .where((e) => e.value.isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries.map((entry) {
        final set = entry.key;
        final items = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                set.label,
                style: AppTextStyles.labelSm(
                    Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space2),
              Wrap(
                spacing: AppSpacing.space2,
                runSpacing: AppSpacing.space2,
                children: items
                    .map((item) => TChip(
                          label: item.label,
                          selected: _selectedId == item.id,
                          onTap: () => setState(() => _selectedId =
                              _selectedId == item.id ? null : item.id),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
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
              const StepDots(totalSteps: 7, currentStep: 3),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          Text(
            'Perfil académico',
            style: AppTextStyles.headlineSm(cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Cuéntanos sobre tus estudios',
            style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
