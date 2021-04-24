import 'package:test/test.dart';
import 'package:wedding_app/utils/get_information.dart';

void main() {

  test('UTCID01', (){
    var stt = -1;
    var result = getStatus(stt);
    expect(result, "Không tới");
  });

  test('UTCID02', (){
    var stt = 0;
    var result = getStatus(stt);
    expect(result, "Chưa trả lời");
  });

  test('UTCID03', (){
    var stt = 1;
    var result = getStatus(stt);
    expect(result, "Sẽ tới");
  });

  test('UTCID04', (){
    var stt = 2;
    var result = getStatus(stt);
    expect(result, "Không tới");
  });

  test('UTCID05', (){
    var stt = 3;
    var result = getStatus(stt);
    expect(result, "Không tới");
  });

}