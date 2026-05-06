class Migration {
  const Migration({required this.version, required this.up});

  final int version;
  final List<String> up;
}

const List<Migration> kMigrations = [
  Migration(version: 1, up: [_v1ProfilePhotos, _v1PhotosIndex, _v1Meta]),
  Migration(version: 2, up: [_v2Profile, _v2ProfileDraft, _v2CatalogCache]),
  Migration(
    version: 3,
    up: [
      _v3FollowedGroups,
      _v3MemberGroups,
      _v3UserGroups,
      _v3DirectMessages,
      _v3GroupMessages,
    ],
  ),
];

const String _v1ProfilePhotos = '''
  CREATE TABLE profile_photos (
    id        TEXT    PRIMARY KEY,
    student_id TEXT   NOT NULL,
    bytes     BLOB    NOT NULL,
    mime_type TEXT    NOT NULL,
    width     INTEGER,
    height    INTEGER,
    is_primary INTEGER NOT NULL DEFAULT 0,
    position  INTEGER NOT NULL DEFAULT 0,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
  )
''';

const String _v1PhotosIndex = '''
  CREATE INDEX idx_photos_student
    ON profile_photos(student_id, position)
''';

const String _v1Meta = '''
  CREATE TABLE meta (
    key   TEXT PRIMARY KEY,
    value TEXT NOT NULL
  )
''';

// v2 — profile persistence, onboarding draft, future remote catalog cache.

const String _v2Profile = '''
  CREATE TABLE profile (
    id         INTEGER PRIMARY KEY,
    payload    TEXT    NOT NULL,
    updated_at TEXT    NOT NULL
  )
''';

const String _v2ProfileDraft = '''
  CREATE TABLE profile_draft (
    id         INTEGER PRIMARY KEY,
    step       TEXT    NOT NULL,
    payload    TEXT    NOT NULL,
    updated_at TEXT    NOT NULL
  )
''';

const String _v2CatalogCache = '''
  CREATE TABLE catalog_cache (
    name       TEXT PRIMARY KEY,
    version    TEXT NOT NULL,
    payload    TEXT NOT NULL,
    fetched_at TEXT NOT NULL
  )
''';

// v3 — runtime mutable state: group follow/membership, user-created groups, messages.

const String _v3FollowedGroups = '''
  CREATE TABLE followed_groups (
    group_id    TEXT PRIMARY KEY,
    followed_at TEXT NOT NULL
  )
''';

const String _v3MemberGroups = '''
  CREATE TABLE member_groups (
    group_id  TEXT PRIMARY KEY,
    joined_at TEXT NOT NULL,
    role      TEXT NOT NULL DEFAULT 'member'
  )
''';

const String _v3UserGroups = '''
  CREATE TABLE user_groups (
    id         TEXT PRIMARY KEY,
    payload    TEXT NOT NULL,
    created_at TEXT NOT NULL
  )
''';

const String _v3DirectMessages = '''
  CREATE TABLE direct_messages (
    id         TEXT PRIMARY KEY,
    student_id TEXT NOT NULL,
    payload    TEXT NOT NULL,
    sent_at    TEXT NOT NULL
  )
''';

const String _v3GroupMessages = '''
  CREATE TABLE group_messages (
    id       TEXT PRIMARY KEY,
    group_id TEXT NOT NULL,
    payload  TEXT NOT NULL,
    sent_at  TEXT NOT NULL
  )
''';
