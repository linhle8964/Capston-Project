import 'package:flutter_web_diary/model/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> getallCategory();
}
