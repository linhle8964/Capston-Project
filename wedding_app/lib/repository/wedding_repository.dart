import 'package:wedding_app/model/wedding.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class WeddingRepository {
  Future<void> createWedding(Wedding wedding, User user);
  Future<void> updateWedding(Wedding wedding);
  Stream<Wedding> getWedding(String weddingId);
  Future<void> deleteWedding(String weddingId);
  Stream<List<Wedding>> getAllWedding();
  Future<Wedding> getWeddingById(String weddingId);
}
