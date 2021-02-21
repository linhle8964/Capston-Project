import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/user_wedding.dart';

abstract class UserWeddingState extends Equatable {
  const UserWeddingState();
  @override
  List<Object> get props => [];
}

class UserWeddingLoading extends UserWeddingState {}

class UserWeddingLoaded extends UserWeddingState {
  final List<UserWedding> userWeddings;

  UserWeddingLoaded(this.userWeddings);

  @override
  List<Object> get props => [userWeddings];
}

class UserWeddingNotLoaded extends UserWeddingState {}

class UserWeddingSuccess extends UserWeddingState {
  final String message;

  UserWeddingSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UserWeddingFailed extends UserWeddingState {
  final String message;

  UserWeddingFailed(this.message);

  @override
  List<Object> get props => [message];
}

class UserWeddingProcessing extends UserWeddingState {}
