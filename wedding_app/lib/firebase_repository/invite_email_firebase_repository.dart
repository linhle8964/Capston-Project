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
}
