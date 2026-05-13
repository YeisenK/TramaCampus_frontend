/// Table and column name constants — no raw strings inside repositories.
class Tables {
  Tables._();

  static const String profilePhotos = 'profile_photos';
  static const String meta = 'meta';
  static const String profile = 'profile';
  static const String profileDraft = 'profile_draft';
  static const String catalogCache = 'catalog_cache';
  static const String followedGroups = 'followed_groups';
  static const String memberGroups = 'member_groups';
  static const String userGroups = 'user_groups';
  static const String directMessages = 'direct_messages';
  static const String groupMessages = 'group_messages';
  static const String accounts = 'accounts';
}

class AccountColumns {
  AccountColumns._();

  static const String email = 'email';
  static const String passwordHash = 'password_hash';
  static const String salt = 'salt';
  static const String createdAt = 'created_at';
}

class ProfilePhotoColumns {
  ProfilePhotoColumns._();

  static const String id = 'id';
  static const String studentId = 'student_id';
  static const String bytes = 'bytes';
  static const String mimeType = 'mime_type';
  static const String width = 'width';
  static const String height = 'height';
  static const String isPrimary = 'is_primary';
  static const String position = 'position';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class MetaColumns {
  MetaColumns._();

  static const String key = 'key';
  static const String value = 'value';
}

class ProfileColumns {
  ProfileColumns._();

  static const String id = 'id';
  static const String payload = 'payload';
  static const String updatedAt = 'updated_at';
}

class ProfileDraftColumns {
  ProfileDraftColumns._();

  static const String id = 'id';
  static const String step = 'step';
  static const String payload = 'payload';
  static const String updatedAt = 'updated_at';
}

class CatalogCacheColumns {
  CatalogCacheColumns._();

  static const String name = 'name';
  static const String version = 'version';
  static const String payload = 'payload';
  static const String fetchedAt = 'fetched_at';
}

class FollowedGroupColumns {
  FollowedGroupColumns._();

  static const String groupId = 'group_id';
  static const String followedAt = 'followed_at';
}

class MemberGroupColumns {
  MemberGroupColumns._();

  static const String groupId = 'group_id';
  static const String joinedAt = 'joined_at';
  static const String role = 'role';
}

class UserGroupColumns {
  UserGroupColumns._();

  static const String id = 'id';
  static const String payload = 'payload';
  static const String createdAt = 'created_at';
}

class DirectMessageColumns {
  DirectMessageColumns._();

  static const String id = 'id';
  static const String studentId = 'student_id';
  static const String payload = 'payload';
  static const String sentAt = 'sent_at';
}

class GroupMessageColumns {
  GroupMessageColumns._();

  static const String id = 'id';
  static const String groupId = 'group_id';
  static const String payload = 'payload';
  static const String sentAt = 'sent_at';
}
