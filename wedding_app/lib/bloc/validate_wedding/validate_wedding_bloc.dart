import 'package:wedding_app/utils/validations.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';

class ValidateWeddingBloc extends Bloc<ValidateWeddingEvent, ValidateWeddingState> {
  ValidateWeddingBloc() : super(ValidateWeddingState.empty());

  @override
  Stream<Transition<ValidateWeddingEvent, ValidateWeddingState>> transformEvents(
      Stream<ValidateWeddingEvent> events, transitionFn) {
    final observableStream = events;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! BrideNameChanged &&
          event is! GroomNameChanged &&
          event is! AddressChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is BrideNameChanged ||
          event is GroomNameChanged ||
          event is! AddressChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<ValidateWeddingState> mapEventToState(ValidateWeddingEvent event) async* {
    if (event is GroomNameChanged) {
      yield* _mapGroomNameChangedToState(event.groomName);
    } else if (event is BrideNameChanged) {
      yield* _mapBrideNameChangedToState(event.brideName);
    } else if (event is AddressChanged) {
      yield* _mapAddressChangedToState(event.address);
    }
  }

  Stream<ValidateWeddingState> _mapBrideNameChangedToState(
      String brideName) async* {
    yield state.update(
        isBrideNameValid: Validation.isStringValid(brideName, 6));
  }

  Stream<ValidateWeddingState> _mapGroomNameChangedToState(
      String groomName) async* {
    yield state.update(
        isGroomNameValid: Validation.isStringValid(groomName, 6));
  }

  Stream<ValidateWeddingState> _mapAddressChangedToState(String address) async* {
    yield state.update(isAddressValid: Validation.isStringValid(address, 6));
  }
}
