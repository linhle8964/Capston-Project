import 'package:flutter/material.dart';
import 'package:wedding_app/repository/invitation_card_repository.dart';
import 'package:wedding_app/model/Invitation_card.dart';
import 'package:wedding_app/entity/invitation_card_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseInvitationCardRepository implements InvitationCardRepository{
  final templateCollection = FirebaseFirestore.instance.collection('cardTemplate');

  @override
  Stream<List<InvitationCard>> GetAllInvitationCard(String weddingID) {
    return FirebaseFirestore.instance.collection('wedding')
        .doc(weddingID).collection('invitation_card')
        .snapshots().map((snapshot){
         return snapshot.docs
             .map((doc) => InvitationCard.fromEntity(InvitationCardEntity.fromSnapshot(doc))).toList();
    });
  }

  @override
  Future<void> addNewInvitationCard(InvitationCard invitationCard, String weddingID) {
    return FirebaseFirestore.instance.collection('wedding')
        .doc(weddingID).collection('invitation_card')
        .add(invitationCard.toEntity().toDocument());
  }


  
}