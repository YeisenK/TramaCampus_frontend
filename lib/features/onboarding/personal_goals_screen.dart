import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/skeleton_loader.dart';
import '../../core/widgets/selection/selection_experience.dart';
import '../../data/models/modality_bucket.dart';
import '../../data/repositories/onboarding_draft_repository.dart';
import '_selection_step_scaffold.dart';

class PersonalGoalsScreen extends StatefulWidget {
  const PersonalGoalsScreen({super.key});

  @override
  State<PersonalGoalsScreen> createState() => _PersonalGoalsScreenState();
}

class _PersonalGoalsScreenState extends State<PersonalGoalsScreen> {
  Set<String> _goals = {};
  String? _campusId;
  List<ModalityBucketId> _buckets = [];
  bool _draftLoaded = false;
  Object? _draftError;

  static const _min = 1;
  static const _max = 15;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    try {
      final draft = await OnboardingDraftRepository.instance.load();
      if (!mounted) return;
      setState(() {
        _goals = (draft.goals ?? []).toSet();
        _campusId = draft.universityId;
        _buckets = _resolveBuckets(draft.uiModality);
        _draftLoaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _draftError = e);
    }
  }

  List<ModalityBucketId> _resolveBuckets(String? uiModality) {
    if (uiModality == null) return [];
    return ModalityBucketId.values
        .where((b) => uiModality.contains(b.name))
        .toList();
  }

  Future<void> _continue() async {
    final draft = await OnboardingDraftRepository.instance.load();
    draft
      ..goals = _goals.toList()
      ..lastCompletedStep = 'goals';
    await OnboardingDraftRepository.instance.save(draft);
    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRouter.skillsSelect);
  }

  @override
  Widget build(BuildContext context) {
    if (_draftError != null) {
      return Scaffold(
        body: ErrorState(
          message: 'Error cargando perfil.',
          onRetry: () {
            setState(() => _draftError = null);
            _loadDraft();
          },
        ),
      );
    }
    if (!_draftLoaded) return const Scaffold(body: SkeletonLoader());

    return SelectionStepScaffold(
      step: 6,
      title: 'Objetivos en Trama',
      subtitle: '¿Qué esperas encontrar?',
      canContinue: _goals.length >= _min,
      onContinue: _continue,
      selection: SelectionExperience(
        catalogName: 'goal',
        variant: SelectionVariant.chipCloud,
        initialSelected: _goals,
        onChanged: (s) => setState(() => _goals = s),
        campusId: _campusId,
        activeBuckets: _buckets,
        min: _min,
        max: _max,
      ),
    );
  }
}
