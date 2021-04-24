import 'package:test/test.dart';
import 'package:wedding_app/utils/role_convert.dart';

void main() {

  test('UTCID01', () {
    String role = "";
    var result = convertRoleToDb(role);
    expect(result, "");
  });

  test('UTCID02', () {
    String role = "admin";
    var result = convertRoleToDb(role);
    expect(result, "wedding_admin");
  });

  test('UTCID03', () {
    String role = "Admin";
    var result = convertRoleToDb(role);
    expect(result, "wedding_admin");
  });

  test('UTCID04', () {
    String role = "user";
    var result = convertRoleToDb(role);
    expect(result, "user");
  });

  test('UTCID05', () {
    String role = "guest";
    var result = convertRoleToDb(role);
    expect(result, "guest");
  });

}