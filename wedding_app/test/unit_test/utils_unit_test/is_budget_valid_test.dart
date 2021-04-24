import 'package:test/test.dart';
import 'package:wedding_app/utils/validations.dart';

void main() {

  test('UTCID01', () {
    String budget = "";
    var result = Validation.isBudgetValid(budget);
    expect(result, false);
  });

  test('UTCID02', () {
    String budget = "10,000";
    var result = Validation.isBudgetValid(budget);
    expect(result, false);
  });

  test('UTCID03', () {
    String budget = "100,000";
    var result = Validation.isBudgetValid(budget);
    expect(result, false);
  });

  test('UTCID04', () {
    String budget = "101,000";
    var result = Validation.isBudgetValid(budget);
    expect(result, true);
  });

  test('UTCID05', () {
    String budget = "200,000";
    var result = Validation.isBudgetValid(budget);
    expect(result, true);
  });

  test('UTCID06', () {
    String budget = "200,500";
    var result = Validation.isBudgetValid(budget);
    expect(result, false);
  });

  test('UTCID07', () {
    String budget = null;
    var result = Validation.isBudgetValid(budget);
    expect(result, false);
  });

}