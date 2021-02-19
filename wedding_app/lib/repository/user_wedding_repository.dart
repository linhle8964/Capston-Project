import 'package:wedding_app/model/user_wedding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_app/model/wedding.dart';

abstract class UserWeddingRepository {
  Future<void> addUserToWedding(UserWedding userWedding);
  Future<void> createUserWedding(User user);
  Future<void> createUserWeddingByEmail(String email);
  Future<void> updateUserWedding(
      User user, Wedding wedding, String userWeddingId, String role);
  Future<void> removeUserFromWedding(String email, UserWedding userWedding);
  Stream<UserWedding> getWeddingByUser(String userId);
  Future<List<UserWedding>> getAllUserByWedding(String weddingId);
  Future<UserWedding> getUserWeddingByUser(User user);
  Future<UserWedding> getUserWeddingByEmail(String email);
  Future<void> addUserId(UserWedding userWedding, User user);
  Stream<List<UserWedding>> getAllUserWedding(String weddingId);
}
