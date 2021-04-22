import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final Function function;
  final String text;
  SettingItem(this.function, this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 9,
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {
                function.call();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                child: IconButton(icon: Icon(Icons.arrow_forward_ios_sharp), onPressed: () => function.call(),),),
          )
        ],
      )
          ),
    );
  }
}
