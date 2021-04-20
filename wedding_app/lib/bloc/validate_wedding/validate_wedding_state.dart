import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
class ValidateWeddingState extends Equatable{
  final bool isGroomNameValid;
  final bool isBrideNameValid;
  final bool isAddressValid;
  final bool isBudgetValid;
  final String groomNameErrorMessage;
  final String brideNameErrorMessage;
  final String addressErrorMessage;
  final String budgetErrorMessage;

  bool get isFormValid =>
      isGroomNameValid && isBrideNameValid && isAddressValid && isBudgetValid;

  ValidateWeddingState({
    @required this.isGroomNameValid,
    @required this.isBrideNameValid,
    @required this.isAddressValid,
    @required this.isBudgetValid,
    @required this.groomNameErrorMessage,
    @required this.brideNameErrorMessage,
    @required this.addressErrorMessage,
    @required this.budgetErrorMessage
  });

  factory ValidateWeddingState.empty() {
    return ValidateWeddingState(
      isGroomNameValid: true,
      isBrideNameValid: true,
      isAddressValid: true,
      isBudgetValid: true,
      groomNameErrorMessage: "",
      brideNameErrorMessage: "",
      addressErrorMessage: "",
      budgetErrorMessage: "",
    );
  }

  factory ValidateWeddingState.submitting() {
    return ValidateWeddingState(
      isGroomNameValid: true,
      isBrideNameValid: true,
      isAddressValid: true,
      isBudgetValid: true,
      groomNameErrorMessage: "",
      brideNameErrorMessage: "",
      addressErrorMessage: "",
      budgetErrorMessage: "",
    );
  }

  ValidateWeddingState update({
    bool isGroomNameValid,
    bool isBrideNameValid,
    bool isAddressValid,
    bool isBudgetValid,
    String groomNameErrorMessage,
    String brideNameErrorMessage,
    String addressErrorMessage,
    String budgetErrorMessage,
  }) {
    return copyWith(
      isGroomNameValid: isGroomNameValid,
      isBrideNameValid: isBrideNameValid,
      isAddressValid: isAddressValid,
      isBudgetValid: isBudgetValid,
      groomNameErrorMessage: groomNameErrorMessage,
      brideNameErrorMessage: brideNameErrorMessage,
      addressErrorMessage: addressErrorMessage,
      budgetErrorMessage: budgetErrorMessage,
    );
  }

  ValidateWeddingState copyWith({
    bool isGroomNameValid,
    bool isBrideNameValid,
    bool isAddressValid,
    bool isBudgetValid,
    String groomNameErrorMessage,
    String brideNameErrorMessage,
    String addressErrorMessage,
    String budgetErrorMessage,
  }) {
    return ValidateWeddingState(
      isGroomNameValid: isGroomNameValid ?? this.isGroomNameValid,
      isBrideNameValid: isBrideNameValid ?? this.isBrideNameValid,
      isAddressValid: isAddressValid ?? this.isAddressValid,
      isBudgetValid: isBudgetValid ?? this.isBudgetValid,
      groomNameErrorMessage: groomNameErrorMessage ?? this.groomNameErrorMessage,
      brideNameErrorMessage: brideNameErrorMessage ?? this.brideNameErrorMessage,
      addressErrorMessage: addressErrorMessage ?? this.addressErrorMessage,
        budgetErrorMessage: budgetErrorMessage ?? this.budgetErrorMessage,
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
  List<Object> get props => [isGroomNameValid, isBrideNameValid, isAddressValid, isBudgetValid, groomNameErrorMessage, brideNameErrorMessage, addressErrorMessage, budgetErrorMessage];
}
