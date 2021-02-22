import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InviteEmailEntity extends Equatable {
  final String id;
  final String from;
  final String to;
  final String weddingId;
  final String title;
  final String body;
  final String code;
  final DateTime date;
  final String role;

  InviteEmailEntity(this.id, this.from, this.to, this.weddingId, this.title,
      this.body, this.code, this.date, this.role);

  @override
  List<Object> get props =>
      [id, from, to, weddingId, title, body, code, date, role];

  Map<String, Object> toJson() {
    return {
      "id": id,
      "from": from,
      "to": to,
      "wedding_id": weddingId,
      "title": title,
      "body": body,
      "code": code,
      "date": date,
      "role": role,
    };
  }

  static InviteEmailEntity fromJson(Map<String, Object> json) {
    return InviteEmailEntity(
      json["id"] as String,
      json["from"] as String,
      json["to"] as String,
      json["wedding_id"] as String,
      json["title"] as String,
      json["body"] as String,
      json["code"] as String,
      (json["date"] as Timestamp).toDate(),
      json["role"] as String,
    );
  }

  static InviteEmailEntity fromSnapshot(DocumentSnapshot snapshot) {
    return InviteEmailEntity(
      snapshot.id,
      snapshot.get("from"),
      snapshot.get("to"),
      snapshot.get("wedding_id"),
      snapshot.get("title"),
      snapshot.get("body"),
      snapshot.get("code"),
      snapshot.get("date") == null
          ? null
          : (snapshot.get("date") as Timestamp).toDate(),
      snapshot.get("role"),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "from": from,
      "to": to,
      "wedding_id": weddingId,
      "title": title,
      "body": body,
      "code": code,
      "date": date,
      "role": role,
    };
  }
}
