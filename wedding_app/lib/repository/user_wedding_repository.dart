import 'package:wedding_app/model/user_wedding.dart';

abstract class UserWeddingRepository {
  Future<void> addUserToWedding(String email, UserWedding userWedding);
  Future<void> removeUserFromWedding(String email, UserWedding userWedding);
  Stream<UserWedding> getWeddingByUser(String userId);
  Future<UserWedding> getUserWedding(String userid);
}
