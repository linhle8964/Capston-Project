import 'package:wedding_app/entity/user_wedding_entity.dart';

class UserWedding {
  final String userId;
  final String weddingId;
  final String role;

  UserWedding(this.weddingId, this.role, {String userId})
      : this.userId = userId;

  UserWedding copyWith({String weddingId, String role, String userId}) {
    return UserWedding(weddingId ?? this.weddingId, role ?? this.role,
        userId: userId ?? this.userId);
  }

  static UserWedding fromEntity(UserWeddingEntity entity) {
    return UserWedding(entity.weddingId, entity.role, userId: entity.userId);
  }

  UserWeddingEntity toEntity() {
    return UserWeddingEntity(userId, weddingId, role);
  }
}
