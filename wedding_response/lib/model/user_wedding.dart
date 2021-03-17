
import 'package:flutter_web_diary/entity/user_wedding_entity.dart';

class UserWedding {
  final String id;
  final String userId;
  final String weddingId;
  final String role;
  final String email;
  final DateTime joinDate;

  UserWedding(this.email,
      {String id,
      String userId,
      String weddingId,
      String role,
      DateTime joinDate})
      : this.id = id,
        this.userId = userId,
        this.weddingId = weddingId,
        this.role = role,
        this.joinDate = joinDate;

  UserWedding copyWith(
      {String email,
      String id,
      String userId,
      String weddingId,
      String role,
      DateTime joinDate}) {
    return UserWedding(email ?? this.email,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        weddingId: weddingId ?? this.weddingId,
        role: role ?? this.role,
        joinDate: joinDate ?? this.joinDate);
  }

  static UserWedding fromEntity(UserWeddingEntity entity) {
    return UserWedding(entity.email,
        id: entity.id,
        userId: entity.userId,
        weddingId: entity.weddingId,
        role: entity.role,
        joinDate: entity.joinDate);
  }

  UserWeddingEntity toEntity() {
    return UserWeddingEntity(id, userId, weddingId, role, email, joinDate);
  }

  @override
  String toString() {
    return 'UserWedding{userId: $userId, weddingId: $weddingId, role: $role, email: $email, joinDate: $joinDate}';
  }
}
