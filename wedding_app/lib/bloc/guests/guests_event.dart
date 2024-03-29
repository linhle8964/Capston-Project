import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/guest.dart';

abstract class GuestsEvent extends Equatable{
  const GuestsEvent();

  @override
  List<Object> get props => [];
}

class LoadGuests extends GuestsEvent{
  String weddingId;

  LoadGuests(this.weddingId);

  @override
  List<Object> get props => [weddingId];
}

class SearchGuests extends GuestsEvent{}

class AddGuest extends GuestsEvent{
  final Guest guest;
  String weddingId;

  AddGuest(this.guest, this.weddingId);

  @override
  List<Object> get props => [guest];

  @override
  String toString() => 'AddGuest {guest: $guest}';
}

class UpdateGuest extends GuestsEvent{
  final Guest guest;
  String weddingId;

  UpdateGuest(this.guest, this.weddingId);

  @override
  List<Object> get props => [guest];

  @override
  String toString() => 'UpdateGuest {guest: $guest}';
}

class DeleteGuest extends GuestsEvent{
  final Guest guest;
  String weddingId;

  DeleteGuest(this.guest, this.weddingId);

  @override
  List<Object> get props => [guest];

  @override
  String toString() => 'DeleteGuest {guest: $guest}';
}

class ClearCompleted extends GuestsEvent{}

class ToggleAll extends GuestsEvent{
  final List<Guest> guests;

  ToggleAll(this.guests);

  @override
  List<Object> get props => [guests];
}
