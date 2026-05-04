/// Table and column name constants — no raw strings inside repositories.
class Tables {
  Tables._();

  static const String profilePhotos = 'profile_photos';
  static const String meta = 'meta';
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
