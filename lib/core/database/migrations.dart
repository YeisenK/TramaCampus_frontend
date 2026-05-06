class Migration {
  const Migration({required this.version, required this.up});

  final int version;
  final List<String> up;
}

const List<Migration> kMigrations = [
  Migration(version: 1, up: [_v1ProfilePhotos, _v1PhotosIndex, _v1Meta]),
  Migration(version: 2, up: [_v2Profile, _v2ProfileDraft, _v2CatalogCache]),
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
