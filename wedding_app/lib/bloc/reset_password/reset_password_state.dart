import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ResetPasswordState extends Equatable {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;

  bool get isFormValid => isEmailValid;
  ResetPasswordState(
      {@required this.isEmailValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure,
      @required this.message});

  @override
  List<Object> get props =>
      [isEmailValid, isSubmitting, isSuccess, isFailure, message];

  factory ResetPasswordState.empty() {
    return ResetPasswordState(
        isEmailValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        message: "");
  }
}
