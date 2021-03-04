import 'package:meta/meta.dart';

@immutable
class CreateWeddingState {
  final bool isGroomNameValid;
  final bool isBrideNameValid;
  final bool isAddressValid;

  bool get isFormValid =>
      isGroomNameValid && isBrideNameValid && isAddressValid;

  CreateWeddingState({
    @required this.isGroomNameValid,
    @required this.isBrideNameValid,
    @required this.isAddressValid,
  });

  factory CreateWeddingState.empty() {
    return CreateWeddingState(
      isGroomNameValid: true,
      isBrideNameValid: true,
      isAddressValid: true,
    );
  }

  CreateWeddingState update({
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

  CreateWeddingState copyWith({
    bool isGroomNameValid,
    bool isBrideNameValid,
    bool isAddressValid,
    bool isSubmitEnabled,
  }) {
    return CreateWeddingState(
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
