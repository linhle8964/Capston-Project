import 'package:wedding_app/entity/user_wedding_entity.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserWeddingRepository extends UserWeddingRepository {
  final userWeddingCollection =
      FirebaseFirestore.instance.collection("user_wedding");
  @override
  Future<void> addUserToWedding(String email, UserWedding userWedding) async {
    // TODO: implement addUserToWedding
    throw UnimplementedError();
  }

  @override
  Stream<UserWedding> getWeddingByUser(String userId) {
    return userWeddingCollection.doc(userId).snapshots().map((snapshot) =>
        UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(snapshot)));
  }

  @override
  Future<void> removeUserFromWedding(
      String email, UserWedding userWedding) async {
    // TODO: implement removeUserFromWedding
    throw UnimplementedError();
  }

  @override
  Future<UserWedding> getUserWedding(String userId) async {
    DocumentSnapshot snapshot = await userWeddingCollection.doc(userId).get();

    if (!snapshot.exists) {
      return null;
    }
    return UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(snapshot));
  }
}
