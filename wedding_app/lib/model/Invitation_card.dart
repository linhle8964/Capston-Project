import 'package:wedding_app/entity/invitation_card_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class InvitationCard extends Equatable {
  final String id;
  final String url;

  const InvitationCard({@required this.id, @required this.url});

  InvitationCard copyWith({String id, String url}) {
    if ((id == null || identical(id, this.id)) &&
        (url == null || identical(url, this.url))) {
      return this;
    }

    return new InvitationCard(id: id ?? this.id, url: url ?? this.url);
  }

  @override
  String toString() {
    return 'TemplateCardEntity (id: $id, url: $url)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvitationCard &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url);

  @override
  int get hashCode => id.hashCode ^ url.hashCode;

  InvitationCardEntity toEntity() {
    return InvitationCardEntity(id, url);
  }

  static InvitationCard fromEntity(InvitationCardEntity entity) {
    return InvitationCard(id: entity.id, url: entity.url);
  }

  @override
  // TODO: implement props
  List<Object> get props => [url];
}
