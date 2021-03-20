import 'package:wedding_app/entity/template_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class TemplateCard extends Equatable{
  final String id;
  final String backgroundUrl;
  final String name;
  final String url;

  const TemplateCard({
  @required this.id,
  @required this.backgroundUrl,
  @required this.name,
  @required this.url
  });

  TemplateCard copyWith({
    String id,
    String backgroundUrl,
    String name,
    String url
}){
    if ((id == null || identical(id, this.id)) &&
        (backgroundUrl == null || identical(backgroundUrl, this.backgroundUrl)) &&
          (name == null || identical(name, this.name)) &&
        (url == null || identical( url, this.url))
    ){
      return this;
    }

    return new TemplateCard(
        id: id ?? this.id,
        backgroundUrl: backgroundUrl ?? this.backgroundUrl,
        name: name ?? this.name,
        url: url ?? this.url);
  }
  @override
  String toString() {
    return 'TemplateCardEntity (id: $id, backgroundUrl: $backgroundUrl, name: $name, url: $url)';
  }

  @override
  bool operator == (Object other) =>
      identical(this,other) ||
          (other is TemplateCard &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          backgroundUrl == other.backgroundUrl &&
          url == other.url
          );

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      backgroundUrl.hashCode ^
      url.hashCode ;

  TemplateCardEntity toEntity(){
    return TemplateCardEntity(id, backgroundUrl, name, url);
  }

  static TemplateCard fromEntity(TemplateCardEntity entity){
    return TemplateCard(
        id: entity.id,
        backgroundUrl: entity.backgroundUrl,
        name: entity.name,
        url: entity.url
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [backgroundUrl,name,url];

}