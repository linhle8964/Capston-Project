

import 'package:flutter_web_diary/entity/guest_entity.dart';
import 'package:flutter_web_diary/entity/invitation_entity.dart';

class InvitationCard{
  String id;
  String name;
  String url;

  InvitationCard(this.name, this.url,
      {this.id});

  InvitationCard copyWith({
    String id,
    String name,
    String url,
  }){
    return InvitationCard(
        name ?? this.name,
        url ?? this.url,
        id: id ?? this.id
    );
  }

  InvitationCartEntity toEntity(){
    return InvitationCartEntity(id, name, url);
  }

  static InvitationCard fromEntity(InvitationCartEntity entity){
    return InvitationCard(
      entity.name,
      entity.url,
      id: entity.id,
    );
  }

  @override
  String toString() {
    return name +"|"+ url;
  }
}