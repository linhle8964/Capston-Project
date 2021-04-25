import 'package:wedding_app/model/guest.dart';

bool checkExistedPhoneToAdd(List<Guest> guests, String phone) {
  if(guests != null){
    for (int i = 0; i < guests.length; i++) {
      if (guests[i].phone == phone) return true;
    }
  }
  return false;
}

bool checkExistedPhoneToUpdate(List<Guest> guests, String phone, int index) {
  if(guests != null){
    for (int i = 0; i < guests.length; i++) {
      if (guests[i].phone == phone && i != index) return true;
    }
  }
  return false;
}