import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CreateWeddingEvent extends Equatable {
  const CreateWeddingEvent();

  @override
  List<Object> get props => [];
}

class BrideNameChanged extends CreateWeddingEvent {
  final String brideName;

  const BrideNameChanged({this.brideName});

  @override
  List<Object> get props => [brideName];
}

class GroomNameChanged extends CreateWeddingEvent {
  final String groomName;

  const GroomNameChanged({this.groomName});

  @override
  List<Object> get props => [groomName];
}

class AddressChanged extends CreateWeddingEvent {
  final String address;

  const AddressChanged({this.address});

  @override
  List<Object> get props => [address];
}

class WeddingDateChanged extends CreateWeddingEvent {
  final DateTime weddingDate;

  const WeddingDateChanged({this.weddingDate});

  @override
  List<Object> get props => [weddingDate];
}
