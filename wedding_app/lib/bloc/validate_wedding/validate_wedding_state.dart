import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
class ValidateWeddingState extends Equatable{
  final bool isGroomNameValid;
  final bool isBrideNameValid;
  final bool isAddressValid;
  final bool isBudgetValid;

  bool get isFormValid =>
      isGroomNameValid && isBrideNameValid && isAddressValid && isBudgetValid;

  ValidateWeddingState({
    @required this.isGroomNameValid,
    @required this.isBrideNameValid,
    @required this.isAddressValid,
    @required this.isBudgetValid,
  });

  factory ValidateWeddingState.empty() {
    return ValidateWeddingState(
      isGroomNameValid: true,
      isBrideNameValid: true,
      isAddressValid: true,
      isBudgetValid: true,
    );
  }

  factory ValidateWeddingState.submitting() {
    return ValidateWeddingState(
      isGroomNameValid: true,
      isBrideNameValid: true,
      isAddressValid: true,
      isBudgetValid: true,
    );
  }

  ValidateWeddingState update({
    bool isGroomNameValid,
    bool isBrideNameValid,
    bool isAddressValid,
    bool isBudgetValid,
  }) {
    return copyWith(
      isGroomNameValid: isGroomNameValid,
      isBrideNameValid: isBrideNameValid,
      isAddressValid: isAddressValid,
      isBudgetValid: isBudgetValid,
    );
  }

  ValidateWeddingState copyWith({
    bool isGroomNameValid,
    bool isBrideNameValid,
    bool isAddressValid,
    bool isBudgetValid,
  }) {
    return ValidateWeddingState(
      isGroomNameValid: isGroomNameValid ?? this.isGroomNameValid,
      isBrideNameValid: isBrideNameValid ?? this.isBrideNameValid,
      isAddressValid: isAddressValid ?? this.isAddressValid,
      isBudgetValid: isBudgetValid ?? this.isBudgetValid,
    );
  }

  @override
  String toString() {
    return '''CreateWeddingState {
      isGroomNameValid: $isGroomNameValid,
      isBrideNameValid: $isBrideNameValid,
      isAddressValid : $isAddressValid,
      isBudgetValid : $isBudgetValid,
    }''';
  }

  @override
  List<Object> get props => [isGroomNameValid, isBrideNameValid, isAddressValid, isBudgetValid];
}
