import 'package:wedding_app/repository/template_card_repository.dart';
import 'package:wedding_app/model/template_card.dart';
import 'package:wedding_app/entity/template_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTemplateCardRepository implements TemplateCardRepository {
  final templateCollection =
      FirebaseFirestore.instance.collection('cardTemplate');

  @override
  Stream<List<TemplateCard>> getAllTemplate() {
    return templateCollection.snapshots().map((snapshot) {
      print(snapshot.docs
          .map((doc) =>
              TemplateCard.fromEntity(TemplateCardEntity.fromSnapshot(doc)))
          .toList());
      return snapshot.docs
          .map((doc) =>
              TemplateCard.fromEntity(TemplateCardEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}
