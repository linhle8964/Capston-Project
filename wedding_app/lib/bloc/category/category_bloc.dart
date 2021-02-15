import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/repository/category_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:wedding_app/repository/wedding_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';

class CategoryBloc extends Bloc<DataEvent, DataState> {
  final CategoryRepository _CategoryRepository;
  final UserWeddingRepository _userWeddingRepository;
  StreamSubscription _streamSubscription;

  CategoryBloc(
      {@required CategoryRepository categoryRepository,
        @required UserWeddingRepository userWeddingRepository})
      : assert(categoryRepository != null),
        assert(userWeddingRepository != null),
        _CategoryRepository = categoryRepository,
        _userWeddingRepository = userWeddingRepository,
        super(CategoryLoading());
  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    if (event is LoadCategory) {
      yield* _mapLoadToState();
  }}

    Stream<DataState> _mapLoadToState() async* {
      _CategoryRepository.GetallCategory();
    }
  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
  }