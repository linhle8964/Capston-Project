import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/wedding.dart';

abstract class WeddingState extends Equatable {
  const WeddingState();

  @override
  List<Object> get props => [];
}

class WeddingLoading extends WeddingState {}

class WeddingLoaded extends WeddingState {
  final List<Wedding> weddings;

  const WeddingLoaded([this.weddings]);

  @override
  List<Object> get props => [weddings];
}

class WeddingNotLoaded extends WeddingState {}
