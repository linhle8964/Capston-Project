import 'package:test/test.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/utils/check_existed_phone.dart';

void main() {

  Guest guest1 = new Guest("", "", 0, "0123123123", 0, 0, "", 0);
  Guest guest2 = new Guest("", "", 0, "0234234234", 0, 0, "", 0);
  Guest guest3 = new Guest("", "", 0, "0345345345", 0, 0, "", 0);

  String phone2 = "0234234234";
  String phone5 = "0567567567";

  test('UTCID01', (){
    List<Guest> guests = [];
    String phone = "";
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID02', (){
    List<Guest> guests = [];
    String phone = phone2;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID03', (){
    List<Guest> guests = [];
    String phone = phone5;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID04', (){
    List<Guest> guests = [];
    String phone = null;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID05', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    guests.add(guest3);
    String phone = "";
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID06', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    guests.add(guest3);
    String phone = phone2;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, true);
  });

  test('UTCID07', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    guests.add(guest3);
    String phone = phone5;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID08', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    guests.add(guest3);
    String phone = null;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID09', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest3);
    String phone = "";
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID10', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest3);
    String phone = phone2;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID11', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest3);
    String phone = phone5;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID12', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest3);
    String phone = null;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID13', (){
    List<Guest> guests;
    String phone = "";
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID14', (){
    List<Guest> guests;
    String phone = phone2;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID15', (){
    List<Guest> guests;
    String phone = phone5;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

  test('UTCID16', (){
    List<Guest> guests;
    String phone = null;
    var result = checkExistedPhoneToAdd(guests, phone);
    expect(result, false);
  });

}