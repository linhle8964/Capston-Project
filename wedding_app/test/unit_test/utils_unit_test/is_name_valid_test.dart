import 'package:test/test.dart';
import 'package:wedding_app/utils/validations.dart';

void main(){

  test('UTCID01', () {
    String name = "";
    var result = Validation.isNameValid(name);
    expect(result, false);
  });

  test('UTCID02', () {
    String name = "a";
    var result = Validation.isNameValid(name);
    expect(result, true);
  });

  test('UTCID03', () {
    String name = "twentywordstestttttt";
    var result = Validation.isNameValid(name);
    expect(result, true);
  });

  test('UTCID04', () {
    String name = "normaltext";
    var result = Validation.isNameValid(name);
    expect(result, true);
  });

  test('UTCID05', () {
    String name = "twentyonewordstestttt";
    var result = Validation.isNameValid(name);
    expect(result, false);
  });

  test('UTCID06', () {
    String name = "longtexttttttttttttttttttttttttttttttttt";
    var result = Validation.isNameValid(name);
    expect(result, false);
  });

  test('UTCID07', () {
    String name = "abc@gmail.com";
    var result = Validation.isNameValid(name);
    expect(result, false);
  });

  test('UTCID08', () {
    String name = "#ff00ff";
    var result = Validation.isNameValid(name);
    expect(result, false);
  });

  test('UTCID09', () {
    String name = null;
    var result = Validation.isNameValid(name);
    expect(result, false);
  });

}