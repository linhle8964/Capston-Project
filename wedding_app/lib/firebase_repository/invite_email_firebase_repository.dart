import 'package:wedding_app/entity/invite_email_entity.dart';
import 'package:wedding_app/model/invite_email.dart';
import 'package:wedding_app/repository/invite_email_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseInviteEmailRepository extends InviteEmailRepository {
  final inviteEmailCollection =
      FirebaseFirestore.instance.collection("invite_email");
  @override
  Future<void> createInviteEmail(InviteEmail inviteEmail) {
    return inviteEmailCollection.add(inviteEmail.toEntity().toDocument());
  }

  @override
  Future<InviteEmail> getInviteEmail(String weddingId, String to) async {
    QuerySnapshot snapshots = await inviteEmailCollection
        .where("wedding_id", isEqualTo: weddingId)
        .where("to", isEqualTo: to)
        .get();

    if (snapshots.docs.length == 0 || snapshots == null) {
      return null;
    }
    return InviteEmail.fromEntity(
        InviteEmailEntity.fromSnapshot(snapshots.docs[0]));
  }
}
