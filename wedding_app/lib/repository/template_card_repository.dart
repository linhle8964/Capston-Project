import 'package:wedding_app/model/template_card.dart';
import 'dart:async';
abstract class TemplateCardRepository {
  Stream<List<TemplateCard>> GetAllTemplate();
}
