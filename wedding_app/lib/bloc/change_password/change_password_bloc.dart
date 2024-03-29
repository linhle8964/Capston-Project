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
    if(oldPassword != null){
      oldPassword = oldPassword.trim();
      bool isValid = Validation.isPasswordValid(oldPassword);
      String message = "";
      if(isValid == false){
        if(oldPassword.length < 8){
          message = MessageConst.passwordLengthMin;
        }else if(oldPassword.length > 20){
          message = MessageConst.passwordLengthMax;
        }else if(!oldPassword.contains(new RegExp(r'[0-9]'))){
          message = MessageConst.passwordAtLeastOneNumber;
        }else if(!oldPassword.contains(new RegExp(r'[A-Za-z]'))){
          message = MessageConst.passwordAtLeastOneCharacter;
        }
      }
      yield state.update(isOldPasswordValid: isValid, oldPasswordErrorMessage: message);
    }else{
      yield state.update(isOldPasswordValid: false);
    }
  }

  Stream<ChangePasswordState> _mapNewPasswordChangedToState(
      String newPassword) async* {
    if(newPassword != null){
      newPassword = newPassword.trim();
      bool isValid = Validation.isPasswordValid(newPassword);
      String message = "";
      if(isValid == false){
        if(newPassword.length < 8){
          message = MessageConst.passwordLengthMin;
        }else if(newPassword.length > 20){
          message = MessageConst.passwordLengthMax;
        }else if(!newPassword.contains(new RegExp(r'[0-9]'))){
          message = MessageConst.passwordAtLeastOneNumber;
        }else if(!newPassword.contains(new RegExp(r'[A-Za-z]'))){
          message = MessageConst.passwordAtLeastOneCharacter;
        }
      }
      yield state.update(isNewPasswordValid: isValid, newPasswordErrorMessage: message);
    }else{
      yield state.update(isNewPasswordValid: false);
    }
  }

  Stream<ChangePasswordState> _mapRepeatPasswordChangedToState(
      String repeatPassword) async* {
    if(repeatPassword != null){
      repeatPassword = repeatPassword.trim();
      bool isValid = Validation.isPasswordValid(repeatPassword);
      String message = "";
      if(isValid == false){
        if(repeatPassword.length < 8){
          message = MessageConst.passwordLengthMin;
        }else if(repeatPassword.length > 20){
          message = MessageConst.passwordLengthMax;
        }else if(!repeatPassword.contains(new RegExp(r'[0-9]'))){
          message = MessageConst.passwordAtLeastOneNumber;
        }else if(!repeatPassword.contains(new RegExp(r'[A-Za-z]'))){
          message = MessageConst.passwordAtLeastOneCharacter;
        }
      }
      yield state.update(isRepeatPasswordValid: isValid, repeatPasswordErrorMessage: message);
    }else{
      yield state.update(isRepeatPasswordValid: false);
    }
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
