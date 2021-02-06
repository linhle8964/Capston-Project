import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/wedding.dart';

@immutable
abstract class WeddingEvent extends Equatable {
  const WeddingEvent();
  @override
  List<Object> get props => [];
}

class LoadWeddings extends WeddingEvent {}

class LoadWeddingById extends WeddingEvent {
  final String id;

  const LoadWeddingById(this.id);

  @override
  List<Object> get props => [id];
}

class CreateWedding extends WeddingEvent {
  final Wedding wedding;
  final String userId;

  const CreateWedding(this.wedding, this.userId);

  @override
  List<Object> get props => [wedding];

  @override
  String toString() => 'CreateWedding { wedding: $wedding }';
}

class UpdateWedding extends WeddingEvent {
  final Wedding wedding;

  const UpdateWedding(this.wedding);

  @override
  List<Object> get props => [wedding];

  @override
  String toString() => 'UpdateWedding { wedding: $wedding }';
}

class DeleteWedding extends WeddingEvent {
  final Wedding wedding;

  const DeleteWedding(this.wedding);

  @override
  List<Object> get props => [wedding];

  @override
  String toString() => 'CreateWedding { wedding: $wedding }';
}

class WeddingUpdated extends WeddingEvent {
  final List<Wedding> weddings;

  const WeddingUpdated(this.weddings);

  @override
  List<Object> get props => [weddings];
}
