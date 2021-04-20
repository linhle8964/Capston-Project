import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wedding_app/utils/validations.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository _userRepository;

  ChangePasswordBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(ChangePasswordState.empty());

  @override
  Stream<Transition<ChangePasswordEvent, ChangePasswordState>> transformEvents(
      Stream<ChangePasswordEvent> events, transitionFn) {
    final observableStream = events;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! OldPasswordChanged &&
          event is! NewPasswordChanged &&
          event is! RepeatPasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is OldPasswordChanged ||
          event is NewPasswordChanged ||
          event is RepeatPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<ChangePasswordState> mapEventToState(
      ChangePasswordEvent event) async* {
    if (event is OldPasswordChanged) {
      yield* _mapOldPasswordChangedToState(event.oldPassword);
    } else if (event is NewPasswordChanged) {
      yield* _mapNewPasswordChangedToState(event.newPassword);
    } else if (event is RepeatPasswordChanged) {
      yield* _mapRepeatPasswordChangedToState(event.repeatPassword);
    } else if (event is ChangePasswordSubmitted) {
      yield* _mapSubmittedToState(
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
          repeatPassword: event.repeatPassword);
    }
  }

  Stream<ChangePasswordState> _mapOldPasswordChangedToState(
      String oldPassword) async* {
    yield state.update(
        isOldPasswordValid: Validation.isPasswordValid(oldPassword));
  }

  Stream<ChangePasswordState> _mapNewPasswordChangedToState(
      String newPassword) async* {
    yield state.update(
        isNewPasswordValid: Validation.isPasswordValid(newPassword));
  }

  Stream<ChangePasswordState> _mapRepeatPasswordChangedToState(
      String repeatPassword) async* {
    yield state.update(
        isRepeatPasswordValid: Validation.isPasswordValid(repeatPassword));
  }

  Stream<ChangePasswordState> _mapSubmittedToState(
      {String oldPassword, String newPassword, String repeatPassword}) async* {
    yield ChangePasswordState.loading();
    try {
      bool validateCurrentPassword =
          await _userRepository.validateCurrentPassword(oldPassword);
      if (!validateCurrentPassword) {
        yield ChangePasswordState.failure(
            message: MessageConst.oldPasswordError);
      } else if (newPassword.trim() != repeatPassword.trim()) {
        yield ChangePasswordState.failure(
            message: MessageConst.repeatPasswordError);
      } else if (newPassword.trim() == oldPassword.trim()) {
        yield ChangePasswordState.failure(
            message: MessageConst.passwordDiffError);
      } else {
        await _userRepository.updatePassword(newPassword);
        yield ChangePasswordState.success(
            message: MessageConst.changePasswordSuccess);
      }
    } on WrongPasswordException {
      yield ChangePasswordState.failure(message: MessageConst.oldPasswordError);
    } catch (e) {
      print("Change Password Submitted Error: $e");
      yield ChangePasswordState.failure(message: MessageConst.commonError);
    }
  }
}
