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
}

class UserWeddingNull extends UserWeddingState {}

class UserWeddingNotLoaded extends UserWeddingState {}
