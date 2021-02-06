import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserWeddingEntity extends Equatable {
  final String userId;
  final String weddingId;
  final String role;

  UserWeddingEntity(this.userId, this.weddingId, this.role);

  @override
  List<Object> get props => [userId, weddingId, role];

  Map<String, Object> toJson() {
    return {"user_id": userId, "wedding_id": weddingId, "role": role};
  }

  static UserWeddingEntity fromJson(Map<String, Object> json) {
    return UserWeddingEntity(json["user_id"] as String,
        json["wedding_id"] as String, json["role"] as String);
  }

  static UserWeddingEntity fromSnapshot(DocumentSnapshot snapshot) {
    return UserWeddingEntity(
        snapshot.id, snapshot.get("wedding_id"), snapshot.get("role"));
  }

  Map<String, Object> toDocument() {
    return {"wedding_id": weddingId, "role": role};
  }
}
