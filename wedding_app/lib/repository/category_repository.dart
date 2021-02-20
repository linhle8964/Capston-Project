import 'dart:async';
import 'package:wedding_app/model/category_model.dart';

abstract class CategoryRepository {
  Stream<List<Category>> getCategories();
}