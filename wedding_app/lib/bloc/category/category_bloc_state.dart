import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/category.dart';

abstract class DataState extends Equatable {
  const DataState();

  List<Object> get props => [];
}



class CategoryLoading extends DataState {}

class CategoryLoaded extends DataState {
  final Category cate;

  const CategoryLoaded([this.cate]);

  @override
  List<Object> get props => [cate];
}

class CategoryNotLoaded extends DataState {}

class Success extends DataState {
  final String message;

  const Success(this.message);

  @override
  List<Object> get props => [message];
}

class Failed extends DataState {
  final String message;

  const Failed(this.message);

  @override
  List<Object> get props => [message];
}

class Loading extends DataState {
  final String message;

  const Loading(this.message);

  @override
  List<Object> get props => [message];
}
