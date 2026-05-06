enum GroupKind { project, study, club, sport, official }

enum GroupAccess { open, request, invite }

extension GroupKindLabel on GroupKind {
  String get label => switch (this) {
        GroupKind.project => 'Proyecto',
        GroupKind.study => 'Estudio',
        GroupKind.club => 'Club',
        GroupKind.sport => 'Deporte',
        GroupKind.official => 'Oficial',
      };
}

extension GroupAccessLabel on GroupAccess {
  String get label => switch (this) {
        GroupAccess.open => 'Abierto',
        GroupAccess.request => 'Con solicitud',
        GroupAccess.invite => 'Solo invitación',
      };
}

class Group {
  const Group({
    required this.id,
    required this.name,
    required this.tagline,
    required this.kind,
    required this.access,
    required this.verified,
    required this.featured,
    required this.hue,
    required this.memberCount,
    required this.activity,
    required this.nextAction,
    required this.leader,
    required this.description,
    this.capacity,
  });

  final String id;
  final String name;
  final String tagline;
  final GroupKind kind;
  final GroupAccess access;
  final bool verified;
  final bool featured;
  final double hue;
  final int memberCount;
  final int? capacity;
  final String activity;
  final String nextAction;
  final String leader;
  final String description;
}
