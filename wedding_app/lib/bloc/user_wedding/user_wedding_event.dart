import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserWeddingEvent extends Equatable {
  const UserWeddingEvent();
  @override
  List<Object> get props => [];
}

class LoadWeddingByUser extends UserWeddingEvent {
  final User user;

  LoadWeddingByUser(this.user);

  @override
  List<Object> get props => [user];
}
