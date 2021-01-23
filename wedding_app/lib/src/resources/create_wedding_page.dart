import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/input_decorator.dart';
import 'package:wedding_app/src/blocs/createwedding_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import "package:flutter/services.dart";

class CreateWedding extends StatefulWidget {
  @override
  _CreateWeddingState createState() => _CreateWeddingState();
}

class _CreateWeddingState extends State<CreateWedding> {
  CreateWeddingBloc bloc = new CreateWeddingBloc();

  TextEditingController nameController = new TextEditingController();
  TextEditingController parterNameController = new TextEditingController();
  TextEditingController partnerEmailController = new TextEditingController();
  TextEditingController weddingNameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController budgetController = new TextEditingController();

  static const _locale = 'en';
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("TẠO ĐÁM CƯỚI"),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.check,
                size: 40,
                color: Colors.blue,
              ),
              onPressed: (){_save();},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child:
          Container(
              padding: EdgeInsets.all(7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "THÔNG TIN CỦA BẠN",
                    style: new TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        maxRadius: 70.0,
                        minRadius: 15.0,
                        backgroundImage: AssetImage('assets/puppy.jpg'),
                      ),
                      SizedBox(width: 30.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "THAY ĐỔI HÌNH ẢNH",
                            style: new TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.grey,
                            ),
                            //onPressed: _save(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  StreamBuilder(
                    stream: bloc.nameStream,
                    builder: (context,snapshot) =>TextField(
                      controller: nameController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        hintText: 'TÊN CỦA BẠN',
                        errorText: snapshot.hasError? snapshot.error: null,
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  RadioButtonHorizontal(),
                  SizedBox(height: 10,),
                  Text(
                    "NỬA KIA CỦA BẠN",
                    style: new TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 10,),
                  StreamBuilder(
                    stream: bloc.partnerNameStream,
                    builder: (context,snapshot) =>TextField(
                      controller: parterNameController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        errorText: snapshot.hasError? snapshot.error: null,
                        hintText: 'TÊN ĐẰNG ẤY',
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  RadioButtonHorizontal(),
                  SizedBox(height: 10,),
                  StreamBuilder(
                    stream: bloc.emailStream,
                    builder: (context,snapshot) =>TextField(
                      controller: partnerEmailController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        errorText: snapshot.hasError? snapshot.error: null,
                        hintText: "EMAIL CỦA ĐẰNG ẤY",
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 10,),
                  Text(
                    "ĐÁM CƯỚI",
                    style: new TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 10,),
                  StreamBuilder(
                    stream: bloc.weddingNameStream,
                    builder: (context,snapshot) =>TextField(
                      controller: weddingNameController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        errorText: snapshot.hasError? snapshot.error: null,
                        hintText: 'TÊM ĐÁM CƯỚI',
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        "NGÀY:",
                        style: new TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 70,
                          margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: DateTime.now(),
                              onDateTimeChanged: (DateTime newDateTime) {
                                // Do something
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 2.0, right: 0.0),
                        child: Text(
                          "THỜI GIAN:",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        margin: EdgeInsets.only(left: 10.0, top: 0.0, bottom: 5.0),
                        child: new TimePickerSpinner(
                          is24HourMode: true,
                          alignment: Alignment.centerLeft,
                          normalTextStyle: TextStyle(fontSize: 12, color: Colors.black),
                          highlightedTextStyle:
                          TextStyle(fontSize: 15, color: Colors.black),
                          spacing: 0,
                          itemHeight: 25,
                          isForce2Digits: true,
                          onTimeChange: (time) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  StreamBuilder(
                    stream: bloc.addressStream,
                    builder: (context,snapshot) =>TextField(
                      controller: addressController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        errorText: snapshot.hasError? snapshot.error: null,
                        hintText: 'ĐỊA CHỈ',
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: budgetController,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        hintText: 'SỐ TIỀN',
                        suffixText: 'VND',
                        suffixStyle: const TextStyle(color: Colors.black)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onChanged: (string) {
                      string = '${_formatNumber(string.replaceAll(',', ''))}';
                      budgetController.value = TextEditingValue(
                        text: string,
                        selection: TextSelection.collapsed(offset: string.length),
                      );
                    },
                  ),
                ],
              ),
          ),
        ),
      ),
    );
   // return ;
  }

  void _save() {
    setState(() {
      if(bloc.isNameValid(nameController.text, 5) && bloc.isPartnerNameValid(parterNameController.text, 5)
                && bloc.isEmailValid(partnerEmailController.text)
                && bloc.isWeddingNameValid(weddingNameController.text, 5)
                && bloc.isAddressValid(addressController.text, 5)){
        Fluttertoast.showToast(
            msg: "OKELA",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }
}

enum Gender { MALE, FEMALE, OTHER }

class RadioButtonHorizontal extends StatefulWidget {
  @override
  _RadioButtonHorizontalState createState() => _RadioButtonHorizontalState();
}

class _RadioButtonHorizontalState extends State<RadioButtonHorizontal> {
  Gender _genderValue = Gender.MALE;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton.icon(
          padding: EdgeInsets.all(0),
          label: Text(
            'NAM',
            style: new TextStyle(
              fontSize: 15.0,
            ),
          ),
          icon: Radio(
            value: Gender.MALE,
            groupValue: _genderValue,
            onChanged: (Gender value) {
              setState(() {
                _genderValue = value;
              });
            },
          ),
          onPressed: () {
            setState(() {
              _genderValue = Gender.MALE;
            });
          },
        ),
        FlatButton.icon(
          padding: EdgeInsets.all(0),
          label: Text(
            'NỮ',
            style: new TextStyle(
              fontSize: 15.0,
            ),
          ),
          icon: Radio(
            value: Gender.FEMALE,
            groupValue: _genderValue,
            onChanged: (Gender value) {
              setState(() {
                _genderValue = value;
              });
            },
          ),
          onPressed: () {
            setState(() {
              _genderValue = Gender.FEMALE;
            });
          },
        ),
        FlatButton.icon(
          padding: EdgeInsets.all(0),
          label: Text(
            'KHÁC',
            style: new TextStyle(
              fontSize: 15.0,
            ),
          ),
          icon: Radio(
            value: Gender.OTHER,
            groupValue: _genderValue,
            onChanged: (Gender value) {
              setState(() {
                _genderValue = value;
              });
            },
          ),
          onPressed: () {
            setState(() {
              _genderValue = Gender.OTHER;
            });
          },
        )
      ],
    );
  }
}
