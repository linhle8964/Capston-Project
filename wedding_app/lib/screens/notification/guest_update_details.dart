import 'package:flutter/material.dart';
import 'package:wedding_app/model/guest.dart';

class GuestDetailsPage extends StatelessWidget {
  Guest guest;
  GuestDetailsPage({Key key, @required this.guest})
      : super(key: key);
  Widget rowItem(String text1, String text2){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(text1,style: TextStyle(fontSize: 20),),
        ),
        Expanded(
          flex: 1,
          child: Text(text2,style: TextStyle(fontSize: 20),),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isRead = true;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text("${guest.name} đã phản hồi",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20,),
          rowItem("Họ tên ",guest.name ),
          SizedBox(height: 10,),
          rowItem("Di động ",guest.phone ),
          SizedBox(height: 10,),
          rowItem("Trạng thái ",guest.status ==1 ? "Sẽ tới" : guest.status == 2 ? "Không tới" : "Chưa xác định" ),
          SizedBox(height: 10,),
          rowItem("Số người ",guest.companion.toString()),
          SizedBox(height: 10,),
          rowItem("Khách nhà  ",guest.type == 1? "trai" : guest.type ==2 ? "gái" : "chưa xác định" ),
          SizedBox(height: 20,),
          Text(guest.congrat,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),)
        ],
      );
  }
}
