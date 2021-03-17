import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/model/task_model.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeProcessing extends HomeState{
  final String message;

  HomeProcessing({this.message});
  @override
  List<Object> get props => [message];
}

class HomeLoaded extends HomeState{
  final List<Budget> listBudget;
  final List<Task> listTask;
  final List<Guest> listGuest;

  HomeLoaded({this.listBudget, this.listTask, this.listGuest});
  @override
  List<Object> get props => [listBudget, listTask, listGuest];
}

class HomeNotLoaded extends HomeState{
  final String message;

  HomeNotLoaded({this.message});

  @override
  List<Object> get props => [message];
}

