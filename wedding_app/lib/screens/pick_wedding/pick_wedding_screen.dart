import 'package:flutter/material.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/screens/create_wedding/create_wedding_argument.dart';
import 'package:wedding_app/utils/hex_color.dart';

class PickWeddingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: hexToColor("#d86a77"),
        title: Text('Chọn đám cưới'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                    "Bạn chưa có đám cưới. Hãy chọn một trong hai lựa chọn dưới đây",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                height: height / 15,
              ),
              SizedBox(
                width: width / 2,
                child: ElevatedButton(
                    child: Text(
                      "Tạo đám cưới mới",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: hexToColor("#d86a77"),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, "/create_wedding", arguments: CreateWeddingArguments(isEditing: false, wedding: new Wedding("", "", DateTime.now(), "", "")))),
              ),
              SizedBox(
                width: width / 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/wedding_code");
                  },
                  style: ElevatedButton.styleFrom(
                    primary: hexToColor("#d86a77"),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                  ),
                  child: Text(
                    "Nhập mã mời ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
