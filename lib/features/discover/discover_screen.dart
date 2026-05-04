import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/feed_card.dart';
import '../../core/widgets/modality_switch.dart';
import '../../core/widgets/segmented_control.dart';
import '../../core/widgets/t_bottom_nav.dart';
import '../../core/widgets/trama_mark.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/modality.dart';
import '../../data/models/student.dart';
import '../connections/connections_screen.dart';
import '../chat/chat_list_screen.dart';
import '../profile/my_profile_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _navIndex = 0;
  int _tabIndex = 0;
  ModalityType _modality = ModalityType.estudio;
  final Set<String> _saved = {};

  static const _tabLabels = ['Feed', 'Cuadrícula', 'Historias'];

  final _screens = [
    null,
    const ConnectionsScreen(embedded: true),
    const ChatListScreen(embedded: true),
    const MyProfileScreen(embedded: true),
  ];

  List<Student> get _filteredStudents {
    return MockData.students.where((s) => s.intent == _modality).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_navIndex != 0) {
      return Scaffold(
        body: _screens[_navIndex]!,
        bottomNavigationBar: TBottomNav(currentIndex: _navIndex, onTap: _onNav),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: true,
            snap: true,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
              child: Row(
                children: [
                  const TramaMark(size: 36),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: SegmentedControl(
                      segments: _tabLabels,
                      selectedIndex: _tabIndex,
                      onChanged: (i) => setState(() => _tabIndex = i),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space3),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () => Navigator.of(context).pushNamed(AppRouter.notifications),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                child: ModalitySwitch(
                  selected: _modality,
                  onChanged: (m) => setState(() => _modality = m),
                ),
              ),
            ),
          ),
        ],
        body: _buildBody(),
      ),
      bottomNavigationBar: TBottomNav(currentIndex: _navIndex, onTap: _onNav),
    );
  }

  void _onNav(int i) => setState(() => _navIndex = i);

  Widget _buildBody() {
    return switch (_tabIndex) {
      0 => _FeedView(
          students: _filteredStudents,
          saved: _saved,
          onTap: (s) => Navigator.of(context).pushNamed(AppRouter.profileDetail, arguments: s),
          onSave: (id) => setState(() {
            if (_saved.contains(id)) {
              _saved.remove(id);
            } else {
              _saved.add(id);
            }
          }),
        ),
      1 => _GridView(
          students: _filteredStudents,
          onTap: (s) => Navigator.of(context).pushNamed(AppRouter.profileDetail, arguments: s),
        ),
      2 => _StoriesView(students: _filteredStudents),
      _ => const SizedBox.shrink(),
    };
  }
}

class _FeedView extends StatelessWidget {
  const _FeedView({
    required this.students,
    required this.saved,
    required this.onTap,
    required this.onSave,
  });

  final List<Student> students;
  final Set<String> saved;
  final ValueChanged<Student> onTap;
  final ValueChanged<String> onSave;

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return _EmptyState();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.space4, AppSpacing.space4, AppSpacing.space4, 120),
      itemCount: students.length,
      separatorBuilder: (context, idx) => const SizedBox(height: AppSpacing.space4),
      itemBuilder: (context, i) {
        final s = students[i];
        return FeedCard(
          student: s,
          onTap: () => onTap(s),
          onSave: () => onSave(s.id),
          isSaved: saved.contains(s.id),
        );
      },
    );
  }
}

class _GridView extends StatelessWidget {
  const _GridView({required this.students, required this.onTap});
  final List<Student> students;
  final ValueChanged<Student> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (students.isEmpty) return _EmptyState();
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(AppSpacing.space4, AppSpacing.space4, AppSpacing.space4, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.space3,
        crossAxisSpacing: AppSpacing.space3,
        childAspectRatio: 0.72,
      ),
      itemCount: students.length,
      itemBuilder: (context, i) {
        final s = students[i];
        return GestureDetector(
          onTap: () => onTap(s),
          child: Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          HSLColor.fromAHSL(1.0, s.hue, 0.45, 0.72).toColor(),
                          HSLColor.fromAHSL(1.0, (s.hue + 30) % 360, 0.55, 0.42).toColor(),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
                    ),
                    alignment: Alignment.center,
                    child: Text(s.initials, style: AppTextStyles.headlineLg(Colors.white.withValues(alpha: 0.9))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.space3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.firstName, style: AppTextStyles.titleMd(cs.onSurface)),
                      Text('${s.program} · ${s.semester}°', style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StoriesView extends StatelessWidget {
  const _StoriesView({required this.students});
  final List<Student> students;

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return _EmptyState();
    return PageView.builder(
      itemCount: students.length,
      itemBuilder: (context, i) {
        final s = students[i];
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      HSLColor.fromAHSL(1.0, s.hue, 0.45, 0.72).toColor(),
                      HSLColor.fromAHSL(1.0, (s.hue + 30) % 360, 0.55, 0.42).toColor(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: AppSpacing.space6,
              right: AppSpacing.space6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${s.name}, ${s.age}', style: AppTextStyles.headlineMd(Colors.white)),
                  Text('${s.program} · Sem. ${s.semester}', style: AppTextStyles.bodyLg(Colors.white70)),
                  const SizedBox(height: AppSpacing.space3),
                  if (s.bio.isNotEmpty)
                    Text('"${s.bio}"', style: AppTextStyles.bodyMd(Colors.white70).copyWith(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(students.length, (j) => Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: j <= i ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.explore_outlined, size: 64, color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
          const SizedBox(height: AppSpacing.space4),
          Text('Sin resultados', style: AppTextStyles.headlineSm(cs.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.space2),
          Text('Prueba con otra modalidad', style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
