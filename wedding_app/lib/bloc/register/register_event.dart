import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() {
    return "EmailChanged: $email";
  }
}

class PasswordChanged extends RegisterEvent {
  final String password;

  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() {
    return "PasswordChanged: $password";
  }
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;

  Submitted({@required this.email, this.password});

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}
