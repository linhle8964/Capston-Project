import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_app/entity/user_wedding_entity.dart';
import 'package:wedding_app/entity/wedding_entity.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/repository/wedding_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseWeddingRepository extends WeddingRepository {
  final weddingCollection = FirebaseFirestore.instance.collection('wedding');
  final userWeddingCollection =
      FirebaseFirestore.instance.collection("user_wedding");

  @override
  Future<void> createWedding(Wedding wedding, User user) async {
    DocumentReference reference = weddingCollection.doc();
    QuerySnapshot querySnapshot =
        await userWeddingCollection.where("email", isEqualTo: user.email).get();
    UserWedding userWedding = UserWedding.fromEntity(
        UserWeddingEntity.fromSnapshot(querySnapshot.docs[0]));

    return reference.set(wedding.toEntity().toDocument()).then((value) =>
        userWeddingCollection.doc(userWedding.id).set(new UserWedding(
                user.email,
                userId: user.uid,
                joinDate: DateTime.now(),
                role: "wedding_admin",
                weddingId: reference.id)
            .toEntity()
            .toDocument()));
  }

  @override
  Future<void> updateWedding(Wedding wedding) {
    return weddingCollection
        .doc(wedding.id)
        .update(wedding.toEntity().toDocument());
  }

  @override
  Stream<Wedding> getWedding(String weddingId) {
    return weddingCollection.doc(weddingId).snapshots().map(
        (snapshot) => Wedding.fromEntity(WeddingEntity.fromSnapshot(snapshot)));
  }

  @override
  Future<void> deleteWedding(String weddingId) {
    return weddingCollection.doc(weddingId).delete().then((value) {
      deleteNestedCollection(weddingId, "budget");
      deleteNestedCollection(weddingId, "task");
      deleteNestedCollection(weddingId, "guest");
      deleteNestedCollection(weddingId, "invitation_card");
    });
  }

  void deleteNestedCollection(String weddingId, String collection) {
    final nestedCollection =
        weddingCollection.doc(weddingId).collection(collection);
    nestedCollection.get().then((value) {
      value.docs.forEach((element) {
        nestedCollection
            .doc(element.id)
            .delete()
            .then((value) => print("Success"));
      });
    });
  }

  @override
  Stream<List<Wedding>> getAllWedding() {
    return weddingCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Wedding.fromEntity(WeddingEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<Wedding> getWeddingById(String weddingId) async {
    DocumentSnapshot snapshot = await weddingCollection.doc(weddingId).get();
    return Wedding.fromEntity(WeddingEntity.fromSnapshot(snapshot));
  }
}
