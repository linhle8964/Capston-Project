import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TemplateCardEntity extends Equatable {
  final String id;
  final String backgroundUrl;
  final String name;
  final String url;

  @override
  List<Object> get props => [
    id,
    backgroundUrl,
    name,
    url,
  ];

  const TemplateCardEntity(
      this.id,
      this.backgroundUrl,
      this.name,
      this.url,
      );
  @override
  String toString() {
    return "TemplateCardEntity (id: $id, backgroundUrl: $backgroundUrl, name: $name, url: $url)";
  }

  static TemplateCardEntity fromSnapshot(DocumentSnapshot snapshot){
    return TemplateCardEntity(
      snapshot.id,
      snapshot.get('backgroud_url'),
      snapshot.get('name'),
      snapshot.get('url')
    );
  }

  static TemplateCardEntity fromJson(Map<String, Object> json){
    return TemplateCardEntity(
      json['id'] as String,
      json['backgroud_url'] as String,
      json['name'] as String,
      json['url'] as String
    );
  }

  Map<String,Object> toDocument(){
    return{
      'backgroud_url': backgroundUrl,
      'name': name,
      'url': url
    };
  }
}