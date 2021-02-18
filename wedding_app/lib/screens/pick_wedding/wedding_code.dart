import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/utils/hex_color.dart';

class WeddingCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: hexToColor("#d86a77"),
        title: Text('Nhập mã mời'),
      ),
      body: SizedBox.expand(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width / 3,
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                decoration: InputDecoration(
                    hintText: 'Nhập mã mời',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 20)),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            ButtonTheme(
                minWidth: width / 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                child: RaisedButton(
                    child: Text("Gửi mã",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    color: hexToColor("#d86a77"),
                    onPressed: () {}))
          ],
        ),
      )),
    );
  }
}
