import 'package:equatable/equatable.dart';
import 'package:flutter_web_diary/entity/wedding_entity.dart';

class Wedding extends Equatable {
  String id;

  Wedding(this.id);
  WeddingEntity toEntity() {
    return WeddingEntity(id);
  }
  static Wedding fromEntity(WeddingEntity entity) {
    return Wedding(
      entity.id,
    );
  }

  @override
  String toString() {
    return 'Wedding{id: $id}';
  }

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

