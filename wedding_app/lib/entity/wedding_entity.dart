import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WeddingEntity extends Equatable {
  final String id;
  final String brideName;
  final String groomName;
  final DateTime weddingDate;
  final double budget;
  final String image;
  final DateTime dateCreated;
  final String address;
  final DateTime modifiedDate;

  WeddingEntity(
      this.id,
      this.brideName,
      this.groomName,
      this.weddingDate,
      this.budget,
      this.image,
      this.dateCreated,
      this.address,
      this.modifiedDate);

  @override
  List<Object> get props => [
    id,
    brideName,
    groomName,
    weddingDate,
    budget,
    image,
    dateCreated,
    address,
    modifiedDate,
  ];

  Map<String, Object> toJson() {
    return {
      "id": id,
      "bride_name": brideName,
      "groom_name": groomName,
      "wedding_date": weddingDate.millisecondsSinceEpoch,
      "budget": budget,
      "image": image,
      "date_created": dateCreated.millisecondsSinceEpoch,
      "address": address,
      "modified_date": modifiedDate.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return "This is $brideName and $groomName wedding";
  }

  static WeddingEntity fromJson(Map<String, Object> json) {
    return WeddingEntity(
      json["id"] as String,
      json["bride_name"] as String,
      json["groom_name"] as String,
      DateTime.fromMillisecondsSinceEpoch((json["wedding_date"])),
      json["budget"] as double,
      json["image"] as String,
      DateTime.fromMillisecondsSinceEpoch((json["date_created"])),
      json["address"] as String,
      DateTime.fromMillisecondsSinceEpoch((json["modified_date"])),
    );
  }

  static WeddingEntity fromSnapshot(DocumentSnapshot snapshot) {
    snapshot == null ? print("null") : print("not null");
    return WeddingEntity(
      snapshot.id,
      snapshot.get("bride_name"),
      snapshot.get("groom_name"),
      snapshot.get("wedding_date") == null
          ? null
          : (snapshot.get("wedding_date") as Timestamp).toDate(),
      snapshot.get("budget"),
      snapshot.get("image"),
      snapshot.get("date_created") == null
          ? null
          : (snapshot.get("date_created") as Timestamp).toDate(),
      snapshot.get("address"),
      snapshot.get("modified_date") == null
          ? null
          : (snapshot.get("modified_date") as Timestamp).toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "bride_name": brideName,
      "groom_name": groomName,
      "wedding_date": weddingDate,
      "budget": budget,
      "image": image,
      "date_created": dateCreated,
      "address": address,
      "modified_date": modifiedDate,
    };
  }
}