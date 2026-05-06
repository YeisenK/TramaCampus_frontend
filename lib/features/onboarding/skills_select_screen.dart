import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/skeleton_loader.dart';
import '../../core/widgets/selection/selection_experience.dart';
import '../../data/models/modality_bucket.dart';
import '../../data/repositories/onboarding_draft_repository.dart';
import '_selection_step_scaffold.dart';

class SkillsSelectScreen extends StatefulWidget {
  const SkillsSelectScreen({super.key});

  @override
  State<SkillsSelectScreen> createState() => _SkillsSelectScreenState();
}

class _SkillsSelectScreenState extends State<SkillsSelectScreen> {
  Set<String> _skills = {};
  Set<String> _goals = {};
  String? _careerId;
  String? _campusId;
  List<ModalityBucketId> _buckets = [];
  bool _draftLoaded = false;
  Object? _draftError;

  static const _min = 3;
  static const _max = 50;

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
        _skills = (draft.skills ?? []).toSet();
        _goals = (draft.goals ?? []).toSet();
        _careerId = draft.careerId;
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
      ..skills = _skills.toList()
      ..lastCompletedStep = 'skills';
    await OnboardingDraftRepository.instance.save(draft);
    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRouter.avatarStep);
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
      step: 7,
      title: 'Habilidades',
      subtitle: 'Muestra en qué eres bueno',
      canContinue: _skills.length >= _min,
      onContinue: _continue,
      selection: SelectionExperience(
        catalogName: 'skill',
        variant: SelectionVariant.bucketed,
        initialSelected: _skills,
        onChanged: (s) => setState(() => _skills = s),
        careerId: _careerId,
        campusId: _campusId,
        activeBuckets: _buckets,
        currentGoals: _goals,
        min: _min,
        max: _max,
      ),
    );
  }
}
