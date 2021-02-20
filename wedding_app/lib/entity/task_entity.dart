import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String name;
  final DateTime dueDate;
  final bool status;
  final String note;


  @override
  List<Object> get props =>[
    id,
    name,
    dueDate,
    status,
    note,
  ];

  const TaskEntity(
     this.id,
     this.name,
     this.dueDate,
     this.status,
     this.note,
  );

  @override
  String toString() {
    return 'TaskEntity{id: $id, name: $name, dueDate: $dueDate, status: $status, note: $note}';
  }



  Map<String, Object> toJson() {
    return {
      "id": id,
      "name": name,
      "due_date": dueDate,
      "status": status,
      "note": note,
    };
  }

  static TaskEntity fromJson(Map<String, Object> json) {
    return TaskEntity(
      json["id"] as String,
      json["name"] as String,
      json["due_date"] as DateTime,
      json["status"] as bool,
      json["note"] as String,
    );
  }

  static TaskEntity fromSnapshot(DocumentSnapshot snapshot) {
    return TaskEntity(
      snapshot.id,
      snapshot.get("name"),
      snapshot.get("due_date"),
      snapshot.get("status"),
      snapshot.get("note"),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "due_date": dueDate,
      "status": status,
      "note": note,
    };
  }
}