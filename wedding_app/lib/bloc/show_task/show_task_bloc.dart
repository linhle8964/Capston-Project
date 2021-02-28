import 'dart:async';
import 'package:wedding_app/bloc/show_task/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class ShowTaskBloc extends Bloc<ShowMonth, Month> {
  int _number;

  ShowTaskBloc({@required int number1})
      : _number = number1,
        super(MonthLoading(number: number1));

  @override
  Stream<Month> mapEventToState(
    ShowMonth event,
  ) async* {
    if (event is ShowNext) {
      yield* _mapShowNextToState(event);
    } else if (event is ShowPrevious) {
      yield* _mapShowPreviousToState(event);
    }else if (event is DeleteMonth) {
      yield* _mapDeleteMonthToState();
    }
  }

  Stream<Month> _mapShowNextToState(ShowNext event) async* {
    if ((event.number - 1) > _number) {
      print(_number);
      yield MonthMovedToNext(++_number);
    }
  }

  Stream<Month> _mapShowPreviousToState(ShowPrevious event) async* {
    if (_number > 0) {
      print(_number);
      yield MonthMovedPreviously(--_number);
    }
  }

  Stream<Month> _mapDeleteMonthToState() async* {
   _number=0;
   yield MonthDeleted();
  }
}
