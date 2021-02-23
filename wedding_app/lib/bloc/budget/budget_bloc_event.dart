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
  final String cateId;
  final String weddingId;
final List<Budget> budgets;
  const LoadBudgetbyCateId(this.cateId,this.weddingId,this.budgets);
  @override
  List<Object> get props => [budgets ];
  @override
  String toString() {
    return 'LoadBudgetbyCateId{cateId: $cateId, weddingId: $weddingId}';
  }

}
class GetBudgetById extends BudgetEvent{
  final String budgetId;
  final String weddingId;
  GetBudgetById(this.budgetId, this.weddingId);

  List<Object> get props => [budgetId];

}

class CreateBudget extends BudgetEvent {
  final String wedding;
  final Budget budget;

  const CreateBudget(this.wedding, this.budget);

  @override
  List<Object> get props => [budget];

  @override
  String toString() => 'CreateBudget { budget: $budget }';
}

class UpdateBudget extends BudgetEvent {
  final Budget updatedBudget;
  final String weddingId;


  UpdateBudget(this.updatedBudget, this.weddingId);

  @override
  List<Object> get props => [updatedBudget];

  @override
  String toString() {
    return 'UpdateBudget{updatedBudget: $updatedBudget}';
  }
}

class DeleteBudget extends BudgetEvent {

}

class BudgetUpdated extends BudgetEvent {
  final List<Budget> budgets;

  const BudgetUpdated(this.budgets);

  @override
  List<Object> get props => [budgets];
}