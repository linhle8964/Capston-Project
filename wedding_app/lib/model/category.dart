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

  @override
  String toString() {
    return 'Category{id: $id, CateName: $CateName}';
  }bool operator ==(o) => o is Category && o.CateName == CateName && o.id == id;

  static Category fromEntity(CategoryEntity entity) {
    return Category(

      entity.id,
      entity.CateName,
    );
  }

}