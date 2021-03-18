import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WeddingEntity extends Equatable {
  String id;

  WeddingEntity(this.id);

  @override
  List<Object> get props => [id];

  Map<String, Object> toJson() {
    return {"id": id,};
  }

  static WeddingEntity fromJson(Map<String, Object> json) {
    return WeddingEntity(json["id"] as String,);
  }

  static WeddingEntity fromSnapshot(DocumentSnapshot snapshot) {
    return WeddingEntity(snapshot.id);
  }
}
