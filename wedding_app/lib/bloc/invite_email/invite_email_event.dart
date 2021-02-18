import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class InviteEmailEvent extends Equatable {
  const InviteEmailEvent();

  @override
  List<Object> get props => [];
}

class SendEmailButtonSubmitted extends InviteEmailEvent {
  final String email;
  final String role;

  const SendEmailButtonSubmitted(this.email, this.role);

  @override
  List<Object> get props => [email, role];
}
