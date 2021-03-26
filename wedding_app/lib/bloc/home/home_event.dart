import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHome extends Equatable {
  final String weddingId;

  LoadHome(this.weddingId);

  @override
  List<Object> get props => [weddingId];
}