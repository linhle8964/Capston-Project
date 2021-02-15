import 'package:equatable/equatable.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  List<Object> get props => [];
}

class LoadCategory extends DataEvent {}


