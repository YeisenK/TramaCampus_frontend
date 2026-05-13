import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/modality_switch.dart';
import '../../core/widgets/t_bottom_nav.dart';
import '../../core/widgets/trama_mark.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/modality.dart';
import '../../data/models/modality_bucket.dart';
import '../../data/models/recommended_student.dart';
import '../../data/models/student.dart';
import '../../data/repositories/api_matching_repository.dart';
import '../../data/repositories/app_state_repository.dart';
import '../../data/services/api/recommended_to_student.dart';
import '../chat/chat_list_screen.dart';
import '../connections/connections_screen.dart';
import '../marketplace/marketplace_screen.dart';
import '../profile/my_profile_screen.dart';
import 'views/feed_view.dart';

// Demo runs against the API by default. Kill-switch:
// --dart-define=TRAMA_USE_API_MATCHING=false to force-mock for offline dev.
const bool kUseApiMatching = bool.fromEnvironment(
  'TRAMA_USE_API_MATCHING',
  defaultValue: true,
);

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _navIndex = 0;
  // Tracks which tabs have been built at least once — lazy init pattern.
  final Set<int> _builtTabs = {0};
  ModalityType _modality = ModalityType.estudio;
  FeedFilter _feedFilter = FeedFilter.all;
  final Set<String> _saved = {};

  late List<Student> _filteredStudents;

  ApiMatchingRepository? _apiRepo;
  MatchResultsDto? _apiMatches;
  bool _apiLoading = false;
  String? _apiError;

  @override
  void initState() {
    super.initState();
    _filteredStudents = _filterStudents(_modality);
    if (kUseApiMatching) {
      _apiRepo = ApiMatchingRepository();
      _refreshFromApi();
      AppStateRepository.instance.addListener(_onProfileChanged);
    }
  }

  @override
  void dispose() {
    if (kUseApiMatching) {
      AppStateRepository.instance.removeListener(_onProfileChanged);
    }
    super.dispose();
  }

  Future<void> _refreshFromApi() async {
    final repo = _apiRepo;
    if (repo == null) return;
    setState(() {
      _apiLoading = true;
      _apiError = null;
    });
    try {
      final results = await repo.refresh(AppStateRepository.instance.profile);
      if (!mounted) return;
      setState(() {
        _apiMatches = results;
        _filteredStudents = _filterStudents(_modality);
        _apiLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _apiError = e.toString();
        _apiLoading = false;
      });
    }
  }

  void _onProfileChanged() {
    if (!mounted) return;
    _refreshFromApi();
  }

  List<Student> _filterStudents(ModalityType m) {
    if (kUseApiMatching && _apiMatches != null) {
      final bucketModes = ModalityBucket.fromId(m).defaultModes.toSet();
      return _apiMatches!.topGeneral
          .where((r) => r.modalities.any(bucketModes.contains))
          .map((r) => recommendedToStudent(r, m))
          .toList();
    }
    return MockData.students.where((s) => s.intent == m).toList();
  }

  void _onNav(int i) => setState(() {
    _navIndex = i;
    _builtTabs.add(i);
  });

  Widget _lazyTab(int index, Widget child) =>
      _builtTabs.contains(index) ? child : const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _navIndex,
        children: [
          _DiscoverShell(
            modality: _modality,
            saved: _saved,
            feedFilter: _feedFilter,
            onModalityChanged: (m) => setState(() {
              _modality = m;
              _filteredStudents = _filterStudents(m);
            }),
            onFeedFilterChanged: (f) => setState(() => _feedFilter = f),
            onStudentTap: (s) => Navigator.of(
              context,
            ).pushNamed(AppRouter.profileDetail, arguments: s),
            onSaveToggle: (id) => setState(() {
              if (_saved.contains(id)) {
                _saved.remove(id);
              } else {
                _saved.add(id);
              }
            }),
            onNotificationsTap: () =>
                Navigator.of(context).pushNamed(AppRouter.notifications),
            filteredStudents: _filteredStudents,
            apiBanner: kUseApiMatching
                ? _ApiStatusBanner(
                    loading: _apiLoading,
                    error: _apiError,
                    coldStart: _apiMatches?.coldStart ?? false,
                    onRetry: _refreshFromApi,
                  )
                : null,
          ),
          _lazyTab(1, const ConnectionsScreen(embedded: true)),
          _lazyTab(2, const MarketplaceScreen(embedded: true)),
          _lazyTab(3, const ChatListScreen(embedded: true)),
          _lazyTab(4, const MyProfileScreen(embedded: true)),
        ],
      ),
      bottomNavigationBar: TBottomNav(currentIndex: _navIndex, onTap: _onNav),
    );
  }
}

class _DiscoverShell extends StatelessWidget {
  const _DiscoverShell({
    required this.modality,
    required this.saved,
    required this.feedFilter,
    required this.onModalityChanged,
    required this.onFeedFilterChanged,
    required this.onStudentTap,
    required this.onSaveToggle,
    required this.onNotificationsTap,
    required this.filteredStudents,
    this.apiBanner,
  });

  final ModalityType modality;
  final Set<String> saved;
  final FeedFilter feedFilter;
  final ValueChanged<ModalityType> onModalityChanged;
  final ValueChanged<FeedFilter> onFeedFilterChanged;
  final ValueChanged<Student> onStudentTap;
  final ValueChanged<String> onSaveToggle;
  final VoidCallback onNotificationsTap;
  final List<Student> filteredStudents;
  final Widget? apiBanner;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          pinned: true,
          floating: true,
          forceElevated: innerBoxIsScrolled,
          title: const TramaMark(size: 32),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: onNotificationsTap,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(AppSpacing.space9),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.space3),
              child: ModalitySwitch(
                selected: modality,
                onChanged: onModalityChanged,
              ),
            ),
          ),
        ),
        if (apiBanner != null) SliverToBoxAdapter(child: apiBanner!),
      ],
      body: DiscoverFeedView(
        students: filteredStudents,
        saved: saved,
        onTap: onStudentTap,
        onSave: onSaveToggle,
        filter: feedFilter,
        onFilterChanged: onFeedFilterChanged,
      ),
    );
  }
}

class _ApiStatusBanner extends StatelessWidget {
  const _ApiStatusBanner({
    required this.loading,
    required this.error,
    required this.coldStart,
    required this.onRetry,
  });

  final bool loading;
  final String? error;
  final bool coldStart;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (loading) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space5,
          vertical: AppSpacing.space2,
        ),
        color: cs.primaryContainer.withValues(alpha: 0.4),
        child: Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Text(
              'Buscando matches con la API…',
              style: TextStyle(color: cs.onPrimaryContainer, fontSize: 12),
            ),
          ],
        ),
      );
    }
    if (error != null) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space5,
          vertical: AppSpacing.space2,
        ),
        color: cs.errorContainer.withValues(alpha: 0.6),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: 16, color: cs.onErrorContainer),
            const SizedBox(width: AppSpacing.space2),
            Expanded(
              child: Text(
                'No se pudo contactar la API de matching',
                style: TextStyle(color: cs.onErrorContainer, fontSize: 12),
              ),
            ),
            TextButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    if (coldStart) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space5,
          vertical: AppSpacing.space1,
        ),
        color: cs.surfaceContainerHigh,
        child: Text(
          'Cold start: aún no hay interacciones, mostramos exploración amplia.',
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
