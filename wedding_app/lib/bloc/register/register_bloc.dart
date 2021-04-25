import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:wedding_app/utils/validations.dart';
import 'bloc.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
    if(email == null){
      yield state.update(
        isEmailValid: false,
      );
    }else{
      yield state.update(
        isEmailValid: Validation.isEmailValid(email),
      );
    }

  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
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
      yield state.update(isPasswordValid: false);
    }
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
      yield RegisterState.failure(MessageConst.emailAlreadyRegistered);
    } on FirebaseException{
      yield RegisterState.failure(MessageConst.commonError);
    }catch (e) {
      print("[ERROR] $e");
      yield RegisterState.failure(MessageConst.commonError);
    }
  }

  Stream<RegisterState> _mapShowSuccessMessageToState() async*{
    yield RegisterState.success(MessageConst.registerSuccess);
  }
}
