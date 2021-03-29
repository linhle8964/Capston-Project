import 'package:shared_preferences/shared_preferences.dart';

Future<String> getWeddingID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String weddingID = prefs.getString("wedding_id");
  return weddingID;
}


