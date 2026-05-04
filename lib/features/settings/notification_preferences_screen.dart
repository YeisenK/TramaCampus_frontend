import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/toggle_tile.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _newMatches = true;
  bool _matchRequests = true;
  bool _messages = true;
  bool _groupInvites = false;
  bool _studyReminders = true;
  bool _weeklyDigest = false;
  bool _pushEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(title: 'Notificaciones'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space6),
        children: [
          SectionCard(
            title: 'General',
            children: [
              ToggleTile(
                icon: Icons.notifications_outlined,
                label: 'Notificaciones push',
                subtitle: 'Activar o desactivar todas',
                value: _pushEnabled,
                onChanged: (v) => setState(() => _pushEnabled = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Actividad',
            children: [
              ToggleTile(
                icon: Icons.favorite_outline,
                label: 'Nuevos matches',
                value: _newMatches && _pushEnabled,
                onChanged: _pushEnabled
                    ? (v) => setState(() => _newMatches = v)
                    : null,
              ),
              ToggleTile(
                icon: Icons.person_add_outlined,
                label: 'Solicitudes de conexión',
                value: _matchRequests && _pushEnabled,
                onChanged: _pushEnabled
                    ? (v) => setState(() => _matchRequests = v)
                    : null,
              ),
              ToggleTile(
                icon: Icons.chat_bubble_outline,
                label: 'Mensajes nuevos',
                value: _messages && _pushEnabled,
                onChanged: _pushEnabled
                    ? (v) => setState(() => _messages = v)
                    : null,
              ),
              ToggleTile(
                icon: Icons.group_outlined,
                label: 'Invitaciones a grupos',
                value: _groupInvites && _pushEnabled,
                onChanged: _pushEnabled
                    ? (v) => setState(() => _groupInvites = v)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Recordatorios',
            children: [
              ToggleTile(
                icon: Icons.menu_book_outlined,
                label: 'Recordatorios de estudio',
                subtitle: 'Cuando tienes sesiones pendientes',
                value: _studyReminders && _pushEnabled,
                onChanged: _pushEnabled
                    ? (v) => setState(() => _studyReminders = v)
                    : null,
              ),
              ToggleTile(
                icon: Icons.email_outlined,
                label: 'Resumen semanal',
                subtitle: 'Resumen de actividad por correo',
                value: _weeklyDigest,
                onChanged: (v) => setState(() => _weeklyDigest = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
