import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:wedding_app/const/message_const.dart';

@immutable
class RegisterState extends Equatable{
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;
  final String passwordErrorMessage;

  bool get isFormValid => isEmailValid && isPasswordValid;

  RegisterState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.message,
    @required this.passwordErrorMessage
  });

  factory RegisterState.empty() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
      passwordErrorMessage: "",
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        message: MessageConst.commonLoading,
        passwordErrorMessage: "");
  }

  factory RegisterState.failure(String message) {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      message: message,
      passwordErrorMessage: "",
    );
  }

  factory RegisterState.success(String message) {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      message: message,
      passwordErrorMessage: "",
    );
  }

  RegisterState update({
    bool isEmailValid,
    bool isPasswordValid,
    String passwordErrorMessage,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
      passwordErrorMessage: passwordErrorMessage
    );
  }

  RegisterState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String message,
    String passwordErrorMessage,
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
      passwordErrorMessage: passwordErrorMessage ?? this.passwordErrorMessage
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      message: $message,
      passwordErrorMessage: $passwordErrorMessage
    }''';
  }

  @override
  List<Object> get props => [isEmailValid, isPasswordValid, isSubmitting, isSuccess, isFailure, message, passwordErrorMessage];
}
