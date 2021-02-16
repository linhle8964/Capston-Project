import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:wedding_app/utils/validations.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  final UserWeddingRepository _userWeddingRepository;
  RegisterBloc(
      {@required UserRepository userRepository,
      @required UserWeddingRepository userWeddingRepository})
      : assert(userRepository != null),
        assert(userWeddingRepository != null),
        _userRepository = userRepository,
        _userWeddingRepository = userWeddingRepository,
        super(RegisterState.empty());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
      Stream<RegisterEvent> events, transitionFn) {
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
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validation.isEmailValid(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validation.isPasswordValid(password),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
      String email, String password) async* {
    yield RegisterState.loading();
    try {
      await _userRepository
          .signUp(
        email: email,
        password: password,
      )
          .then((user) async {
        // kiểm tra tài khoản người dùng
        UserWedding userWedding =
            await _userWeddingRepository.getUserWeddingByUser(user);
        // nếu người dùng chưa có tài khoản và không có đám cưới
        if (userWedding == null) {
          _userWeddingRepository.createUserWedding(user);
        } else {
          // nếu người dùng chưa có tài khoản nhưng được mời qua người dùng khác
          if (userWedding.userId == null) {
            await _userWeddingRepository.addUserId(userWedding, user);
          }
        }
      });
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
