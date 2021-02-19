import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/budget.dart';

abstract class BudgetState extends Equatable {
  final String isSubmitted;
  const BudgetState([this.isSubmitted]);

  @override
  List<Object> get props => [];
}

class WeddingLoading extends BudgetState {}

class WeddingLoaded extends BudgetState {
  final Budget budget;

  const WeddingLoaded([this.budget]);

  @override
  List<Object> get props => [budget];
}

class WeddingNotLoaded extends BudgetState {}

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
