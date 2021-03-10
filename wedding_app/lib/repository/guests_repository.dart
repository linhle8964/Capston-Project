import 'package:wedding_app/model/guest.dart';

abstract class GuestsRepository {
  Future<void> createGuest(Guest guest, String weddingId);
  Future<void> updateGuest(Guest guest, String weddingId);
  Stream<List<Guest>> readGuest(String weddingId);
  Future<void> deleteGuest(Guest guest, String weddingId);
}