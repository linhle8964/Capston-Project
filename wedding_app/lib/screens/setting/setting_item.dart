import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String url;
  final String text;
  SettingItem(this.url, this.text);
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
            child: FlatButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, url);
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
                color: Colors.white,
                child: Icon(Icons.arrow_forward_ios_sharp)),
          )
        ],
      )
          // Stack(
          //   alignment: AlignmentDirectional.centerEnd,
          //   children: <Widget>[
          //     SizedBox(
          //       width: double.infinity,
          //       height: 40,
          //       child: RaisedButton(
          //         color: Colors.white,
          //         onPressed: () {
          //           Navigator.pushNamed(context, url);
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
          //           child: Text(
          //             text,
          //             style: TextStyle(color: Colors.black, fontSize: 14),
          //           ),
          //         ),
          //       ),
          //     ),
          //     GestureDetector(
          //         onTap: null,
          //         child: Padding(
          //           padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          //           child: Icon(Icons.arrow_forward_ios_sharp),
          //         ))
          //   ],
          // ),
          ),
    );
  }
}
