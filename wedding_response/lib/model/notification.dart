import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_diary/entity/notification_entity.dart';
import 'package:flutter_web_diary/model/guest.dart';

@immutable
class NotificationModel extends Equatable{
  String docID;
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

  static NotificationModel fromGuest(Guest guest,String weddingID){
    NotificationModel notificationModel = new NotificationModel(
        content: "${guest.name} đã phản hồi lời mời",
        read: true,
        type: 2,
        date: DateTime.now(),
        detailsID: guest.id,
        isNew: true);
    return notificationModel;
  }

  NotificationModel({this.docID,
    @required this.content,
    @required this.read,
    @required this.type,
    @required this.date,
    @required this.detailsID,
    @required this.isNew,
  });

  NotificationModel copyWith({
    String docID,
    String content,
    bool read,
    int type,
    String category,
    DateTime date,
    String detailsID,
    bool isNew,
  }) {
    if ((docID == null || identical(docID, this.docID)) &&
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
    return 'Notification{$docID $content $read $type $date $detailsID $isNew}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is NotificationModel &&
              runtimeType == other.runtimeType &&
              docID == other.docID &&
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
      content.hashCode ^
      read.hashCode ^
      type.hashCode ^
      date.hashCode ^
      detailsID.hashCode ^
      isNew.hashCode;

  NotificationEntity toEntity() {
    return NotificationEntity(docID, content, read, type, date, detailsID, isNew);
  }

  static NotificationModel fromEntity(NotificationEntity entity) {
    return NotificationModel(
      docID: entity.docID,
      content: entity.content,
      read: entity.read,
      type: entity.type,
      date: entity.date,
      detailsID: entity.detailsID,
      isNew: entity.isNew,
    );
  }

  @override
  List<Object> get props => [docID,content,read,type,date,detailsID,isNew];

}