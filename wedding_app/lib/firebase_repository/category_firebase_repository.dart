import 'package:wedding_app/entity/category_entity.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/repository/category_repository.dart';

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
