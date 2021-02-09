import 'package:bloc/bloc.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';

class UserWeddingBloc extends Bloc<UserWeddingEvent, UserWeddingState> {
  final UserWeddingRepository _userWeddingRepository;

  UserWeddingBloc({@required UserWeddingRepository userWeddingRepository})
      : assert(userWeddingRepository != null),
        _userWeddingRepository = userWeddingRepository,
        super(UserWeddingLoading());

  @override
  Stream<UserWeddingState> mapEventToState(UserWeddingEvent event) async* {
    if (event is LoadWeddingByUser) {
      yield* _mapLoadWeddingByUserToState(event);
    }
  }

  Stream<UserWeddingState> _mapLoadWeddingByUserToState(
      LoadWeddingByUser event) async* {
    UserWedding userWedding =
        await _userWeddingRepository.getUserWeddingByUser(event.user);
    if (userWedding == null) {
      yield UserWeddingNull();
    } else {
      yield UserWeddingLoaded(userWedding);
    }
  }
}
