import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ResetPasswordEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() {
    return "EmailChanged: $email";
  }
}

class SubmittedRequestChangePasswrord extends ResetPasswordEvent {
  final String email;

  SubmittedRequestChangePasswrord({@required this.email});

  @override
  String toString() {
    return 'Submitted { email: $email}';
  }
}

class ShowSuccessMessage extends ResetPasswordEvent {
  final String message;

  ShowSuccessMessage({@required this.message});

  @override
  String toString() {
    return 'ShowSuccessMessage { message: $message}';
  }
}
