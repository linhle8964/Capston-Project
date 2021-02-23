import 'package:flutter/cupertino.dart';
import 'package:wedding_app/entity/task_entity.dart';
import 'package:wedding_app/screens/budget/model/category.dart';
import 'package:equatable/equatable.dart';

@immutable
class Task extends Equatable{
  final String id;
  final String name;
  final DateTime dueDate;
  final bool status;
  final String note;
  final String category;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Task({
    @required this.id,
    @required this.name,
    @required this.dueDate,
    @required this.status,
    @required this.note,
    @required this.category,
  });

  Task copyWith({
    String id,
    String name,
    DateTime dueDate,
    bool status,
    String note,
    String category,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name)) &&
        (dueDate == null || identical(dueDate, this.dueDate)) &&
        (status == null || identical(status, this.status)) &&
        (note == null || identical(note, this.note)) &&
        (category == null || identical(category, this.category))
    ) {
      return this;
    }

    return new Task(
      id: id ?? this.id,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      note: note ?? this.note,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $name, dueDate: $dueDate, status: $status, note: $note, category: $category}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          dueDate == other.dueDate &&
          status == other.status &&
          note == other.note &&
          category == other.category
      );

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      dueDate.hashCode ^
      status.hashCode ^
      note.hashCode ^
      category.hashCode ;

  TaskEntity toEntity() {
    return TaskEntity(id, name, dueDate, status,note, category);
  }

  static Task fromEntity(TaskEntity entity) {
    return Task(
      id: entity.id,
      name: entity.name,
      dueDate: entity.dueDate,
      status: entity.status,
      note: entity.note,
      category: entity.category,
    );
  }

  @override
  List<Object> get props => [id,name,dueDate,status,note,category];



}