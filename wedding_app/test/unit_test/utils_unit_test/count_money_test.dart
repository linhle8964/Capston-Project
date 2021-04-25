import 'package:test/test.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/utils/count_guest_item.dart';

void main() {

  Guest guest1 = new Guest("", "", 0, "", 0, 0, "", 0);
  Guest guest2 = new Guest("", "", 0, "", 0, 0, "", 200);
  Guest guest3 = new Guest("", "", 0, "", 0, 0, "", 9999999);
  Guest guest4 = new Guest("", "", 0, "", 0, 0, "", -100);

  test('UTCID01', (){
    List<Guest> guests = [];
    var result = countMoney(guests);
    expect(result, "0000");
  });

  test('UTCID02', (){
    List<Guest> guests = [];
    guests.add(guest1);
    var result = countMoney(guests);
    expect(result, "0000");
  });

  test('UTCID03', (){
    List<Guest> guests = [];
    guests.add(guest2);
    var result = countMoney(guests);
    expect(result, "200000");
  });

  test('UTCID04', (){
    List<Guest> guests = [];
    guests.add(guest3);
    var result = countMoney(guests);
    expect(result, "9999999000");
  });

  test('UTCID05', (){
    List<Guest> guests = [];
    guests.add(guest4);
    var result = countMoney(guests);
    expect(result, "0000");
  });

  test('UTCID06', (){
    List<Guest> guests;
    var result = countMoney(guests);
    expect(result, "0000");
  });

  test('UTCID07', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    var result = countMoney(guests);
    expect(result, "200000");
  });

  test('UTCID08', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest3);
    var result = countMoney(guests);
    expect(result, "9999999000");
  });

  test('UTCID09', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    guests.add(guest3);
    var result = countMoney(guests);
    expect(result, "10000199000");
  });

  test('UTCID10', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest4);
    var result = countMoney(guests);
    expect(result, "0000");
  });

  test('UTCID11', (){
    List<Guest> guests = [];
    guests.add(guest2);
    guests.add(guest4);
    var result = countMoney(guests);
    expect(result, "200000");
  });

  test('UTCID12', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    guests.add(guest3);
    guests.add(guest4);
    var result = countMoney(guests);
    expect(result, "10000199000");
  });

}