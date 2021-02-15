import 'package:wedding_app/entity/category_entity.dart';

class Category{
  final String id;
  final String CateName;

  Category(this.id, this.CateName);

  Category copyWith({
    String id,
    String CateName,

  }) {
    return Category(
        CateName ?? this.CateName,
        id ?? this.id
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(id, CateName);
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      entity.CateName,
      entity.id,
    );
  }

}