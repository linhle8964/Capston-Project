import 'package:flutter/cupertino.dart';
import 'package:wedding_app/entity/notification_entity.dart';
import 'package:wedding_app/entity/task_entity.dart';
import 'package:equatable/equatable.dart';

@immutable
class NotificationModel extends Equatable{
  String docID;
  int id;
  String content;
  bool read;
  int type;
  DateTime date;
  String detailsID;
  bool isNew;
//<editor-fold desc="Data Methods" defaultstate="collapsed">
  String getDate(){
    return "${date.day}/${date.month}/${date.year}";
  }

   NotificationModel({
    @required this.docID,
    @required this.id,
    @required this.content,
    @required this.read,
    @required this.type,
    @required this.date,
    @required this.detailsID,
    @required this.isNew,
  });

  NotificationModel copyWith({
    String docID,
    int id,
    String content,
    bool read,
    int type,
    String category,
    DateTime date,
    String detailsID,
    bool isNew,
  }) {
    if ((docID == null || identical(docID, this.docID)) &&
        (id == null || identical(id, this.id)) &&
        (content == null || identical(content, this.content)) &&
        (read == null || identical(read, this.read)) &&
        (type == null || identical(type, this.type)) &&
        (date == null || identical(date, this.date)) &&
        (detailsID == null || identical(detailsID, this.detailsID)) &&
        (isNew == null || identical(isNew, this.isNew))
    ) {
      return this;
    }

    return new NotificationModel(
      docID: docID ?? this.docID,
      id: id ?? this.id,
      content: content ?? this.content,
      read: read ?? this.read,
      type: type ?? this.type,
      date: date ?? this.date,
      detailsID: detailsID ?? this.detailsID,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  String toString() {
    return 'Notification{$docID $id $content $read $type $date $detailsID $isNew}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is NotificationModel &&
              runtimeType == other.runtimeType &&
              docID == other.docID &&
              id == other.id &&
              content == other.content &&
              read == other.read &&
              type == other.type &&
              date == other.date &&
              detailsID == other.detailsID &&
              isNew == other.isNew
          );

  @override
  int get hashCode =>
      docID.hashCode ^
      id.hashCode ^
      content.hashCode ^
      read.hashCode ^
      type.hashCode ^
      date.hashCode ^
      detailsID.hashCode ^
      isNew.hashCode;

  NotificationEntity toEntity() {
    return NotificationEntity(docID, id, content, read, type, date, detailsID, isNew);
  }

  static NotificationModel fromEntity(NotificationEntity entity) {
    return NotificationModel(
      docID: entity.docID,
      id: entity.id,
      content: entity.content,
      read: entity.read,
      type: entity.type,
      date: entity.date,
      detailsID: entity.detailsID,
      isNew: entity.isNew,
    );
  }

  @override
  List<Object> get props => [docID, id,content,read,type,date,detailsID,isNew];

}