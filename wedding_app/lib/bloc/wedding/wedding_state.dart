import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/wedding.dart';

abstract class WeddingState extends Equatable {
  const WeddingState();

  @override
  List<Object> get props => [];
}

class WeddingLoading extends WeddingState {
  final String message;

  const WeddingLoading(this.message);

  @override
  List<Object> get props => [message];
}

class DeleteSuccess extends WeddingState{

}
class WeddingLoaded extends WeddingState {
  final Wedding wedding;
  final String message;

  const WeddingLoaded([this.wedding, this.message]);

  @override
  List<Object> get props => [wedding, message];
}

class WeddingNotLoaded extends WeddingState {}

class Failed extends WeddingState {
  final String message;

  const Failed(this.message);

  @override
  List<Object> get props => [message];
}

