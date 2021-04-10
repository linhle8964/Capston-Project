import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/wedding.dart';

abstract class WeddingState extends Equatable {
  final String isSubmitted;
  const WeddingState([this.isSubmitted]);

  @override
  List<Object> get props => [isSubmitted];
}

class WeddingLoading extends WeddingState {}

class WeddingLoaded extends WeddingState {
  final Wedding wedding;

  const WeddingLoaded([this.wedding]);

  @override
  List<Object> get props => [wedding];
}

class WeddingNotLoaded extends WeddingState {}

class Success extends WeddingState {
  final String message;

  const Success(this.message);

  @override
  List<Object> get props => [message];
}

class Failed extends WeddingState {
  final String message;

  const Failed(this.message);

  @override
  List<Object> get props => [message];
}

class Loading extends WeddingState {
  final String message;

  const Loading(this.message);

  @override
  List<Object> get props => [message];
}
