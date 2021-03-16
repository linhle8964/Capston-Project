import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable{
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

class Submitted extends ResetPasswordEvent {
  final String email;

  Submitted({@required this.email});

  @override
  String toString() {
    return 'Submitted { email: $email}';
  }
}

class ShowSuccessMessage extends ResetPasswordEvent{}