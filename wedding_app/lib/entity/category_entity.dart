import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable{
  final String id;
  final String CateName;

  CategoryEntity(this.id, this.CateName);

  @override
  // TODO: implement props
  List<Object> get props => [id, CateName];
  Map<String, Object> toJson() {
    return {
      "id": id,
      "CateName": CateName,
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
      "BudgetName": CateName,
    };
  }

}