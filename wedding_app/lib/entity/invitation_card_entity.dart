import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InvitationCardEntity extends Equatable {
  final String id;
  final String url;

  const InvitationCardEntity(
      this.url,
      this.id
      );


  @override
  // TODO: implement props
  List<Object> get props => [
    id,
    url
  ];

  @override
  String toString() {
    // TODO: implement toString
    return 'InvitationCardENtity{id: $id, url: $url}';
  }

  static InvitationCardEntity fromSnapshot(DocumentSnapshot snapshot){
    return InvitationCardEntity(
        snapshot.id,
        snapshot.get('url'),
    );
  }

  static InvitationCardEntity fromJson(Map<String, Object> json){
    return InvitationCardEntity(
        json['id'] as String,
        json['url'] as String
    );
  }

  Map<String,Object> toDocument(){
    return{
      'url': url
    };
  }
}