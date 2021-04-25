import 'package:test/test.dart';
import 'package:wedding_app/utils/validations.dart';

void main(){

  test('UTCID01', () {
    String email = "";
    var result = Validation.isEmailValid(email);
    expect(result, false);
  });

  test('UTCID02', () {
    String email = "mysite@ourearth.com";
    var result = Validation.isEmailValid(email);
    expect(result, true);
  });

  test('UTCID03', () {
    String email = "my.ownsite@ourearth.org";
    var result = Validation.isEmailValid(email);
    expect(result, true);
  });

  test('UTCID04', () {
    String email = "mysite@you.me.net";
    var result = Validation.isEmailValid(email);
    expect(result, true);
  });

  test('UTCID05', () {
    String email = "mysite.ourearth.com";
    var result = Validation.isEmailValid(email);
    expect(result, false);
  });

  test('UTCID06', () {
    String email = "mysite@.com.my";
    var result = Validation.isEmailValid(email);
    expect(result, false);
  });

  test('UTCID07', () {
    String email = "@you.me.net";
    var result = Validation.isEmailValid(email);
    expect(result, false);
  });

  test('UTCID08', () {
    String email = "mysite123@gmail.b";
    var result = Validation.isEmailValid(email);
    expect(result, false);
  });

  test('UTCID09', () {
    String email = ".mysite@mysite.org";
    var result = Validation.isEmailValid(email);
    expect(result, false);
  });

  test('UTCID10', () {
    String email = "mysite()*@gmail.com";
    var result = Validation.isEmailValid(email);
    expect(result, false);
  });

  test('UTCID11', () {
    String email = "mysite..1234@yahoo.com";
    var result = Validation.isEmailValid(email);
    expect(result, false);
  });

  test('UTCID12', () {
    String email = null;
    var result = Validation.isEmailValid(email);
    expect(result, false);
  });

}