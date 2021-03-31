import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_diary/entity/invitation_entity.dart';
import 'package:flutter_web_diary/entity/wedding_entity.dart';
import 'package:flutter_web_diary/model/invitation.dart';
import 'package:flutter_web_diary/model/wedding.dart';
import 'package:flutter_web_diary/repository/invitation_repository.dart';
import 'package:flutter_web_diary/repository/wedding_repository.dart';

class FirebaseInvitationCardRepository extends InvitationCardRepository {
  final weddingCollection = FirebaseFirestore.instance.collection('wedding');

  @override
  Future<InvitationCard> getInvitationCardById(String weddingId) async {
    DocumentSnapshot snapshots = await weddingCollection.doc(weddingId).collection('invitation_card')
        .doc("1")
        .get();
    if (snapshots == null) {
      return null;
    }
    return InvitationCard.fromEntity(
        InvitationCartEntity.fromSnapshot(snapshots));
  }

}

