import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/user_wedding.dart';

abstract class UserWeddingState extends Equatable {
  const UserWeddingState();
  @override
  List<Object> get props => [];
}

class UserWeddingLoading extends UserWeddingState {}

class UserWeddingLoaded extends UserWeddingState {
  final UserWedding userWedding;

  UserWeddingLoaded(this.userWedding);

  @override
  List<Object> get props => [userWedding];
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
