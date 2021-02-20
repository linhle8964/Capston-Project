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

  const SendEmailButtonSubmitted(this.email);

  @override
  List<Object> get props => [email];
}
