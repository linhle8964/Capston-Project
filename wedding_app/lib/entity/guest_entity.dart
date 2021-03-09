import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GuestEntity extends Equatable {
  String id;
  String name;
  String description;
  int status;
  String phone;

  GuestEntity(
      this.id,
      this.name,
      this.description,
      this.status,
      this.phone);

  @override
  List<Object> get props => [
    id,
    name,
    description,
    status,
    phone
  ];

  Map<String, Object> toJson(){
    return {
      "id": id,
      "name": name,
      "description": description,
      "status": status,
      "phone": phone,
    };
  }

  static GuestEntity fromJson(Map<String, Object> json){
    return GuestEntity(
        json["id"] as String,
        json["name "] as String,
        json["description"] as String,
        json["status"] as int,
        json["phone"] as String,
    );
  }

  static GuestEntity fromSnapshot(DocumentSnapshot snapshot){
    return GuestEntity(
        snapshot.id,
        snapshot.get("name"),
        snapshot.get("description"),
        snapshot.get("status"),
        snapshot.get("phone"),
    );
  }

  Map<String, Object> toDocument(){
    return {
      "name": name,
      "description": description,
      "status": status,
      "phone": phone,
    };
  }
}