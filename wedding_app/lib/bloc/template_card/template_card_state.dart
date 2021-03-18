import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/template_card.dart';

abstract class TemplateCardState extends Equatable{
  const TemplateCardState();

  @override
  List<Object> get props => [];
}

class TemplateCardLoading extends TemplateCardState{}

class TemplateCardLoaded extends TemplateCardState{
  final List<TemplateCard> template;

  const TemplateCardLoaded([this.template= const[]]);

  @override
  List<Object> get props =>[template];

  @override
  String toString() => 'TemplateCardLoaded {templateCard: $template}';


}
class TemplateCardNotLoaded extends TemplateCardState{}