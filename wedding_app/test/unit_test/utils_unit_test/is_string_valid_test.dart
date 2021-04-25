import 'package:test/test.dart';
import 'package:wedding_app/utils/validations.dart';

void main() {

  String text1 = "short";
  String text2 = "longtexttest";

  test('UTCID01', () {
    String text = "";
    int length = 0;
    var result = Validation.isStringValid(text, length);
    expect(result, true);
  });

  test('UTCID02', () {
    String text = "";
    int length = 1;
    var result = Validation.isStringValid(text, length);
    expect(result, false);
  });

  test('UTCID03', () {
    String text = null;
    int length = 0;
    var result = Validation.isStringValid(text, length);
    expect(result, false);
  });

  test('UTCID04', () {
    String text = null;
    int length = 1;
    var result = Validation.isStringValid(text, length);
    expect(result, false);
  });

  test('UTCID05', () {
    String text = text1;
    int length = 0;
    var result = Validation.isStringValid(text, length);
    expect(result, true);
  });

  test('UTCID06', () {
    String text = text1;
    int length = 5;
    var result = Validation.isStringValid(text, length);
    expect(result, true);
  });

  test('UTCID07', () {
    String text = text1;
    int length = 6;
    var result = Validation.isStringValid(text, length);
    expect(result, false);
  });

  test('UTCID08', () {
    String text = text2;
    int length = 0;
    var result = Validation.isStringValid(text, length);
    expect(result, true);
  });

  test('UTCID09', () {
    String text = text2;
    int length = 5;
    var result = Validation.isStringValid(text, length);
    expect(result, true);
  });

  test('UTCID10', () {
    String text = text2;
    int length = 6;
    var result = Validation.isStringValid(text, length);
    expect(result, true);
  });

}