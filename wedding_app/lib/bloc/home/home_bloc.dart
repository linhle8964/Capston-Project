import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/bloc/home/bloc.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/repository/budget_repository.dart';
import 'package:wedding_app/repository/guests_repository.dart';
import 'package:wedding_app/repository/task_repository.dart';

class HomeBloc extends Bloc<HomeState, HomeEvent>{
  final TaskRepository _taskRepository;
  final BudgetRepository _budgetRepository;
  final GuestsRepository _guestsRepository;
  StreamSubscription _homeSubscription;

  HomeBloc({@required TaskRepository taskRepository, @required BudgetRepository budgetRepository, @required GuestsRepository guestsRepository})
  : assert(taskRepository != null),
    assert(budgetRepository != null),
    assert(guestsRepository != null),
  _taskRepository = taskRepository,
  _budgetRepository = budgetRepository,
  _guestsRepository = guestsRepository,
  super(HomeLoading());

  @override
  Stream<HomeEvent> mapEventToState(HomeState event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

  Stream<HomeState> _mapLoadHomeToState(LoadHome event) async*{
    yield HomeProcessing(message: "Đang xử lý dữ liệu");
    try{
      String weddingId = event.weddingId;
      //List<Task> listTask = _taskRepository.getTasks(weddingID);
    }catch(e){

    }
  }

  @override
  Future<void> close() {
    _homeSubscription?.cancel();
    return super.close();
  }

}