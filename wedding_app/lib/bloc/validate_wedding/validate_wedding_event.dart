import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ValidateWeddingEvent extends Equatable {
  const ValidateWeddingEvent();

  @override
  List<Object> get props => [];
}

class BrideNameChanged extends ValidateWeddingEvent {
  final String brideName;

  const BrideNameChanged({this.brideName});

  @override
  List<Object> get props => [brideName];
}

class GroomNameChanged extends ValidateWeddingEvent {
  final String groomName;

  const GroomNameChanged({this.groomName});

  @override
  List<Object> get props => [groomName];
}

class AddressChanged extends ValidateWeddingEvent {
  final String address;

  const AddressChanged({this.address});

  @override
  List<Object> get props => [address];
}

class WeddingDateChanged extends ValidateWeddingEvent {
  final DateTime weddingDate;

  const WeddingDateChanged({this.weddingDate});

  @override
  List<Object> get props => [weddingDate];
}
