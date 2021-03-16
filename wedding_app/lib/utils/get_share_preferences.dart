import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding_app/entity/user_wedding_entity.dart';
import 'package:wedding_app/entity/wedding_entity.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/model/wedding.dart';
import 'dart:convert';

Future<UserWedding> getUserWedding() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map userWeddingMap = jsonDecode(prefs.getString("user_wedding"));
  return UserWedding.fromEntity(UserWeddingEntity.fromJson(userWeddingMap));
}

Future<String> getWeddingId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String role = prefs.getString("wedding_id");
  return role;
}

bool isAdmin(String role) {
  if (role == "wedding_admin") {
    return true;
  }
  return false;
}

Future<Wedding> getWeddingFromSharePreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map weddingMap = jsonDecode(prefs.getString("wedding"));
  return Wedding.fromEntity(WeddingEntity.fromJson(weddingMap));
}
