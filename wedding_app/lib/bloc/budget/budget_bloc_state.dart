import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/budget.dart';

abstract class BudgetState extends Equatable {

  const BudgetState();

  @override
  List<Object> get props => [];
}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final List<Budget> budgets;
  const BudgetLoaded([this.budgets = const []]);
  @override
  List<Object> get props => [budgets];

  @override
  String toString() {
    return 'BudgetLoaded{budgets: $budgets}\n';
  }
}

class BudgetNotLoaded extends BudgetState {}

class Success extends BudgetState {
  final String message;

  const Success(this.message);

  @override
  List<Object> get props => [message];
}

class Failed extends BudgetState {
  final String message;

  const Failed(this.message);

  @override
  List<Object> get props => [message];
}

class Loading extends BudgetState {
  final String message;

  const Loading(this.message);

  @override
  List<Object> get props => [message];
}
