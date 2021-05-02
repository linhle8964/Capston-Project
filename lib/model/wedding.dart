import 'package:equatable/equatable.dart';
import 'package:flutter_web_diary/entity/wedding_entity.dart';

class Wedding extends Equatable {
  String id;
  final DateTime weddingDate;

  Wedding(this.id, this.weddingDate);
  WeddingEntity toEntity() {
    return WeddingEntity(id, weddingDate);
  }
  static Wedding fromEntity(WeddingEntity entity) {
    return Wedding(
      entity.id,
      entity.weddingDate,
    );
  }

  @override
  String toString() {
    return 'Wedding{id: $id, date: $weddingDate}';
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, weddingDate];
}

