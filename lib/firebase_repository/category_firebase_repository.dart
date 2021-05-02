import 'package:flutter_web_diary/entity/category_entity.dart';
import 'package:flutter_web_diary/model/category.dart';
import 'package:flutter_web_diary/repository/category_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCategoryRepository implements CategoryRepository {
  final cateCollection = FirebaseFirestore.instance.collection('category');

  @override
  Stream<List<Category>> getallCategory() {
    return cateCollection.snapshots().map((snapshot) {
      print(snapshot.docs
          .map((doc) => Category.fromEntity(CategoryEntity.fromSnapshot(doc)))
          .toList());
      return snapshot.docs
          .map((doc) => Category.fromEntity(CategoryEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}
