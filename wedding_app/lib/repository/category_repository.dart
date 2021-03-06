import 'package:wedding_app/model/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> getallCategory();
}
