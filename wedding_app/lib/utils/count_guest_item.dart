import 'package:wedding_app/model/guest.dart';

String countMoney(List<Guest> guests) {
  int count = 0;
  if(guests != null){
    for (int i = 0; i < guests.length; i++) {
      if (guests[i].money > 0) {
        count += guests[i].money;
      }
    }
  }
  return count.toString() + "000";
}

String countCompanion(List<Guest> guests) {
  int count = 0;
  if(guests != null){
    for (int i = 0; i < guests.length; i++) {
      if (guests[i].status == 1) {
        count++;
        count += guests[i].companion;
      }
    }
  }
  return count.toString();
}