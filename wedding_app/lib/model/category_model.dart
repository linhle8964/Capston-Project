import 'package:flutter/cupertino.dart';
import 'package:wedding_app/entity/category_entity.dart';


@immutable
class Category{
  final String id;
  final String name;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Category({
    @required this.id,
    @required this.name,
  });

  Category copyWith({
    String id,
    String name,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name))) {
      return this;
    }

    return new Category(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  CategoryEntity toEntity() {
    return CategoryEntity(id, name);
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
    );
  }
}