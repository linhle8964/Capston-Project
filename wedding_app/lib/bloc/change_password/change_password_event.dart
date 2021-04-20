import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class OldPasswordChanged extends ChangePasswordEvent {
  final String oldPassword;
  const OldPasswordChanged({@required this.oldPassword});

  @override
  List<Object> get props => [oldPassword];
}

class NewPasswordChanged extends ChangePasswordEvent {
  final String newPassword;
  const NewPasswordChanged({@required this.newPassword});

  @override
  List<Object> get props => [newPassword];
}

class RepeatPasswordChanged extends ChangePasswordEvent {
  final String repeatPassword;
  const RepeatPasswordChanged({@required this.repeatPassword});

  @override
  List<Object> get props => [repeatPassword];
}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;
  final String repeatPassword;

  ChangePasswordSubmitted(
      {@required this.oldPassword,
      @required this.newPassword,
      @required this.repeatPassword});

  @override
  String toString() {
    return 'Submitted { password: $oldPassword, $newPassword, $repeatPassword}';
  }
}
