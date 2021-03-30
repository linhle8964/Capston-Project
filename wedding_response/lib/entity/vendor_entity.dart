import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VendorEntity extends Equatable {

  final String id;
  final String label;
  final String name;
  final String cateID;
  final String location;
  final String description;
  final String frontImage;
  final String ownerImage;


  VendorEntity(this.id, this.label, this.name, this.cateID, this.location,
      this.description, this.frontImage, this.ownerImage);

  @override
  List<Object> get props =>
      [id, label,name, cateID, location, description, frontImage, ownerImage];

  Map<String, Object> toJson() {
    return {
      "id": id,
      "label": label,
      "name":name,
      "cateID": cateID,
      "location": location,
      "description": description,
      "frontImage": frontImage,
      "ownerImage": ownerImage,
    };
  }

  static VendorEntity fromJson(Map<String, Object> json) {
    return VendorEntity(
      json["id"] as String,
      json["label"] as String,
      json["name"] as String,
      json["cateID"] as String,
      json["location"] as String,
      json["description"] as String,
      json["frontImage"] as String,
      json["ownerImage"] as String,
    );
  }

  static VendorEntity fromSnapshot(DocumentSnapshot snapshot) {
    return VendorEntity(
        snapshot.id,
        snapshot.get("label"),
        snapshot.get("name"),
        snapshot.get("cateID"),
        snapshot.get("location"),
        snapshot.get("description"),
        snapshot.get("frontImage"),
        snapshot.get("ownerImage")
    );
  }


  @override
  String toString() {
    return 'VendorEntity{id: $id, label: $label, name: $name, cateID: $cateID, location: $location, description: $description, frontImage: $frontImage, ownerImage: $ownerImage}';
  }

  Map<String, Object> toDocument() {
    return {
      "label": label,
      "name":name,
      "cateID": cateID,
      "location": location,
      "description": description,
      "frontImage": frontImage,
      "ownerImage": ownerImage,
    };
  }
}
