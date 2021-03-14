import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
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
    } else if(event is ShowSuccessMessage){
      yield* _mapShowSuccessMessageToState();
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
        // tạo user wedding
        await _userWeddingRepository.createUserWedding(user).then((value) async => add(ShowSuccessMessage()));
      });

    } on EmailAlreadyInUseException{
      yield RegisterState.failure("Email đã tồn tại");
    } on FirebaseException{
      yield RegisterState.failure("Có lỗi xảy ra");
    }catch (e) {
      print("[ERROR] $e");
      yield RegisterState.failure("Có lỗi xảy ra");
    }
  }

  Stream<RegisterState> _mapShowSuccessMessageToState() async*{
    yield RegisterState.success("Đăng ký thành công");
  }
}
