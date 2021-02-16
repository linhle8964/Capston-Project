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
    }
  }

  Stream<UserWeddingState> _mapLoadUserWeddingsToState() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String weddingId = prefs.getString("wedding_id");
    print("Wedding ID : $weddingId");
    _userWeddingSubscription?.cancel();
    _userWeddingSubscription =
        _userWeddingRepository.getAllUserWedding(weddingId).listen(
      (userWeddings) {
        add(UserWeddingUpdated(userWeddings));
        print(userWeddings.length);
      },
    );
  }

  Stream<UserWeddingState> _mapUserToUserWeddingToState(
      AddUserToUserWedding event) async* {
    try {
      UserWedding userWedding =
          await _userWeddingRepository.getUserWeddingByEmail(event.email);
      if (userWedding == null) {
        _userWeddingRepository.createUserWeddingByEmail(event.email);
      } else {
        if (userWedding.weddingId != null) {
          yield UserWeddingFailed(
              "Người dùng này đã có đám cưới. Hãy liên hệ và thử lại");
        }
      }
    } catch (_) {
      yield UserWeddingFailed("Có lỗi xảy ra");
    }
  }

  Stream<UserWeddingState> _mapUserWeddingsUpdateToState(
      UserWeddingUpdated event) async* {
    yield UserWeddingLoaded(event.userWeddings);
  }

  @override
  Future<void> close() {
    _userWeddingSubscription?.cancel();
    return super.close();
  }
}
