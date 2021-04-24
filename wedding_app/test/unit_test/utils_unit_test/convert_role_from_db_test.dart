import 'package:test/test.dart';
import 'package:wedding_app/utils/role_convert.dart';

void main() {

  test('UTCID01', () {
    String roleDb = "";
    var result = convertRoleFromDb(roleDb);
    expect(result, "");
  });

  test('UTCID02', () {
    String roleDb = "wedding_admin";
    var result = convertRoleFromDb(roleDb);
    expect(result, "Admin");
  });

  test('UTCID03', () {
    String roleDb = "Wedding_Admin";
    var result = convertRoleFromDb(roleDb);
    expect(result, "Admin");
  });

  test('UTCID04', () {
    String roleDb = "user";
    var result = convertRoleFromDb(roleDb);
    expect(result, "user");
  });

  test('UTCID05', () {
    String roleDb = "guest";
    var result = convertRoleFromDb(roleDb);
    expect(result, "guest");
  });

}