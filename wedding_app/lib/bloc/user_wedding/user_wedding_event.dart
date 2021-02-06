import 'package:equatable/equatable.dart';

abstract class UserWeddingEvent extends Equatable {
  const UserWeddingEvent();
  @override
  List<Object> get props => [];
}

class LoadWeddingByUser extends UserWeddingEvent {
  final String userId;

  LoadWeddingByUser(this.userId);

  @override
  List<Object> get props => [userId];
}
