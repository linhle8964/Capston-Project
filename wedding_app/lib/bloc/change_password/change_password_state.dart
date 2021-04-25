import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/const/message_const.dart';

@immutable
class ChangePasswordState extends Equatable {
  final bool isOldPasswordValid;
  final bool isNewPasswordValid;
  final bool isRepeatPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;
  final String oldPasswordErrorMessage;
  final String newPasswordErrorMessage;
  final String repeatPasswordErrorMessage;

  bool get isFormValid =>
      isOldPasswordValid && isNewPasswordValid && isRepeatPasswordValid;
  ChangePasswordState(
      {@required this.isOldPasswordValid,
      @required this.isNewPasswordValid,
      @required this.isRepeatPasswordValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure,
      @required this.message,
      @required this.oldPasswordErrorMessage,
      @required this.newPasswordErrorMessage,
      @required this.repeatPasswordErrorMessage});

  @override
  List<Object> get props => [
        isOldPasswordValid,
        isNewPasswordValid,
        isRepeatPasswordValid,
        isSubmitting,
        isSuccess,
        isFailure,
        message,
        oldPasswordErrorMessage,
        newPasswordErrorMessage,
        repeatPasswordErrorMessage
      ];

  factory ChangePasswordState.empty() {
    return ChangePasswordState(
        isOldPasswordValid: true,
        isNewPasswordValid: true,
        isRepeatPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        message: "",
        oldPasswordErrorMessage: "",
        newPasswordErrorMessage: "",
        repeatPasswordErrorMessage: "");
  }

  factory ChangePasswordState.loading() {
    return ChangePasswordState(
        isOldPasswordValid: true,
        isNewPasswordValid: true,
        isRepeatPasswordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        message: MessageConst.commonLoading,
        oldPasswordErrorMessage: "",
        newPasswordErrorMessage: "",
        repeatPasswordErrorMessage: "");
  }

  factory ChangePasswordState.success({String message}) {
    return ChangePasswordState(
        isOldPasswordValid: true,
        isNewPasswordValid: true,
        isRepeatPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        message: message,
        oldPasswordErrorMessage: "",
        newPasswordErrorMessage: "",
        repeatPasswordErrorMessage: "");
  }

  factory ChangePasswordState.failure({String message}) {
    return ChangePasswordState(
        isOldPasswordValid: true,
        isNewPasswordValid: true,
        isRepeatPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        message: message,
        oldPasswordErrorMessage: "",
        newPasswordErrorMessage: "",
        repeatPasswordErrorMessage: "");
  }

  ChangePasswordState update(
      {bool isOldPasswordValid,
      bool isNewPasswordValid,
      bool isRepeatPasswordValid,
      String oldPasswordErrorMessage,
      String newPasswordErrorMessage,
      String repeatPasswordErrorMessage}) {
    return copyWith(
        isOldPasswordValid: isOldPasswordValid,
        isNewPasswordValid: isNewPasswordValid,
        isRepeatPasswordValid: isRepeatPasswordValid,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        message: "",
        oldPasswordErrorMessage: oldPasswordErrorMessage,
        newPasswordErrorMessage: newPasswordErrorMessage,
        repeatPasswordErrorMessage: repeatPasswordErrorMessage);
  }

  ChangePasswordState copyWith(
      {bool isOldPasswordValid,
      bool isNewPasswordValid,
      bool isRepeatPasswordValid,
      bool isSubmitEnabled,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure,
      String message,
      String oldPasswordErrorMessage,
      String newPasswordErrorMessage,
      String repeatPasswordErrorMessage}) {
    return ChangePasswordState(
        isOldPasswordValid: isOldPasswordValid ?? this.isOldPasswordValid,
        isNewPasswordValid: isNewPasswordValid ?? this.isNewPasswordValid,
        isRepeatPasswordValid:
            isRepeatPasswordValid ?? this.isRepeatPasswordValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        message: message ?? this.message,
        oldPasswordErrorMessage:
            oldPasswordErrorMessage ?? this.oldPasswordErrorMessage,
        newPasswordErrorMessage:
            newPasswordErrorMessage ?? this.newPasswordErrorMessage,
        repeatPasswordErrorMessage:
            repeatPasswordErrorMessage ?? this.repeatPasswordErrorMessage);
  }

  @override
  String toString() {
    return '''ChangePasswordState {
      isOldPasswordValid: $isOldPasswordValid,
      isNewPasswordValid: $isNewPasswordValid,
      isRepeatPasswordValid: $isRepeatPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      message: $message,
      oldPasswordErrorMessage: $oldPasswordErrorMessage,
      newPasswordErrorMessage: $newPasswordErrorMessage,
      repeatPasswordErrorMessage: $repeatPasswordErrorMessage
    }''';
  }
}
