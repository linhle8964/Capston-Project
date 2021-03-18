import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String name;
  final DateTime dueDate;
  final bool status;
  final String note;
  final String category;

  @override
  List<Object> get props => [
        id,
        name,
        dueDate,
        status,
        note,
        category,
      ];

  const TaskEntity(
    this.id,
    this.name,
    this.dueDate,
    this.status,
    this.note,
    this.category,
  );

  @override
  String toString() {
    return 'TaskEntity{id: $id, name: $name, dueDate: $dueDate, status: $status, note: $note, category: $category}';
  }

  Map<String, Object> toJson() {
    return {
      "id": id,
      "name": name,
      "due_date": dueDate,
      "status": status,
      "note": note,
      "category": category,
    };
  }

  static TaskEntity fromJson(Map<String, Object> json) {
    return TaskEntity(
      json["id"] as String,
      json["name"] as String,
      json["due_date"] as DateTime,
      json["status"] as bool,
      json["note"] as String,
      json["category"] as String,
    );
  }

  static TaskEntity fromSnapshot(DocumentSnapshot snapshot) {
    Timestamp timestamp = snapshot.get("due_date");
    DateTime tempDate = timestamp.toDate();
    return TaskEntity(
      snapshot.id,
      snapshot.get("name"),
      tempDate,
      snapshot.get("status"),
      snapshot.get("note"),
      snapshot.get("category"),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "due_date": dueDate,
      "status": status,
      "note": note,
      "category": category,
    };
  }
}
