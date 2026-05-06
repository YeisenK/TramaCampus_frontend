import 'dart:convert';

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
    GroupAccess.request => 'Solicitar acceso',
    GroupAccess.invite => 'Privado',
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
    this.temporary = false,
    this.expiresAt,
    this.members = const [],
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
  final bool temporary;
  final DateTime? expiresAt;

  /// Visible / known member student IDs. May be a subset of memberCount
  /// (the rest are anonymous from the demo's perspective).
  final List<String> members;

  bool get isDiscoverable => access != GroupAccess.invite;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tagline': tagline,
    'kind': kind.name,
    'access': access.name,
    'verified': verified,
    'featured': featured,
    'hue': hue,
    'memberCount': memberCount,
    'capacity': capacity,
    'activity': activity,
    'nextAction': nextAction,
    'leader': leader,
    'description': description,
    'temporary': temporary,
    'expiresAt': expiresAt?.toIso8601String(),
    'members': members,
  };

  String toJsonString() => jsonEncode(toJson());

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json['id'] as String,
    name: json['name'] as String,
    tagline: json['tagline'] as String,
    kind: GroupKind.values.byName(json['kind'] as String),
    access: GroupAccess.values.byName(json['access'] as String),
    verified: json['verified'] as bool,
    featured: json['featured'] as bool,
    hue: (json['hue'] as num).toDouble(),
    memberCount: json['memberCount'] as int,
    capacity: json['capacity'] as int?,
    activity: json['activity'] as String,
    nextAction: json['nextAction'] as String,
    leader: json['leader'] as String,
    description: json['description'] as String,
    temporary: json['temporary'] as bool? ?? false,
    expiresAt: json['expiresAt'] != null
        ? DateTime.parse(json['expiresAt'] as String)
        : null,
    members: (json['members'] as List?)?.cast<String>() ?? const [],
  );

  factory Group.fromJsonString(String s) =>
      Group.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
