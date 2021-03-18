import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/template_card.dart';

abstract class TemplateCardEvent extends Equatable {
  const TemplateCardEvent();

  @override
  List<Object> get props => [];
}

class LoadTemplateCard extends TemplateCardEvent{}

class AddTemplateCard extends TemplateCardEvent{
  final TemplateCard template;

  const AddTemplateCard(this.template);

  @override
  List<Object> get props => [template];

  @override
  String toString() => 'AddTemplateCard{template: $template}';
}

class UpDateTemplateCard extends TemplateCardEvent{
  final TemplateCard template;

  const UpDateTemplateCard(this.template);

  @override
  List<Object> get props => [template];

  @override
  String toString() => 'UpdateTemplateCard{template: $template}';
}

class DeleteTemplateCard extends TemplateCardEvent{
  final TemplateCard template;

  const DeleteTemplateCard(this.template);

  @override
  List<Object> get props => [template];

  @override
  String toString() => 'DeleteTemplateCard{template: $template}';
}

class ClearCompleted extends TemplateCardEvent{}

class ToggleAll extends TemplateCardEvent{}

class TemplateCardUpdated extends TemplateCardEvent{
  final List<TemplateCard> template;

  const TemplateCardUpdated(this.template);

  @override
  List<Object> get props => [template];


}