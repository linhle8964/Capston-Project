import 'package:test/test.dart';
import 'package:wedding_app/utils/validations.dart';

void main() {

  test('UTCID01', () {
    String password = "";
    var result = Validation.isPasswordValid(password);
    expect(result, false);
  });

  test('UTCID02', () {
    String password = "abc12";
    var result = Validation.isPasswordValid(password);
    expect(result, false);
  });

  test('UTCID03', () {
    String password = "abc123";
    var result = Validation.isPasswordValid(password);
    expect(result, true);
  });

  test('UTCID04', () {
    String password = "aaaaabbbbbccccc12345";
    var result = Validation.isPasswordValid(password);
    expect(result, true);
  });

  test('UTCID05', () {
    String password = "aaaaabbbbbccccc123456";
    var result = Validation.isPasswordValid(password);
    expect(result, false);
  });

  test('UTCID06', () {
    String password = "Abcdefg1234";
    var result = Validation.isPasswordValid(password);
    expect(result, true);
  });

  test('UTCID07', () {
    String password = "abcdef";
    var result = Validation.isPasswordValid(password);
    expect(result, false);
  });

  test('UTCID08', () {
    String password = null;
    var result = Validation.isPasswordValid(password);
    expect(result, false);
  });

}