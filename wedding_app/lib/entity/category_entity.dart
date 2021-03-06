import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String cateName;

  CategoryEntity(this.id, this.cateName);

  @override
  // TODO: implement props
  List<Object> get props => [id, cateName];
  Map<String, Object> toJson() {
    return {
      "id": id,
      "cateName": cateName,
    };
  }

  static CategoryEntity fromJson(Map<String, Object> json) {
    return CategoryEntity(
      json["id"] as String,
      json["cateName"] as String,
    );
  }

  static CategoryEntity fromSnapshot(DocumentSnapshot snapshot) {
    return CategoryEntity(
      snapshot.id,
      snapshot.get("cateName"),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "BudgetName": cateName,
    };
  }
}
