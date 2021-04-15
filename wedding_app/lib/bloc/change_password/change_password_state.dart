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

  bool get isFormValid =>
      isOldPasswordValid && isNewPasswordValid && isRepeatPasswordValid;
  ChangePasswordState(
      {@required this.isOldPasswordValid,
      @required this.isNewPasswordValid,
      @required this.isRepeatPasswordValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure,
      @required this.message});

  @override
  List<Object> get props => [
        isOldPasswordValid,
        isNewPasswordValid,
        isRepeatPasswordValid,
        isSubmitting,
        isSuccess,
        isFailure,
        message
      ];

  factory ChangePasswordState.empty() {
    return ChangePasswordState(
        isOldPasswordValid: true,
        isNewPasswordValid: true,
        isRepeatPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        message: "");
  }

  factory ChangePasswordState.loading() {
    return ChangePasswordState(
        isOldPasswordValid: true,
        isNewPasswordValid: true,
        isRepeatPasswordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        message: MessageConst.commonLoading);
  }

  factory ChangePasswordState.success({String message}) {
    return ChangePasswordState(
        isOldPasswordValid: true,
        isNewPasswordValid: true,
        isRepeatPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        message: message);
  }

  factory ChangePasswordState.failure({String message}) {
    return ChangePasswordState(
        isOldPasswordValid: true,
        isNewPasswordValid: true,
        isRepeatPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        message: message);
  }

  ChangePasswordState update(
      {bool isOldPasswordValid,
      bool isNewPasswordValid,
      bool isRepeatPasswordValid}) {
    return copyWith(
        isOldPasswordValid: isOldPasswordValid,
        isNewPasswordValid: isNewPasswordValid,
        isRepeatPasswordValid: isRepeatPasswordValid,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        message: "");
  }

  ChangePasswordState copyWith({
    bool isOldPasswordValid,
    bool isNewPasswordValid,
    bool isRepeatPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String message,
  }) {
    return ChangePasswordState(
      isOldPasswordValid: isOldPasswordValid ?? this.isOldPasswordValid,
      isNewPasswordValid: isNewPasswordValid ?? this.isNewPasswordValid,
      isRepeatPasswordValid:
          isRepeatPasswordValid ?? this.isRepeatPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
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
    }''';
  }
}
