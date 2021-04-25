import 'package:test/test.dart';
import 'package:wedding_app/utils/validations.dart';

void main(){

  test('UTCID01', () {
    String address = "";
    var result = Validation.isAddressValid(address);
    expect(result, false);
  });

  test('UTCID02', () {
    String address = "a";
    var result = Validation.isAddressValid(address);
    expect(result, false);
  });

  test('UTCID03', () {
    String address = "Ha Noi";
    var result = Validation.isAddressValid(address);
    expect(result, true);
  });

  test('UTCID04', () {
    String address = "Ha Noi @";
    var result = Validation.isAddressValid(address);
    expect(result, false);
  });

  test('UTCID05', () {
    String address = "123 Ha Noi";
    var result = Validation.isAddressValid(address);
    expect(result, true);
  });

  test('UTCID06', () {
    String address = null;
    var result = Validation.isAddressValid(address);
    expect(result, false);
  });

}