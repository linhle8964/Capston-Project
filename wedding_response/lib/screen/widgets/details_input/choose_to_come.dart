import 'package:flutter/material.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/screen/widgets/details_input/drop_down.dart';
import 'package:flutter_web_diary/screen/widgets/details_input/people_number_field.dart';
import 'package:flutter_web_diary/util/globle_variable.dart';

class ChooseToCome extends StatefulWidget {
  Guest guest;
  ChooseToCome({Key key, @required this.guest}) : super(key: key);
  @override
  _ChooseToComeState createState() => _ChooseToComeState();
}

class _ChooseToComeState extends State<ChooseToCome> {

  @override
  void initState() {
    super.initState();
    status = widget.guest.status;
  }

  onChangeStatus(String val){
    setState(() {
      print("$status");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropDownCustom(initialValue:status,onTapped: onChangeStatus,),
        SizedBox(height: 15,),
        //if status = 1.0 -> disable text field
        // status = 2 --> enable text field
        if(status ==1)
          NumberInputIncrementDecrement(initial: widget.guest.companion),
      ],
    );
  }
}
