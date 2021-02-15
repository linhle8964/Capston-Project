import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  final UserWeddingRepository _userWeddingRepository;

  AuthenticationBloc(
      {@required UserRepository userRepository,
      @required UserWeddingRepository userWeddingRepository})
      : assert(userRepository != null),
        assert(userWeddingRepository != null),
        _userRepository = userRepository,
        _userWeddingRepository = userWeddingRepository,
        super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isAuthenticated = await _userRepository.isAuthenticated();
      if (isAuthenticated) {
        final user = await _userRepository.getUser();
        final UserWedding userWedding =
            await _userWeddingRepository.getUserWeddingByUser(user);
        if (userWedding.weddingId == null) {
          yield Unauthenticated();
        } else {
          yield Authenticated(user);
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final user = await _userRepository.getUser();
    final UserWedding userWedding =
        await _userWeddingRepository.getUserWeddingByUser(user);
    if (userWedding.weddingId == null) {
      yield WeddingNull(user);
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("wedding_id", userWedding.weddingId);
      yield Authenticated(user);
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("wedding_id");
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
