import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/modality_switch.dart';
import '../../core/widgets/segmented_control.dart';
import '../../core/widgets/t_bottom_nav.dart';
import '../../core/widgets/trama_mark.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/modality.dart';
import '../../data/models/student.dart';
import '../chat/chat_list_screen.dart';
import '../connections/connections_screen.dart';
import '../profile/my_profile_screen.dart';
import 'views/feed_view.dart';
import 'views/grid_view.dart';
import 'views/stories_view.dart';

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

  late List<Student> _filteredStudents;

  @override
  void initState() {
    super.initState();
    _filteredStudents = _filterStudents(_modality);
  }

  List<Student> _filterStudents(ModalityType m) =>
      MockData.students.where((s) => s.intent == m).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _navIndex,
        children: [
          _DiscoverShell(
            tabIndex: _tabIndex,
            modality: _modality,
            saved: _saved,
            onTabChanged: (i) => setState(() => _tabIndex = i),
            onModalityChanged: (m) => setState(() {
              _modality = m;
              _filteredStudents = _filterStudents(m);
            }),
            onStudentTap: (s) =>
                Navigator.of(context).pushNamed(AppRouter.profileDetail, arguments: s),
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
          ),
          const ConnectionsScreen(embedded: true),
          const ChatListScreen(embedded: true),
          const MyProfileScreen(embedded: true),
        ],
      ),
      bottomNavigationBar: TBottomNav(currentIndex: _navIndex, onTap: _onNav),
    );
  }

  void _onNav(int i) => setState(() => _navIndex = i);
}

class _DiscoverShell extends StatelessWidget {
  const _DiscoverShell({
    required this.tabIndex,
    required this.modality,
    required this.saved,
    required this.onTabChanged,
    required this.onModalityChanged,
    required this.onStudentTap,
    required this.onSaveToggle,
    required this.onNotificationsTap,
    required this.filteredStudents,
  });

  final int tabIndex;
  final ModalityType modality;
  final Set<String> saved;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<ModalityType> onModalityChanged;
  final ValueChanged<Student> onStudentTap;
  final ValueChanged<String> onSaveToggle;
  final VoidCallback onNotificationsTap;
  final List<Student> filteredStudents;

  static const _tabLabels = ['Feed', 'Cuadrícula', 'Historias'];

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          pinned: true,
          floating: true,
          snap: true,
          forceElevated: innerBoxIsScrolled,
          title: const TramaMark(size: 32),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: onNotificationsTap,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(92),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.space2),
              child: Column(
                children: [
                  ModalitySwitch(selected: modality, onChanged: onModalityChanged),
                  const SizedBox(height: AppSpacing.space2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
                    child: SegmentedControl(
                      segments: _tabLabels,
                      selectedIndex: tabIndex,
                      onChanged: onTabChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: switch (tabIndex) {
          0 => DiscoverFeedView(
              key: const ValueKey(0),
              students: filteredStudents,
              saved: saved,
              onTap: onStudentTap,
              onSave: onSaveToggle,
            ),
          1 => DiscoverGridView(
              key: const ValueKey(1),
              students: filteredStudents,
              onTap: onStudentTap,
            ),
          2 => DiscoverStoriesView(
              key: const ValueKey(2),
              students: filteredStudents,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
