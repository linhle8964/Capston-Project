import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wedding_app/utils/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    yield state.update(isEmailValid: Validation.isEmailValid(email));
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validation.isPasswordValid(password));
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (e) {
      print("[ERROR] : $e");
      yield LoginState.failure(message: "Có lỗi xảy ra");
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
        yield LoginState.failure(message: "Có lỗi xảy ra");
      } else {
        if (!user.emailVerified) {
          yield LoginState.failure(message: "Bạn chưa xác nhận email");
        } else {
          yield LoginState.success();
        }
      }
    } catch (e) {
      print("[ERROR] : $e");
      if (e.toString() == "Exception: user-not-found") {
        yield LoginState.failure(message: "Tài khoản không tồn tại");
      } else if (e.toString() == "Exception: wrong-password") {
        yield LoginState.failure(message: "Sai mật khẩu");
      } else if (e.toString() == "Exception: too-many-requests") {
        yield LoginState.failure(
            message:
                "Bạn đã đăng nhập quá nhiều lần. Hãy thử lại trong giây lát");
      } else {
        yield LoginState.failure(message: "Có lỗi xảy ra");
      }
    }
  }
}
