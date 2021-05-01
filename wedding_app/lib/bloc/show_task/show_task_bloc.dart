import 'dart:async';
import 'package:wedding_app/bloc/show_task/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class ShowTaskBloc extends Bloc<ShowMonth, Month> {
  static int number;

  ShowTaskBloc({@required int number1})
      :super(MonthLoading(number: number1));

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
    if ((event.number - 1) > number) {
      yield MonthMovedToNext(++number);
    }
  }

  Stream<Month> _mapShowPreviousToState(ShowPrevious event) async* {
    if (number > 0) {
      yield MonthMovedPreviously(--number);
    }
  }

  Stream<Month> _mapDeleteMonthToState() async* {
   number=0;
   yield MonthDeleted();
  }
}
