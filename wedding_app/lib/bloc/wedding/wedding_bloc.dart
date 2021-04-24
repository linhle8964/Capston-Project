import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/invite_email_repository.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:wedding_app/repository/wedding_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeddingBloc extends Bloc<WeddingEvent, WeddingState> {
  final WeddingRepository _weddingRepository;
  final UserWeddingRepository _userWeddingRepository;
  final InviteEmailRepository _inviteEmailRepository;
  final UserRepository _userRepository;
  StreamSubscription _streamSubscription;

  WeddingBloc({
    @required WeddingRepository weddingRepository,
    @required UserWeddingRepository userWeddingRepository,
    @required InviteEmailRepository inviteEmailRepository,
    @required UserRepository userRepository,
  })  : assert(weddingRepository != null),
        assert(userWeddingRepository != null),
        assert(inviteEmailRepository != null),
        assert(userRepository != null),
        _weddingRepository = weddingRepository,
        _userWeddingRepository = userWeddingRepository,
        _inviteEmailRepository = inviteEmailRepository,
        _userRepository = userRepository,
        super(WeddingLoading());

  @override
  Stream<WeddingState> mapEventToState(WeddingEvent event) async* {
    if (event is CreateWedding) {
      yield* _mapCreateWeddingToState(event);
    } else if (event is UpdateWedding) {
      yield* _mapUpdateWeddingToState(event);
    } else if (event is DeleteWedding) {
      yield* _mapDeleteWeddingToState(event);
    } else if (event is WeddingUpdated) {
      yield* _mapWeddingUpdatedToState(event);
    } else if (event is LoadWeddingByUser) {
      yield* _mapLoadWeddingByUserToState(event);
    } else if (event is LoadWeddingById) {
      yield* _mapLoadWeddingByIdToState(event);
    }
  }

  // Stream<WeddingState> _mapLoadWeddingsToState(LoadWeddings event) async* {
  //   _streamSubscription?.cancel();
  //   _streamSubscription = _weddingRepository.getAllWedding().listen(
  //         (weddings) => add(WeddingUpdated(weddings)),
  //       );
  // }

  Stream<WeddingState> _mapCreateWeddingToState(CreateWedding event) async* {
    yield Loading(MessageConst.commonLoading);
    try {
      final user = await _userRepository.getUser();
      if(user == null || event.wedding == null){
        yield Failed(MessageConst.commonError);
      }else{
        await _weddingRepository.createWedding(event.wedding, user);
        yield Success(MessageConst.createSuccess, wedding: event.wedding);
      }
    } catch (e) {
      print("[ERROR]" + e);
      yield Failed(MessageConst.commonError);
    }
  }

  Stream<WeddingState> _mapLoadWeddingByUserToState(
      LoadWeddingByUser event) async* {
    UserWedding userWedding =
        await _userWeddingRepository.getUserWeddingByUser(event.user);
    if (userWedding.userId != null) {
      _streamSubscription?.cancel();
      _streamSubscription = _weddingRepository
          .getWedding(userWedding.weddingId)
          .listen((wedding) => add(WeddingUpdated(wedding)));
    }
  }

  Stream<WeddingState> _mapUpdateWeddingToState(UpdateWedding event) async* {
    yield Loading(MessageConst.commonLoading);
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await _weddingRepository.updateWedding(event.wedding);
      preferences.setString(
          "wedding", jsonEncode(event.wedding.toEntity().toJson()));
      yield Success(MessageConst.updateSuccess, wedding: event.wedding);
    } catch (e) {
      print("[ERROR]" + e);
      yield Failed(MessageConst.commonError);
    }
  }

  Stream<WeddingState> _mapDeleteWeddingToState(DeleteWedding event) async* {
    yield Loading(MessageConst.commonLoading);
    try {
      await _weddingRepository.deleteWedding(event.weddingId);
      await _userWeddingRepository
          .deleteAllUserWeddingByWedding(event.weddingId);
      await _inviteEmailRepository
          .deleteInviteEmailByWedding(event.weddingId);
      yield Success(MessageConst.deleteSuccess);
    } catch (e) {
      print("[ERROR]" + e);
      yield Failed(MessageConst.commonError);
    }
  }

  Stream<WeddingState> _mapWeddingUpdatedToState(WeddingUpdated event) async* {
    yield WeddingLoaded(event.wedding);
  }

  Stream<WeddingState> _mapLoadWeddingByIdToState(
      LoadWeddingById event) async* {
    String weddingId = event.weddingId;
    if (weddingId == null || weddingId.isEmpty) {
      yield Failed(MessageConst.commonError);
    } else {
      _streamSubscription?.cancel();
      _streamSubscription = _weddingRepository
          .getWedding(event.weddingId)
          .listen((wedding) => add(WeddingUpdated(wedding)));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
