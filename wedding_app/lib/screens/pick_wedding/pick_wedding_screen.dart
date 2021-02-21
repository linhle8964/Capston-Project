import 'package:flutter/material.dart';
import 'package:wedding_app/utils/hex_color.dart';

class PickWeddingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: hexToColor("#d86a77"),
        title: Text('Chọn đám cưới'),
      ),
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                      "Bạn chưa có đám cưới. Hãy chọn một trong hai lựa chọn dưới đây",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      textAlign: TextAlign.center),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    ButtonTheme(
                      minWidth: width / 2,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                          child: Text(
                            "Tạo đám cưới mới",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: hexToColor("#d86a77"),
                          onPressed: () =>
                              Navigator.pushNamed(context, "/create_wedding")),
                    ),
                    ButtonTheme(
                      minWidth: width / 2,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/wedding_code");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                        child: Text(
                          "Nhập mã mời ",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: hexToColor("#d86a77"),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
