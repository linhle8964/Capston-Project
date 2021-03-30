import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GuestEntity extends Equatable {
  String id;
  String name;
  String description;
  int status;
  String phone;
  int type;
  int companion;
  String congrat;
  int money;

  GuestEntity(
      this.id,
      this.name,
      this.description,
      this.status,
      this.phone,
      this.type,
      this.companion,
      this.congrat,
      this.money);

  @override
  List<Object> get props => [
    id,
    name,
    description,
    status,
    phone,
    type,
    companion,
    congrat,
    money
  ];

  Map<String, Object> toJson(){
    return {
      "id": id,
      "name": name,
      "description": description,
      "status": status,
      "phone": phone,
      "type": type,
      "companion": companion,
      "congrat": congrat,
      "money": money
    };
  }

  static GuestEntity fromJson(Map<String, Object> json){
    return GuestEntity(
        json["id"] as String,
        json["name "] as String,
        json["description"] as String,
        json["status"] as int,
        json["phone"] as String,
        json["type"] as int,
        json["companion"] as int,
        json["congrat"] as String,
        json["money"] as int
    );
  }

  static GuestEntity fromSnapshot(DocumentSnapshot snapshot){
    return GuestEntity(
        snapshot.id,
        snapshot.get("name"),
        snapshot.get("description"),
        snapshot.get("status"),
        snapshot.get("phone"),
        snapshot.get("type"),
        snapshot.get("companion"),
        snapshot.get("congrat"),
        snapshot.get("money")
    );
  }

  Map<String, Object> toDocument(){
    return {
      "name": name,
      "description": description,
      "status": status,
      "phone": phone,
      "type": type,
      "companion": companion,
      "congrat": congrat,
      "money": money
    };
  }
}