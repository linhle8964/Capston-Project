import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/screens/add_budget/addbudget.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main(){
  MockBuildContext _mockContext;
  test('Budget Name Valid',(){
   var result= BudgetNameValidate.budgetNameValidate(_mockContext, 'avb');
    expect(result, null);
  });
  test('Budget Name null',(){
    var result= BudgetNameValidate.budgetNameValidate(_mockContext, '');
    expect(result, "tên quy không thể chống");
  });
  test('Budget Name more than 20 length',(){
    var result= BudgetNameValidate.budgetNameValidate(_mockContext, 'abcqwe123asdasdasdasd');
    expect(result,"tên quỹ không thể quá 20 kí tự" );
  });
  test('Money Valid',(){
    var result= BudgetNameValidate.moneyValidate(_mockContext, '100,000');
    expect(result, null);
  });
  test('Money Invalid',(){
    expect(BudgetNameValidate.moneyValidate(_mockContext, '500'), "Tiền phải lớn hơn 1000 đồng");
  });
  test('Money Null',(){
    expect(BudgetNameValidate.moneyValidate(_mockContext, ''), "số tiền không thể chống");
  });
  test("Note Valid",(){
    expect(BudgetNameValidate.noteValidate(_mockContext,"chungtoidangtesttenchodu1000kitutrongphannotevadangkhongbietvietgoiasdandsngoaigolinh tinh cac thusadasdlkasd rat dai va ton thoi gian"),"Ghi chú không được quá 100 kí tự");
  });
}