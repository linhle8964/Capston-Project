import 'package:test/test.dart';
import 'package:wedding_app/utils/get_information.dart';

void main() {

  test('UTCID01', (){
    var stt = -1;
    var result = getColor(stt);
    expect(result, "#ff9cee");
  });

  test('UTCID02', (){
    var stt = 0;
    var result = getColor(stt);
    expect(result, "#6eb5ff");
  });

  test('UTCID03', (){
    var stt = 1;
    var result = getColor(stt);
    expect(result, "#85e3ff");
  });

  test('UTCID04', (){
    var stt = 2;
    var result = getColor(stt);
    expect(result, "#ff9cee");
  });

  test('UTCID05', (){
    var stt = 3;
    var result = getColor(stt);
    expect(result, "#ff9cee");
  });

}