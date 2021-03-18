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

  factory ResetPasswordState.loading() {
    return ResetPasswordState(
        isEmailValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        message: "Đang xử lý dữ liệu");
  }

  factory ResetPasswordState.success({String message}) {
    return ResetPasswordState(
        isEmailValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        message: message);
  }

  factory ResetPasswordState.failure({String message}) {
    return ResetPasswordState(
        isEmailValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        message: message);
  }

  ResetPasswordState copyWith({
    bool isEmailValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String message,
  }) {
    return ResetPasswordState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return '''ResetPasswordState {
      isEmailValid: $isEmailValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      message: $message,
    }''';
  }
}
