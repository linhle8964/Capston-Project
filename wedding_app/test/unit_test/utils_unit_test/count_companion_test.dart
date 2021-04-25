import 'package:test/test.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/utils/count_guest_item.dart';

void main() {

  Guest guest1 = new Guest("", "", 0, "", 0, 0, "", 0);
  Guest guest2 = new Guest("", "", 1, "", 0, 0, "", 0);
  Guest guest3 = new Guest("", "", 2, "", 0, 0, "", 0);
  Guest guest4 = new Guest("", "", 1, "", 0, 2, "", 0);
  Guest guest5 = new Guest("", "", 1, "", 0, 99, "", 0);
  Guest guest6 = new Guest("", "", 1, "", 0, -1, "", 0);

  test('UTCID01', (){
    List<Guest> guests = [];
    var result = countCompanion(guests);
    expect(result, "0");
  });

  test('UTCID02', (){
    List<Guest> guests = [];
    guests.add(guest1);
    var result = countCompanion(guests);
    expect(result, "0");
  });

  test('UTCID03', (){
    List<Guest> guests = [];
    guests.add(guest2);
    var result = countCompanion(guests);
    expect(result, "1");
  });

  test('UTCID04', (){
    List<Guest> guests = [];
    guests.add(guest3);
    var result = countCompanion(guests);
    expect(result, "0");
  });

  test('UTCID05', (){
    List<Guest> guests = [];
    guests.add(guest4);
    var result = countCompanion(guests);
    expect(result, "3");
  });

  test('UTCID06', (){
    List<Guest> guests = [];
    guests.add(guest5);
    var result = countCompanion(guests);
    expect(result, "100");
  });

  test('UTCID07', (){
    List<Guest> guests = [];
    guests.add(guest6);
    var result = countCompanion(guests);
    expect(result, "0");
  });

  test('UTCID08', (){
    List<Guest> guests;
    var result = countCompanion(guests);
    expect(result, "0");
  });

  test('UTCID09', (){
    List<Guest> guests = [];
    guests.add(guest2);
    guests.add(guest4);
    var result = countCompanion(guests);
    expect(result, "4");
  });

  test('UTCID10', (){
    List<Guest> guests = [];
    guests.add(guest2);
    guests.add(guest5);
    var result = countCompanion(guests);
    expect(result, "101");
  });

  test('UTCID11', (){
    List<Guest> guests = [];
    guests.add(guest2);
    guests.add(guest4);
    guests.add(guest5);
    var result = countCompanion(guests);
    expect(result, "104");
  });

  test('UTCID12', (){
    List<Guest> guests = [];
    guests.add(guest2);
    guests.add(guest6);
    var result = countCompanion(guests);
    expect(result, "1");
  });

  test('UTCID13', (){
    List<Guest> guests = [];
    guests.add(guest4);
    guests.add(guest6);
    var result = countCompanion(guests);
    expect(result, "3");
  });

  test('UTCID14', (){
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    guests.add(guest3);
    guests.add(guest4);
    guests.add(guest5);
    guests.add(guest6);
    var result = countCompanion(guests);
    expect(result, "104");
  });

}