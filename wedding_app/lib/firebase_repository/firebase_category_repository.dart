import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_app/entity/category_entity.dart';
import 'package:wedding_app/model/category_model.dart';
import 'package:wedding_app/repository/category_repository.dart';

class FirebaseCategoryRepository implements CategoryRepository{
  final categoryCollection = FirebaseFirestore.instance.collection('category');

  @override
  Stream<List<Category>> getCategories() {
    return categoryCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Category.fromEntity(CategoryEntity.fromSnapshot(doc)))
          .toList();
    });
  }

}