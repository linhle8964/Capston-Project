import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_app/entity/user_wedding_entity.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserWeddingRepository extends UserWeddingRepository {
  final userWeddingCollection =
      FirebaseFirestore.instance.collection("user_wedding");

  @override
  Future<void> addUserToWedding(UserWedding userWedding) async {
    return userWeddingCollection
        .doc(userWedding.id)
        .update(userWedding.toEntity().toDocument());
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
  Future<List<UserWedding>> getAllUserByWedding(String weddingId) async {
    QuerySnapshot querySnapshot = await userWeddingCollection
        .where("wedding_id", isEqualTo: weddingId)
        .get();
    return querySnapshot.docs.map((snapshot) {
      return UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(snapshot));
    }).toList();
  }

  @override
  Future<void> createUserWedding(User user) {
    return userWeddingCollection
        .add(new UserWedding(user.email, id: user.uid).toEntity().toDocument());
  }

  @override
  Future<void> createUserWeddingByEmail(String email) {
    return userWeddingCollection
        .add(new UserWedding(email).toEntity().toDocument());
  }

  @override
  Future<void> updateUserWedding(
      User user, Wedding wedding, String userWeddingId, String role) {
    return userWeddingCollection.doc(userWeddingId).set(new UserWedding(
            user.email,
            joinDate: DateTime.now(),
            role: role,
            userId: user.uid,
            weddingId: wedding.id)
        .toEntity()
        .toDocument());
  }

  @override
  Future<UserWedding> getUserWeddingByUser(User user) async {
    QuerySnapshot snapshots =
        await userWeddingCollection.where("email", isEqualTo: user.email).get();
    if (snapshots.size == 0) {
      return null;
    }

    DocumentSnapshot snapshot = snapshots.docs[0];
    return UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(snapshot));
  }

  @override
  Future<UserWedding> getUserWeddingByEmail(String email) async {
    QuerySnapshot snapshots =
        await userWeddingCollection.where("email", isEqualTo: email).get();
    if (snapshots.size == 0) {
      return null;
    }

    DocumentSnapshot snapshot = snapshots.docs[0];
    return UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(snapshot));
  }

  @override
  Future<void> addUserId(UserWedding userWedding, User user) {
    return userWeddingCollection.doc(userWedding.id).set(new UserWedding(
            user.email,
            role: userWedding.role,
            userId: user.uid,
            joinDate: userWedding.joinDate,
            weddingId: userWedding.weddingId)
        .toEntity()
        .toDocument());
  }

  @override
  Stream<List<UserWedding>> getAllUserWedding(String weddingId) {
    return userWeddingCollection
        .where("wedding_id", isEqualTo: weddingId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              UserWedding.fromEntity(UserWeddingEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}
