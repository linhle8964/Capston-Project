import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/budget.dart';

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

  const LoadBudgetbyCateId(this.cateId, this.weddingId);
  @override
  List<Object> get props => [];
  @override
  String toString() {
    return 'LoadBudgetbyCateId{cateId: $cateId, weddingId: $weddingId}';
  }
}

class GetAllBudget extends BudgetEvent {
  final String weddingId;

  const GetAllBudget(this.weddingId);
}

class GetBudgetById extends BudgetEvent {
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
  final String weddingId;
  final String budgetId;

  DeleteBudget(this.weddingId, this.budgetId);
}

class UpadatedBudget extends BudgetEvent {
  final List<Budget> budgets;

  const UpadatedBudget(this.budgets);

  @override
  List<Object> get props => [budgets];
}
