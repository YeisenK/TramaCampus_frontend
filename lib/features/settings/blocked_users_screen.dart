import 'package:flutter/material.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/t_app_bar.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(title: 'Usuarios bloqueados'),
      body: const EmptyState(
        icon: Icons.block_outlined,
        title: 'Sin usuarios bloqueados',
        subtitle: 'Los usuarios que bloquees aparecerán aquí.',
      ),
    );
  }
}
