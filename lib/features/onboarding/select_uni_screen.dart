import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/skeleton_loader.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';
import '../../data/models/catalog/campus_info.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/onboarding_draft_repository.dart';

class SelectUniScreen extends StatefulWidget {
  const SelectUniScreen({super.key});

  @override
  State<SelectUniScreen> createState() => _SelectUniScreenState();
}

class _SelectUniScreenState extends State<SelectUniScreen> {
  List<CampusInfo>? _campuses;
  CampusInfo? _selected;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final campuses = await BundledCatalogRepository.instance.activeCampuses();
      final draft = await OnboardingDraftRepository.instance.load();
      if (!mounted) return;
      setState(() {
        _campuses = campuses;
        if (draft.universityId != null && draft.universityId!.isNotEmpty) {
          _selected = campuses
              .where((c) => c.id == draft.universityId)
              .firstOrNull;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<void> _continue() async {
    final draft = await OnboardingDraftRepository.instance.load();
    draft
      ..universityId = _selected!.id
      ..lastCompletedStep = 'university';
    await OnboardingDraftRepository.instance.save(draft);
    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRouter.verifyEmail);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(cs),
            Expanded(child: _buildBody(cs)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: TButton(
                label: 'Continuar',
                onPressed: _selected == null ? null : _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ColorScheme cs) {
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
    if (_campuses == null) return const SkeletonLoader();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space5),
      children: _campuses!
          .map(
            (c) => _CampusCard(
              campus: c,
              isSelected: _selected == c,
              onTap: () => setState(() => _selected = c),
            ),
          )
          .toList(),
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
            const StepDots(totalSteps: 8, currentStep: 1),
          ],
        ),
        const SizedBox(height: AppSpacing.space5),
        Text('Tu universidad', style: AppTextStyles.headlineSm(cs.onSurface)),
        const SizedBox(height: AppSpacing.space2),
        Text(
          'Selecciona tu campus Anáhuac',
          style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
        ),
      ],
    ),
  );
}

class _CampusCard extends StatelessWidget {
  const _CampusCard({
    required this.campus,
    required this.isSelected,
    required this.onTap,
  });

  final CampusInfo campus;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.space3),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.12)
                    : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.school_outlined,
                size: 22,
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          campus.name,
                          style: AppTextStyles.titleMd(cs.onSurface),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    campus.location,
                    style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check, color: cs.primary),
          ],
        ),
      ),
    );
  }
}
