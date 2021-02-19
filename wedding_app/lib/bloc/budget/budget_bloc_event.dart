import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/wedding.dart';

@immutable
abstract class BudgetEvent extends Equatable {
  const BudgetEvent();
  @override
  List<Object> get props => [];
}
class LoadBudget extends BudgetEvent {}

class LoadBudgetbyCateId extends BudgetEvent {
  final String CateId;

  const LoadBudgetbyCateId(this.CateId);

  @override
  List<Object> get props => [];
}

class CreateBudget extends BudgetEvent {
  final Wedding wedding;
  final Budget budget;

  const CreateBudget(this.wedding, this.budget);

  @override
  List<Object> get props => [budget];

  @override
  String toString() => 'CreateBudget { budget: $budget }';
}

class UpdateBudget extends BudgetEvent {

}

class DeleteBudget extends BudgetEvent {

}

class BudgetUpdated extends BudgetEvent {

}