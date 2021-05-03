import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/utils/validations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wedding_app/utils/vietnam_parser.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';

class ValidateWeddingBloc
    extends Bloc<ValidateWeddingEvent, ValidateWeddingState> {
  ValidateWeddingBloc() : super(ValidateWeddingState.empty());

  @override
  Stream<Transition<ValidateWeddingEvent, ValidateWeddingState>>
      transformEvents(Stream<ValidateWeddingEvent> events, transitionFn) {
    final observableStream = events;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! BrideNameChanged &&
          event is! GroomNameChanged &&
          event is! AddressChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is BrideNameChanged ||
          event is GroomNameChanged ||
          event is AddressChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<ValidateWeddingState> mapEventToState(
      ValidateWeddingEvent event) async* {
    if (event is GroomNameChanged) {
      yield* _mapGroomNameChangedToState(event.groomName);
    } else if (event is BrideNameChanged) {
      yield* _mapBrideNameChangedToState(event.brideName);
    } else if (event is AddressChanged) {
      yield* _mapAddressChangedToState(event.address);
    } else if (event is BudgetChanged) {
      yield* _mapBudgetChangedToState(event.budget);
    }
  }

  Stream<ValidateWeddingState> _mapBrideNameChangedToState(
      String brideName) async* {
    if (brideName != null) {
      bool isValid = Validation.isNameValid(
          VietnameseParserEngine.unsigned(brideName.trim()));
      String message = "";
      if (isValid == false) {
        if (brideName.length > 20) {
          message = MessageConst.nameTooLong;
        } else if (brideName.trim().length < 6) {
          message = MessageConst.nameTooShort;
        } else if (brideName.trim().contains(new RegExp(r'[0-9]'))) {
          message = MessageConst.nameNotContainNumber;
        } else if (brideName
            .contains(new RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]'))) {
          message = MessageConst.nameNotContainSpecialCharacter;
        }
      }
      yield state.update(
          isBrideNameValid: isValid, brideNameErrorMessage: message);
    } else {
      yield state.update(isBrideNameValid: false);
    }
  }

  Stream<ValidateWeddingState> _mapGroomNameChangedToState(
      String groomName) async* {
    if (groomName != null) {
      bool isValid = Validation.isNameValid(
          VietnameseParserEngine.unsigned(groomName.trim()));
      String message = "";
      if (isValid == false) {
        if (groomName.trim().length > 20) {
          message = MessageConst.nameTooLong;
        } else if (groomName.trim().length < 4) {
          message = MessageConst.nameTooShort;
        } else if (groomName.contains(new RegExp(r'[0-9]'))) {
          message = MessageConst.nameNotContainNumber;
        } else if (groomName
            .contains(new RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]'))) {
          message = MessageConst.nameNotContainSpecialCharacter;
        }
      }
      yield state.update(
          isGroomNameValid: isValid, groomNameErrorMessage: message);
    } else {
      yield state.update(isGroomNameValid: false);
    }
  }

  Stream<ValidateWeddingState> _mapAddressChangedToState(
      String address) async* {
    if (address != null) {
      bool isValid = Validation.isAddressValid(address.trim());
      String message = "";
      if (isValid == false) {
        if (address.trim().length > 40) {
          message = MessageConst.addressTooLong;
        } else if (address.trim().length < 6) {
          message = MessageConst.addressTooShort;
        } else {
          message = "Địa chỉ không hợp lệ";
        }
      }
      yield state.update(isAddressValid: isValid, addressErrorMessage: message);
    } else {
      yield state.update(isAddressValid: false);
    }
  }

  Stream<ValidateWeddingState> _mapBudgetChangedToState(String budget) async* {
    if (budget != null) {
      bool isValid = Validation.isBudgetValid(budget);
      String message = "";
      double budgetDouble = double.parse(budget.replaceAll(",", ""));
      if (isValid == false) {
        if (budgetDouble <= 100000) {
          message = MessageConst.budgetMin;
        } else if (budgetDouble > 10000000000) {
          message = MessageConst.budgetMax;
        } else if (budgetDouble % 1000 != 0) {
          message = MessageConst.budgetTripleZero;
        }
      }
      yield state.update(isBudgetValid: isValid, budgetErrorMessage: message);
    } else {
      yield state.update(isBudgetValid: false);
    }
  }
}
