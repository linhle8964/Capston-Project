import 'package:flutter_web_diary/model/wedding.dart';

abstract class WeddingRepository {
  Stream<Wedding> getWedding(String weddingId);
  Stream<List<Wedding>> getAllWedding();
  Future<Wedding> getWeddingById(String weddingId);
}
