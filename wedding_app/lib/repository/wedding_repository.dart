import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/model/wedding.dart';

abstract class WeddingRepository {
  Future<void> createWedding(Wedding wedding, String userId);
  Future<void> updateWedding(Wedding wedding);
  Stream<Wedding> getWedding(String weddingId);
  Future<void> deleteWedding(
      Wedding wedding, List<UserWedding> listUserWedding);
  Stream<List<Wedding>> getAllWedding();
  Future<Wedding> getWeddingById(String weddingId);
}
