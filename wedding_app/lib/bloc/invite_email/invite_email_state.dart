import 'package:equatable/equatable.dart';

abstract class InviteEmailState extends Equatable {
  const InviteEmailState();
  @override
  List<Object> get props => [];
}

class InviteEmailLoading extends InviteEmailState {}

class InviteEmailSuccess extends InviteEmailState {
  final String message;

  InviteEmailSuccess({this.message});

  @override
  List<Object> get props => [message];
}

class InviteEmailProcessing extends InviteEmailState {}

class InviteEmailError extends InviteEmailState {
  final String message;

  InviteEmailError({this.message});

  @override
  List<Object> get props => [message];
}
