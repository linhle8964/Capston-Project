import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wedding_app/utils/validations.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.empty());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> events, transitionFn) {
    final observableStream = events;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    if(email != null){
      yield state.update(isEmailValid: Validation.isEmailValid(email));
    }else{
      yield state.update(isEmailValid: false);
    }
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    if(password != null){
      password = password.trim();
      bool isValid = Validation.isPasswordValid(password);
      String message = "";
      if(isValid == false){
        if(password.length < 8){
          message = MessageConst.passwordLengthMin;
        }else if(password.length > 20){
          message = MessageConst.passwordLengthMax;
        }else if(!password.contains(new RegExp(r'[0-9]'))){
          message = MessageConst.passwordAtLeastOneNumber;
        }else if(!password.contains(new RegExp(r'[A-Za-z]'))){
          message = MessageConst.passwordAtLeastOneCharacter;
        }
      }
      yield state.update(isPasswordValid: isValid, passwordErrorMessage: message);
    }else{
      yield state.update(isPasswordValid: false, passwordErrorMessage: null);
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (e) {
      print("[ERROR] : $e");
      yield LoginState.failure(message: MessageConst.commonError);
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      final user = await _userRepository.signInWithCredentials(email, password);
      if (user == null) {
        yield LoginState.failure(message: MessageConst.commonError);
      } else {
        if (!user.emailVerified) {
          yield LoginState.failure(message: MessageConst.emailNotVerified);
        } else {
          yield LoginState.success();
        }
      }
    } on EmailNotFoundException {
      yield LoginState.failure(message: MessageConst.emailNotFoundError);
    } on WrongPasswordException {
      yield LoginState.failure(message: MessageConst.wrongPasswordError);
    } on TooManyRequestException {
      yield LoginState.failure(
          message:
              MessageConst.tooManyRequestError);
    } on FirebaseException {
      yield LoginState.failure(message: MessageConst.commonError);
    } catch (e) {
      print("[ERROR] : $e");
      yield LoginState.failure(message: MessageConst.commonError);
    }
  }
}
