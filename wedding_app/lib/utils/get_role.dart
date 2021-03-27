import 'package:shared_preferences/shared_preferences.dart';

Future<String> getRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String role = prefs.getString("role");
  return role;
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