import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;
  final String weddingId;

  const Authenticated(this.user, this.weddingId);

  @override
  List<Object> get props => [user, weddingId];

  @override
  String toString() {
    return "Authenticated: { user : $user, weddingId: $weddingId}";
  }
}

class Unauthenticated extends AuthenticationState {}

class WeddingNull extends AuthenticationState {
  final User user;

  const WeddingNull(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return "Wedding Null: { user: $user}";
  }
}
