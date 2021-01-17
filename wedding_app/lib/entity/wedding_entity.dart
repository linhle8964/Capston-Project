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
  // TODO: implement props
  List<Object> get props => [
        id,
        brideName,
        groomName,
        weddingDate,
        budget,
        image,
        dateCreated,
        address,
        modifiedDate
      ];

  Map<String, Object> toJson() {
    return {
      "id": id,
      "bride_name": brideName,
      "groom_name": groomName,
      "wedding_date": weddingDate,
      "budget": budget,
      "image": image,
      "date_created": dateCreated,
      "address": address,
      "modified_date": modifiedDate
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
      (json["wedding_date"] as Timestamp).toDate(),
      json["budget"] as double,
      json["image"] as String,
      (json["date_created"] as Timestamp).toDate(),
      json["address"] as String,
      (json["modified_date"] as Timestamp).toDate(),
    );
  }

  static WeddingEntity fromSnapshot(DocumentSnapshot snapshot){
    return WeddingEntity(
      snapshot.id,
      snapshot.get("bride_name"),
      snapshot.get("groom_name"),
      snapshot.get("wedding_date"),
      snapshot.get("budget"),
      snapshot.get("image"),
      snapshot.get("date_created"),
      snapshot.get("address"),
      snapshot.get("modified_date"),
    );
  }

  Map<String, Object> toDocument(){
    return{
      "bride_name": brideName,
      "groom_name": groomName,
      "wedding_date": weddingDate,
      "budget": budget,
      "image": image,
      "date_created": dateCreated,
      "address": address,
      "modified_date": modifiedDate
    };
  }
}
