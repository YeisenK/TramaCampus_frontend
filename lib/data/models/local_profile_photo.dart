import 'dart:typed_data';
import '../../core/database/schema.dart';

class LocalProfilePhoto {
  const LocalProfilePhoto({
    required this.id,
    required this.studentId,
    required this.bytes,
    required this.mimeType,
    this.width,
    this.height,
    required this.isPrimary,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String studentId;
  final Uint8List bytes;
  final String mimeType;
  final int? width;
  final int? height;
  final bool isPrimary;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, Object?> toMap() {
    return {
      ProfilePhotoColumns.id: id,
      ProfilePhotoColumns.studentId: studentId,
      ProfilePhotoColumns.bytes: bytes,
      ProfilePhotoColumns.mimeType: mimeType,
      ProfilePhotoColumns.width: width,
      ProfilePhotoColumns.height: height,
      ProfilePhotoColumns.isPrimary: isPrimary ? 1 : 0,
      ProfilePhotoColumns.position: position,
      ProfilePhotoColumns.createdAt: createdAt.millisecondsSinceEpoch,
      ProfilePhotoColumns.updatedAt: updatedAt.millisecondsSinceEpoch,
    };
  }

  factory LocalProfilePhoto.fromMap(Map<String, Object?> map) {
    return LocalProfilePhoto(
      id: map[ProfilePhotoColumns.id] as String,
      studentId: map[ProfilePhotoColumns.studentId] as String,
      bytes: map[ProfilePhotoColumns.bytes] as Uint8List,
      mimeType: map[ProfilePhotoColumns.mimeType] as String,
      width: map[ProfilePhotoColumns.width] as int?,
      height: map[ProfilePhotoColumns.height] as int?,
      isPrimary: (map[ProfilePhotoColumns.isPrimary] as int) == 1,
      position: map[ProfilePhotoColumns.position] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map[ProfilePhotoColumns.createdAt] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map[ProfilePhotoColumns.updatedAt] as int),
    );
  }

  LocalProfilePhoto copyWith({
    bool? isPrimary,
    int? position,
    DateTime? updatedAt,
  }) {
    return LocalProfilePhoto(
      id: id,
      studentId: studentId,
      bytes: bytes,
      mimeType: mimeType,
      width: width,
      height: height,
      isPrimary: isPrimary ?? this.isPrimary,
      position: position ?? this.position,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
