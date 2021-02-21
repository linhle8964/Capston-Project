import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:wedding_app/repository/wedding_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';

class WeddingBloc extends Bloc<WeddingEvent, WeddingState> {
  final WeddingRepository _weddingRepository;
  final UserWeddingRepository _userWeddingRepository;
  StreamSubscription _streamSubscription;

  WeddingBloc(
      {@required WeddingRepository weddingRepository,
      @required UserWeddingRepository userWeddingRepository})
      : assert(weddingRepository != null),
        assert(userWeddingRepository != null),
        _weddingRepository = weddingRepository,
        _userWeddingRepository = userWeddingRepository,
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
    }
  }

  // Stream<WeddingState> _mapLoadWeddingsToState(LoadWeddings event) async* {
  //   _streamSubscription?.cancel();
  //   _streamSubscription = _weddingRepository.getAllWedding().listen(
  //         (weddings) => add(WeddingUpdated(weddings)),
  //       );
  // }

  Stream<WeddingState> _mapCreateWeddingToState(CreateWedding event) async* {
    yield Loading("Đang xử lý dữ liệu");
    try {
      final user = FirebaseAuth.instance.currentUser;
      await _weddingRepository.createWedding(event.wedding, user);
      yield Success("Tạo thành công");
    } catch (e) {
      print("[ERROR]" + e);
      yield Failed("Có lỗi xảy ra");
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
    _weddingRepository.updateWedding(event.wedding);
  }

  Stream<WeddingState> _mapDeleteWeddingToState(DeleteWedding event) async* {
    yield Loading("Đang xử lý dữ liệu");
    try {
      _weddingRepository.deleteWedding(event.weddingId).then((value) async {
        _userWeddingRepository.deleteAllUserWeddingByWedding(event.weddingId);
      });
      yield Success("Xoá thành công thành công");
    } catch (e) {
      print("[ERROR]" + e);
      yield Failed("Có lỗi xảy ra");
    }
  }

  Stream<WeddingState> _mapWeddingUpdatedToState(WeddingUpdated event) async* {
    yield WeddingLoaded(event.wedding);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
