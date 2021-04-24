import 'package:test/test.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/utils/count_home_item.dart';

void main() {

  Guest guest1 = new Guest("", "", 0, "", 0, 0, "", 0);
  Guest guest2 = new Guest("", "", 1, "", 0, 0, "", 0);
  Guest guest3 = new Guest("", "", 2, "", 0, 0, "", 0);
  Guest guest4 = new Guest("", "", 1, "", 0, 0, "", 0);

  test('UTCID01', () {
    List<Guest> guests = [];
    var result = countConfirmedGuest(guests);
    expect(result, 0);
  });

  test('UTCID02', () {
    List<Guest> guests;
    var result = countConfirmedGuest(guests);
    expect(result, 0);
  });

  test('UTCID03', () {
    List<Guest> guests = [];
    guests.add(guest1);
    var result = countConfirmedGuest(guests);
    expect(result, 0);
  });

  test('UTCID04', () {
    List<Guest> guests = [];
    guests.add(guest2);
    var result = countConfirmedGuest(guests);
    expect(result, 1);
  });

  test('UTCID05', () {
    List<Guest> guests = [];
    guests.add(guest3);
    var result = countConfirmedGuest(guests);
    expect(result, 0);
  });

  test('UTCID06', () {
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    var result = countConfirmedGuest(guests);
    expect(result, 1);
  });

  test('UTCID07', () {
    List<Guest> guests = [];
    guests.add(guest3);
    guests.add(guest4);
    var result = countConfirmedGuest(guests);
    expect(result, 1);
  });

  test('UTCID08', () {
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    guests.add(guest3);
    var result = countConfirmedGuest(guests);
    expect(result, 1);
  });

  test('UTCID09', () {
    List<Guest> guests = [];
    guests.add(guest2);
    guests.add(guest3);
    guests.add(guest4);
    var result = countConfirmedGuest(guests);
    expect(result, 2);
  });

  test('UTCID10', () {
    List<Guest> guests = [];
    guests.add(guest1);
    guests.add(guest2);
    guests.add(guest3);
    guests.add(guest4);
    var result = countConfirmedGuest(guests);
    expect(result, 2);
  });

}