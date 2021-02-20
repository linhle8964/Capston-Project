import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_app/model/user_wedding.dart';

abstract class UserWeddingEvent extends Equatable {
  const UserWeddingEvent();
  @override
  List<Object> get props => [];
}

class LoadUserWeddingByWedding extends UserWeddingEvent {}

class AddUserToUserWedding extends UserWeddingEvent {
  final String email;

  AddUserToUserWedding(this.email);

  @override
  List<Object> get props => [email];
}

class RemoveUserFromUserWedding extends UserWeddingEvent {
  final User user;

  RemoveUserFromUserWedding(this.user);

  @override
  List<Object> get props => [user];
}

class UserWeddingUpdated extends UserWeddingEvent {
  final List<UserWedding> userWeddings;

  const UserWeddingUpdated(this.userWeddings);

  @override
  List<Object> get props => [userWeddings];
}
