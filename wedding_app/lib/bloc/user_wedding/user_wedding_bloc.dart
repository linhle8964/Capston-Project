import 'dart:async';
import 'package:bloc/bloc.dart';
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
