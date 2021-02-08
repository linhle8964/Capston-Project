import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_app/entity/wedding_entity.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/repository/wedding_repository.dart';

class FirebaseWeddingRepository extends WeddingRepository {
  final weddingCollection = FirebaseFirestore.instance.collection('wedding');
  final userWeddingCollection =
      FirebaseFirestore.instance.collection("user_wedding");

  @override
  Future<void> createWedding(Wedding wedding, String userId) {
    DocumentReference reference = weddingCollection.doc();
    userWeddingCollection
        .doc(userId)
        .set(new UserWedding(reference.id, "creator").toEntity().toDocument());
    return reference.set(wedding.toEntity().toDocument());
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
  Future<void> deleteWedding(
      Wedding wedding, List<UserWedding> listUserWedding) {
    for (UserWedding uw in listUserWedding) {
      userWeddingCollection.doc(uw.userId).delete();
    }
    return weddingCollection.doc(wedding.id).delete();
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
