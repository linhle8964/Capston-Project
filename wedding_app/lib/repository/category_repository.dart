import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/screens/budget/model/category.dart';
import 'package:firebase_auth/firebase_auth.dart';
abstract class CategoryRepository{

  Stream<List<Category>> GetallCategory();

}