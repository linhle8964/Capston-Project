import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/bloc/reset_password/bloc.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:wedding_app/utils/validations.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final UserRepository _userRepository;

  ResetPasswordBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(ResetPasswordState.empty());

  @override
  Stream<ResetPasswordState> mapEventToState(ResetPasswordEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is SubmittedRequestChangePasswrord) {
      yield* _mapSubmittedToState(event.email);
    } else if (event is ShowSuccessMessage) {
      yield* _mapShowSuccessMessageToState(event.message);
    }
  }

  Stream<ResetPasswordState> _mapEmailChangedToState(String email) async* {
    yield state.copyWith(isEmailValid: Validation.isEmailValid(email));
  }

  Stream<ResetPasswordState> _mapSubmittedToState(String email) async* {
    yield ResetPasswordState.loading();
    try {
      await _userRepository.resetPassword(email);
      yield ResetPasswordState.success(
          message: "Gửi thành công. Quý khách hãy kiểm tra email");
    } on EmailNotFoundException {
      yield ResetPasswordState.failure(message: MessageConst.emailNotFoundError);
    } catch (e) {
      print("[ERROR] : $e");
      yield ResetPasswordState.failure(message: MessageConst.commonError);
    }
  }

  Stream<ResetPasswordState> _mapShowSuccessMessageToState(
      String message) async* {
    yield ResetPasswordState.success(message: message);
  }
}
