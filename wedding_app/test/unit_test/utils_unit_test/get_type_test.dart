import 'package:test/test.dart';
import 'package:wedding_app/utils/get_information.dart';

void main() {

  test('UTCID01', (){
    var type = -1;
    var result = getType(type);
    expect(result, "Nhà gái");
  });

  test('UTCID02', (){
    var type = 0;
    var result = getType(type);
    expect(result, "Chưa sắp xếp");
  });

  test('UTCID03', (){
    var type = 1;
    var result = getType(type);
    expect(result, "Nhà trai");
  });

  test('UTCID04', (){
    var type = 2;
    var result = getType(type);
    expect(result, "Nhà gái");
  });

  test('UTCID05', (){
    var type = 3;
    var result = getType(type);
    expect(result, "Nhà gái");
  });

}