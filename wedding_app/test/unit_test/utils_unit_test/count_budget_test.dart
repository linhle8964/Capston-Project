import 'package:test/test.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/utils/count_home_item.dart';

void main() {

  Budget budget1 = new Budget("", "", false, 0, 0, 0);
  Budget budget2 = new Budget("", "", false, 200, 0, 0);
  Budget budget3 = new Budget("", "", false, 1000, 0, 0);
  Budget budget4 = new Budget("", "", false, -100, 0, 0);

  test('UTCID01', (){
    List<Budget> budgets = [];
    var result = countBudget(budgets);
    expect(result, 0);
  });

  test('UTCID02', (){
    List<Budget> budgets = [];
    budgets.add(budget1);
    var result = countBudget(budgets);
    expect(result, 0);
  });

  test('UTCID03', (){
    List<Budget> budgets = [];
    budgets.add(budget2);
    var result = countBudget(budgets);
    expect(result, 200);
  });

  test('UTCID04', (){
    List<Budget> budgets = [];
    budgets.add(budget3);
    var result = countBudget(budgets);
    expect(result, 1000);
  });

  test('UTCID05', (){
    List<Budget> budgets = [];
    budgets.add(budget4);
    var result = countBudget(budgets);
    expect(result, 0);
  });

  test('UTCID06', (){
    List<Budget> budgets;
    var result = countBudget(budgets);
    expect(result, 0);
  });

  test('UTCID07', (){
    List<Budget> budgets = [];
    budgets.add(budget1);
    budgets.add(budget2);
    var result = countBudget(budgets);
    expect(result, 200);
  });

  test('UTCID08', (){
    List<Budget> budgets = [];
    budgets.add(budget1);
    budgets.add(budget4);
    var result = countBudget(budgets);
    expect(result, 0);
  });

  test('UTCID09', (){
    List<Budget> budgets = [];
    budgets.add(budget3);
    budgets.add(budget4);
    var result = countBudget(budgets);
    expect(result, 1000);
  });

  test('UTCID10', (){
    List<Budget> budgets = [];
    budgets.add(budget1);
    budgets.add(budget2);
    budgets.add(budget3);
    budgets.add(budget4);
    var result = countBudget(budgets);
    expect(result, 1200);
  });

}