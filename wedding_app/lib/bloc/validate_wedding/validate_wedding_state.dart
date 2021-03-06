import 'package:meta/meta.dart';

@immutable
class ValidateWeddingState {
  final bool isGroomNameValid;
  final bool isBrideNameValid;
  final bool isAddressValid;

  bool get isFormValid =>
      isGroomNameValid && isBrideNameValid && isAddressValid;

  ValidateWeddingState({
    @required this.isGroomNameValid,
    @required this.isBrideNameValid,
    @required this.isAddressValid,
  });

  factory ValidateWeddingState.empty() {
    return ValidateWeddingState(
      isGroomNameValid: true,
      isBrideNameValid: true,
      isAddressValid: true,
    );
  }

  ValidateWeddingState update({
    bool isGroomNameValid,
    bool isBrideNameValid,
    bool isAddressValid,
  }) {
    return copyWith(
      isGroomNameValid: isGroomNameValid,
      isBrideNameValid: isBrideNameValid,
      isAddressValid: isAddressValid,
    );
  }

  ValidateWeddingState copyWith({
    bool isGroomNameValid,
    bool isBrideNameValid,
    bool isAddressValid,
    bool isSubmitEnabled,
  }) {
    return ValidateWeddingState(
      isGroomNameValid: isGroomNameValid ?? this.isGroomNameValid,
      isBrideNameValid: isBrideNameValid ?? this.isBrideNameValid,
      isAddressValid: isAddressValid ?? this.isAddressValid,
    );
  }

  @override
  String toString() {
    return '''CreateWeddingState {
      isGroomNameValid: $isGroomNameValid,
      isBrideNameValid: $isBrideNameValid,
      isAddressValid : $isAddressValid,
    }''';
  }
}