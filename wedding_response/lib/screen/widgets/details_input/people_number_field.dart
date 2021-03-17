import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_diary/bloc/guests/guests_bloc.dart';
import 'package:flutter_web_diary/bloc/guests/guests_state.dart';
import 'package:flutter_web_diary/screen/views/home/home_view.dart';

class NumberInputWithIncrementDecrement extends StatefulWidget {
  String initialValue;
  NumberInputWithIncrementDecrement({Key key, @required this.initialValue})
      : super(key: key);

  @override
  _NumberInputWithIncrementDecrementState createState() =>
      _NumberInputWithIncrementDecrementState();
}

class _NumberInputWithIncrementDecrementState
    extends State<NumberInputWithIncrementDecrement> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
   // Setting the initial value for the field.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextFormField(
                  //enabled: widget.isEnable,
                  //textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Số người đi cùng",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white60,
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey),
                    ),
                  ),
                  //controller: _controller,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),
            ],
          ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5),
        ),
      );
  }
}