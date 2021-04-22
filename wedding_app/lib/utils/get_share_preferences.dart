import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding_app/const/share_prefs_key.dart';
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

Future<Map> getNotificationSettings() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool taskNotification = prefs.getBool(SharedPreferenceKey.taskNotification);
  bool guestResponseNotification = prefs.get(SharedPreferenceKey.guestResponseNotification);
  var mapNotifications = new Map();
  mapNotifications[SharedPreferenceKey.taskNotification] = taskNotification;
  mapNotifications[SharedPreferenceKey.guestResponseNotification] = guestResponseNotification;
  return mapNotifications;
}

Future<void> changeNotification(String key) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool notification = prefs.getBool(key);
  prefs.setBool(key, !notification);
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
