import 'package:flutter/material.dart';

import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/modality_switch.dart';
import '../../core/widgets/t_bottom_nav.dart';
import '../../core/widgets/trama_mark.dart';
import '../../data/models/mock_person.dart';
import '../../data/models/modality.dart';
import '../../data/models/student.dart';
import '../../data/repositories/app_state_repository.dart';
import '../../data/repositories/mock_people_repository.dart';
import '../../data/services/local_match_to_student.dart';
import '../../data/services/local_matching_engine.dart';
import '../chat/chat_list_screen.dart';
import '../connections/connections_screen.dart';
import '../marketplace/marketplace_screen.dart';
import '../profile/my_profile_screen.dart';
import 'views/feed_view.dart';

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

  static const LocalMatchingEngine _engine = LocalMatchingEngine();

  List<MockPerson> _pool = const [];
  List<LocalMatch> _allMatches = const [];
  List<Student> _filteredStudents = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
    AppStateRepository.instance.addListener(_onProfileChanged);
  }

  @override
  void dispose() {
    AppStateRepository.instance.removeListener(_onProfileChanged);
    super.dispose();
  }

  Future<void> _bootstrap() async {
    try {
      _pool = await MockPeopleRepository.instance.load();
      _recompute();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudo cargar el dataset de personas';
      });
    }
  }

  void _onProfileChanged() {
    if (!mounted || _pool.isEmpty) return;
    _recompute();
  }

  void _recompute() {
    final state = AppStateRepository.instance;
    final profile = state.profile;
    final age = _ageFrom(profile.base.birthDate);
    final city = state.city ?? 'Oaxaca';
    final matches = _engine.recommend(
      user: profile,
      pool: _pool,
      userAge: age,
      userCity: city,
    );
    if (!mounted) return;
    setState(() {
      _allMatches = matches;
      _filteredStudents = _filterStudents(_modality);
      _loading = false;
      _error = null;
    });
  }

  int _ageFrom(DateTime? bd) {
    if (bd == null) return 21;
    final now = DateTime.now();
    var years = now.year - bd.year;
    if (now.month < bd.month ||
        (now.month == bd.month && now.day < bd.day)) {
      years--;
    }
    return years.clamp(16, 99);
  }

  List<Student> _filterStudents(ModalityType m) {
    final bucket = switch (m) {
      ModalityType.estudio => 'estudio',
      ModalityType.amistad => 'amistad',
      ModalityType.personal => 'personal',
    };
    return _allMatches
        .where((lm) => lm.person.modes
            .any((md) => md.trim().toLowerCase() == bucket))
        .map((lm) => localMatchToStudent(lm, m))
        .toList();
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
            apiBanner: _StatusBanner(
              loading: _loading,
              error: _error,
              emptyMessage: _allMatches.isEmpty && !_loading && _error == null
                  ? 'Sin recomendaciones todavía — completá más tu perfil'
                  : null,
            ),
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

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.loading,
    required this.error,
    required this.emptyMessage,
  });

  final bool loading;
  final String? error;
  final String? emptyMessage;

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
              'Cargando recomendaciones…',
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
                error!,
                style: TextStyle(color: cs.onErrorContainer, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }
    if (emptyMessage != null) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space5,
          vertical: AppSpacing.space1,
        ),
        color: cs.surfaceContainerHigh,
        child: Text(
          emptyMessage!,
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
