import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Getting {
  static Future<String> getWeddingID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("wedding_id");
  }


}