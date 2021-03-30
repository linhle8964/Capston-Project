import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserWeddingBloc extends Bloc<UserWeddingEvent, UserWeddingState> {
  final UserWeddingRepository _userWeddingRepository;
  StreamSubscription _userWeddingSubscription;

  UserWeddingBloc({@required UserWeddingRepository userWeddingRepository})
      : assert(userWeddingRepository != null),
        _userWeddingRepository = userWeddingRepository,
        super(UserWeddingLoading());

  @override
  Stream<UserWeddingState> mapEventToState(UserWeddingEvent event) async* {
    if (event is LoadUserWeddingByWedding) {
      yield* _mapLoadUserWeddingsToState();
    } else if (event is UserWeddingUpdated) {
      yield* _mapUserWeddingsUpdateToState(event);
    } else if (event is RemoveUserFromUserWedding) {
      yield* _mapRemoveUserFromWedding(event);
    }
  }

  Stream<UserWeddingState> _mapLoadUserWeddingsToState() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String weddingId = prefs.getString("wedding_id");
    _userWeddingSubscription?.cancel();
    _userWeddingSubscription =
        _userWeddingRepository.getAllUserWedding(weddingId).listen(
      (userWeddings) {
        add(UserWeddingUpdated(userWeddings));
      },
    );
  }

  Stream<UserWeddingState> _mapUserWeddingsUpdateToState(
      UserWeddingUpdated event) async* {
    yield UserWeddingLoaded(event.userWeddings);
  }

  Stream<UserWeddingState> _mapRemoveUserFromWedding(
      RemoveUserFromUserWedding event) async* {
    yield UserWeddingProcessing();
    try {
      UserWedding userWedding =
          await _userWeddingRepository.getUserWeddingByUser(event.user);

      List<UserWedding> listUserWedding = await _userWeddingRepository
          .getAllWeddingAdminByWedding(userWedding.weddingId);

      if (listUserWedding.length <= 1) {
        yield UserWeddingEmpty();
      } else {
        _userWeddingRepository.updateUserWedding(new UserWedding(
            userWedding.email,
            id: userWedding.id,
            userId: userWedding.userId,
            role: null,
            joinDate: userWedding.joinDate,
            weddingId: null));
        yield UserWeddingSuccess("Thành công");
      }
    } catch (e) {
      print("[ERROR]" + e);
      yield UserWeddingFailed("Có lỗi xảy ra");
    }
  }

  @override
  Future<void> close() {
    _userWeddingSubscription?.cancel();
    return super.close();
  }
}
