import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class NotificationEntity extends Equatable {
  final String docID;
  final int id;
  final String content;
  final bool read ;
  final int type;
  final DateTime date;
  final String detailsID;
  final bool isNew;

  @override
  List<Object> get props => [
    docID,
    id,
    content,
    read,
    type,
    date,
    detailsID,
    isNew
  ];

  const NotificationEntity(
      this.docID,
      this.id,
      this.content,
      this.read,
      this.type,
      this.date,
      this.detailsID,
      this.isNew
      );

  @override
  String toString() {
    return 'NotificationEntity{$docID $id $content $read $type $date $detailsID $isNew}';
  }

  Map<String, Object> toJson() {
    return {
      "docID": docID,
      "id": id,
      "content": content,
      "read": read,
      "type": type,
      "date": date,
      "details_id": detailsID,
      "is_new": isNew,
    };
  }

  static NotificationEntity fromJson(Map<String, Object> json) {
    return NotificationEntity(
      json["docID"] as String,
      json["id"] as int,
      json["content"] as String,
      json["read"] as bool,
      json["type"] as int,
      json["date"] as DateTime,
      json["details_id"] as String,
      json["is_new"] as bool,
    );
  }

  static NotificationEntity fromSnapshot(DocumentSnapshot snapshot) {
    Timestamp timestamp = snapshot.get("date");
    DateTime tempDate = timestamp.toDate();
    return NotificationEntity(
      snapshot.id,
      snapshot.get("ID"),
      snapshot.get("content"),
      snapshot.get("read"),
      snapshot.get("type"),
      tempDate,
      snapshot.get("details_id"),
      snapshot.get("is_new"),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "ID": id,
      "content": content,
      "read": read,
      "type": type,
      "date":date,
      "details_id":detailsID,
      "is_new": isNew,
    };
  }
}
