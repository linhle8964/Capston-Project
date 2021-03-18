import 'package:flutter/material.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/screen/views/input_details/choose_to_come.dart';
import 'package:flutter_web_diary/screen/widgets/details_input/drop_down.dart';
import 'package:flutter_web_diary/screen/widgets/details_input/people_number_field.dart';
import 'package:flutter_web_diary/screen/widgets/details_input/submit_button.dart';
import 'package:flutter_web_diary/screen/widgets/details_input/text_field.dart';

class DetailsInput extends StatelessWidget {
  Guest guest;
  ValueChanged<bool> onTapped;
  DetailsInput({Key key, @required this.onTapped, @required this.guest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Bạn hãy điền những thông tin sau đây nhé",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
            SizedBox(height: 50,),
            TextFieldCustom(hintText: "Tên của bạn", maxlines: 1,initialText: guest.name,),
            SizedBox(height: 15,),
            ChooseToCome(guest: guest),
            SizedBox(height: 15,),
            TextFieldCustom(hintText: "Gửi lời chúc", maxlines: 7,initialText: guest.congrat,),
            SizedBox(height: 30,),
            SubmitButtonCustom(onTapped: onTapped,),
          ],
        ),
      ),
    );
  }
}
