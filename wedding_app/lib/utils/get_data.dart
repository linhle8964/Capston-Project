import 'package:shared_preferences/shared_preferences.dart';

Future<String> getWeddingID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String weddingID = prefs.getString("wedding_id");
  return weddingID;
}
/*// notificationID: key
// "list_key"    : List<String> keys
Future<void> getKey() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.
}*/


