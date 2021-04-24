import 'package:test/test.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/utils/check_existed_phone.dart';

void main() {

  Guest guest1 = new Guest("", "", 0, "0123123123", 0, 0, "", 0);
  Guest guest2 = new Guest("", "", 0, "0234234234", 0, 0, "", 0);

  String phone1 = "0234234234";
  String phone2 = "0567567567";

  int index1 = 0;
  int index2 = 1;
  int index3 = 2;

  test('UTCID01', (){
    List<Guest> guests = [];
    String phone = "";
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID02', (){
    List<Guest> guests = [];
    String phone = phone1;
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID03', (){
    List<Guest> guests = [];
    String phone = null;
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID04', (){
    List<Guest> guests = [];
    guests.add(guest1);
    String phone = phone1;
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID05', (){
    List<Guest> guests = [];
    guests.add(guest1);
    String phone = phone1;
    int index = index2;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID06', (){
    List<Guest> guests = [];
    guests.add(guest2);
    String phone = phone1;
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID07', (){
    List<Guest> guests = [];
    guests.add(guest2);
    String phone = phone1;
    int index = index2;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, true);
  });

  test('UTCID08', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    String phone = phone1;
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, true);
  });

  test('UTCID09', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    String phone = phone1;
    int index = index2;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID10', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    String phone = phone1;
    int index = index3;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, true);
  });

  test('UTCID11', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    String phone = phone2;
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID12', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    String phone = phone2;
    int index = index2;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID13', (){
    List<Guest> guests;
    String phone = "";
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID14', (){
    List<Guest> guests;
    String phone = phone1;
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

  test('UTCID15', (){
    List<Guest> guests;
    String phone = phone2;
    int index = index1;
    var result = checkExistedPhoneToUpdate(guests, phone, index);
    expect(result, false);
  });

}