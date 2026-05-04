import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/modality_switch.dart';
import '../../core/widgets/t_bottom_nav.dart';
import '../../core/widgets/trama_mark.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/modality.dart';
import '../../data/models/student.dart';
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
            modality: _modality,
            saved: _saved,
            onModalityChanged: (m) => setState(() {
              _modality = m;
              _filteredStudents = _filterStudents(m);
            }),
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
          ),
          const ConnectionsScreen(embedded: true),
          const MarketplaceScreen(embedded: true),
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
    required this.modality,
    required this.saved,
    required this.onModalityChanged,
    required this.onStudentTap,
    required this.onSaveToggle,
    required this.onNotificationsTap,
    required this.filteredStudents,
  });

  final ModalityType modality;
  final Set<String> saved;
  final ValueChanged<ModalityType> onModalityChanged;
  final ValueChanged<Student> onStudentTap;
  final ValueChanged<String> onSaveToggle;
  final VoidCallback onNotificationsTap;
  final List<Student> filteredStudents;

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
            preferredSize: const Size.fromHeight(52),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.space2),
              child: ModalitySwitch(
                selected: modality,
                onChanged: onModalityChanged,
              ),
            ),
          ),
        ),
      ],
      body: DiscoverFeedView(
        students: filteredStudents,
        saved: saved,
        onTap: onStudentTap,
        onSave: onSaveToggle,
      ),
    );
  }
}
