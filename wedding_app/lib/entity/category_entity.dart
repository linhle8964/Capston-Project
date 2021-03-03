import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryEntity extends Equatable{
  final String id;
  final String name;


  CategoryEntity(this.id, this.name);

  @override
  List<Object> get props => [
    id,
    name,
  ];

  @override
  String toString() {
    return 'CategoryEntity{id: $id, name: $name}';
  }

  Map<String, Object> toJson() {
    return {
      "id": id,
      "CateName": name,
    };
  }

  static CategoryEntity fromJson(Map<String, Object> json) {
    return CategoryEntity(
      json["id"] as String,
      json["CateName"] as String,
    );
  }

  static CategoryEntity fromSnapshot(DocumentSnapshot snapshot) {
    return CategoryEntity(
      snapshot.id,
      snapshot.get("CateName"),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "CateName": name,
    };
  }
}