import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:firebase_auth/firebase_auth.dart';

@immutable
abstract class WeddingEvent extends Equatable {
  const WeddingEvent();
  @override
  List<Object> get props => [];
}

class LoadWeddingByUser extends WeddingEvent {
  final User user;

  const LoadWeddingByUser(this.user);

  @override
  List<Object> get props => [user];
}

class LoadWeddingById extends WeddingEvent {
  final String weddingId;

  const LoadWeddingById(this.weddingId);

  @override
  List<Object> get props => [weddingId];
}

class CreateWedding extends WeddingEvent {
  final Wedding wedding;

  const CreateWedding(this.wedding);

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
  final String weddingId;

  const DeleteWedding(this.weddingId);

  @override
  List<Object> get props => [weddingId];

  @override
  String toString() => 'DeleteWedding { wedding: $weddingId }';
}

class WeddingUpdated extends WeddingEvent {
  final Wedding wedding;

  const WeddingUpdated(this.wedding);

  @override
  List<Object> get props => [wedding];
}
