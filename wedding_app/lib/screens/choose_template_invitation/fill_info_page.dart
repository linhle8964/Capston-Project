import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/wedding/wedding_bloc.dart';
import 'package:wedding_app/model/template_card.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'invitation_card_page.dart';
import 'package:intl/intl.dart';
import 'package:wedding_app/utils/vietnam_parser.dart';
class FillInfoPage extends StatefulWidget {
  final TemplateCard template;
  const FillInfoPage({Key key, @required this.template}) : super(key: key);
  @override
  _FillInfoPageState createState() => _FillInfoPageState();
}

class _FillInfoPageState extends State<FillInfoPage> {
  TemplateCard get template => widget.template;
  TextEditingController _brideNameController = TextEditingController();
  TextEditingController _groomNameController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  var _errorMessbride = '';
  var _errorMessgroom = '';
  var _errorMessplace = '';
  var _brideNameInvalid = false;
  var _groomNameInvalid = false;
  var _placeInvalid = false;
  var _dateTimeInvalid = false;
  String _noInputBrideName = '';
  String _noInputGroomName = '';
  String _noInputDate = '';
  String _noInputTime = '';
  String _noInputPlace = '';
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  DateFormat timeFormat = DateFormat("hh:mm");
  String _selectedDate = 'Chọn ngày: ';
  String _selectedTime = 'Chọn giờ: ';
  bool _isClickDate = false;
  bool _isClickTime = false;
  _selectDate(BuildContext context, DateTime selectedDate) async {
    print(selectedDate);
    String a = dateFormat.format(selectedDate);

    final DateTime d = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year - 3),
        lastDate: DateTime(DateTime.now().year + 3),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: hexToColor("#d86a77"),
              ),
            ),
            child: child,
          );
        });
    if (d != null) {
      setState(() {
        _selectedDate = dateFormat.format(d);
        _isClickDate = true;
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedTime != 'Chọn giờ: '
            ? new DateFormat("hh:mm").parse(_selectedTime)
            : DateTime.now()),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: hexToColor("#d86a77"),
              ),
            ),
            child: child,
          );
        });
    if (time != null)
      setState(() {
        _selectedTime = time.toString().substring(10, 15);
        _isClickTime = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: hexToColor("#d86a77"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(
              "Thông Tin Trên Thiệp",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
          child: Center(
            child: BlocBuilder(
              cubit: BlocProvider.of<AuthenticationBloc>(context),
              builder: (context, state) {
                if (state is Uninitialized) {
                  return LoadingIndicator();
                } else if (state is Authenticated) {
                  BlocProvider.of<WeddingBloc>(context)
                      .add(LoadWeddingByUser(state.user));

                  return BlocBuilder(
                    cubit: BlocProvider.of<WeddingBloc>(context),
                    builder: (context, state) {
                      if (state is WeddingLoaded) {
                        _noInputBrideName = state.wedding.brideName;
                        _noInputGroomName = state.wedding.groomName;
                        _noInputDate =
                            dateFormat.format(state.wedding.weddingDate);
                        _noInputTime =
                            timeFormat.format(state.wedding.weddingDate);
                        _noInputPlace = state.wedding.address;
                        if (_isClickDate == false) {
                          _selectedDate = _noInputDate;
                        }
                        if (_isClickTime == false) {
                          _selectedTime = _noInputTime;
                        }

                        return Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  controller: _brideNameController,
                                  validator: BrideNameValidator.validate,
                                  decoration: InputDecoration(
                                      labelText: 'Tên Cô Dâu',
                                      hintText: state.wedding.brideName,
                                       errorText:
                                          _brideNameInvalid ? _errorMessbride : null,
                                      labelStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                )),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  controller: _groomNameController,
                                  validator: GroomNameValidator.validate,
                                  decoration: InputDecoration(
                                      labelText: 'Tên Chú Rể',
                                      hintText: state.wedding.groomName,
                                      errorText:
                                          _groomNameInvalid ? _errorMessgroom : null,
                                      labelStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  _selectedDate,
                                  style: new TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  tooltip: 'Tap to open date picker',
                                  onPressed: () {
                                    _selectDate(
                                        context, state.wedding.weddingDate);
                                  },
                                ),
                                Text(
                                  _selectedTime,
                                  style: new TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.access_time_outlined),
                                  tooltip: 'Tap to open time picker',
                                  onPressed: () {
                                    _selectTime(context);
                                  },
                                ),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  controller: _placeController,
                                  validator: PlaceValidator.validate,
                                  decoration: InputDecoration(
                                      labelText: 'Địa điểm',
                                      hintText: state.wedding.address,
                                      errorText:
                                          _placeInvalid ? _errorMessplace : null,
                                      labelStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: TextButton(
                                style: TextButton.styleFrom(backgroundColor: hexToColor("#d86a77")),
                                child: Text('Tạo thiệp mời',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: onSaveClick,
                              ),
                            ),
                          ],
                        );
                      } else if (state is WeddingLoading) {
                        return LoadingIndicator();
                      } else if (state is Failed) {}
                      return LoadingIndicator();
                    },
                  );
                }
                return LoadingIndicator();
              },
            ),
          ),
        )));
  }

  void onSaveClick() {
    setState(() {
      final alpha = RegExp(r'^[^0-9\,!@#$%^&*()_+=-]+$');
      final alphanum = RegExp(r'^[^\,!@#$%^&*()_+=-]+$');
      String brideName=VietnameseParserEngine.unsigned(_brideNameController.text);
      String groomName=VietnameseParserEngine.unsigned(_groomNameController.text);
       String place=VietnameseParserEngine.unsigned(_placeController.text);
      if (brideName.length > 20) {
        _brideNameInvalid = true;
        _errorMessbride= 'Giới hạn tên cô dâu là từ 2 đến 20 kí tự';
      } else if (brideName.length < 2 &&
          brideName.length > 0) {
        _brideNameInvalid = true;
        _errorMessbride= 'Giới hạn tên cô dâu là từ 2 đến 20 kí tự';
      } else if (!alpha.hasMatch(brideName) &&
          brideName.length != 0) {
        _brideNameInvalid = true;
        _errorMessbride= 'Tên cô dâu không được chứa số hay kí tự đặc biệt';
      } else if (brideName.length == 0) {
        _brideNameController.text = _noInputBrideName;
        _brideNameInvalid = false;
      } else {
        _brideNameInvalid = false;
      }

      if (groomName.length > 20) {
        _groomNameInvalid = true;
        _errorMessgroom= 'Giới hạn tên chú rể là từ 2 đến 20 kí tự';
      } else if (groomName.length < 2 &&
          groomName.length > 0) {
        _groomNameInvalid = true;
        _errorMessgroom= 'Giới hạn tên chú rể là từ 2 đến 20 kí tự';
      } else if (!alpha.hasMatch(groomName) &&
          groomName.length != 0) {
        _groomNameInvalid = true;
        _errorMessgroom= 'Tên chú rể không được chứa số hay kí tự đặc biệt';
      } else if (groomName.length == 0) {
        _groomNameController.text = _noInputGroomName;
        _groomNameInvalid = false;
      } else {
        _groomNameInvalid = false;
      }

      if (place.length > 40) {
        _placeInvalid = true;
        _errorMessplace= 'Giới hạn địa điểm là từ 6 đến 40 kí tự';
      } else if (place.length < 6 && place.length > 0) {
        _placeInvalid = true;
        _errorMessplace= 'Giới hạn địa điểm là từ 6 đến 40 kí tự';
      }  else if (place.length == 0) {
        _placeController.text = _noInputPlace;
        _placeInvalid = false;
      } else {
        _placeInvalid = false;
      }
      String dateTime = '';
      if (_isClickDate == true && _isClickTime == false) {
        dateTime = _selectedDate + ' ' + _noInputTime;
      } else if (_isClickDate == false && _isClickTime == true) {
        dateTime = _noInputDate + ' ' + _selectedTime;
      } else if (_isClickDate == false && _isClickTime == false) {
        dateTime = _noInputDate + ' ' + _noInputTime;
      } else {
        dateTime = _selectedDate + ' ' + _selectedTime;
      }

      if (_brideNameInvalid == false &&
          _groomNameInvalid == false &&
          _placeInvalid == false) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => InvitationCardPage(
                    template: template,
                    brideName: _brideNameController.text,
                    groomName: _groomNameController.text,
                    dateTime: dateTime,
                    place: _placeController.text,
                  )),
        );
      }
    });
  }
}
class BrideNameValidator{
  static String validate(String value){
    String brideName=VietnameseParserEngine.unsigned(value);
     final alpha = RegExp(r'^[^0-9\,!@#$%^&*()_+=-]+$');
    if (brideName.length > 20) {
        return 'Số lượng kí tự quá 20 kí tự';
    } else if (brideName.length < 2 && brideName.length > 0) {
        return  'Số lượng kí tự ít hơn 2 kí tự';
      } else if (!alpha.hasMatch(brideName) && brideName.length != 0) {
        return  'Tên người nhập không có số hay kí tự đặc biệt';
      } else if (brideName.length == 0) {
        return null;
      } else {
        return null;
      }
  }
}
class GroomNameValidator{
  static String validate(String value){
     final alpha = RegExp(r'^[^0-9\,!@#$%^&*()_+=-]+$');
     String groomName=VietnameseParserEngine.unsigned(value);
    if (groomName.length > 20) {
        return 'Số lượng kí tự quá 20 kí tự';
    } else if (groomName.length < 2 && groomName.length > 0) {
        return  'Số lượng kí tự ít hơn 2 kí tự';
      } else if (!alpha.hasMatch(groomName) && groomName.length != 0) {
        return  'Tên người nhập không có số hay kí tự đặc biệt';
      } else if (groomName.length == 0) {
        return null;
      } else {
        return null;
      }
  }
}

class PlaceValidator{
  static String validate(String value){
    String place=VietnameseParserEngine.unsigned(value);
     final alphanum = RegExp(r'^[^\,!@#$%^&*()_+=-]+$');
    if (place.length > 40) {
        return  'Số lượng kí tự quá 40 kí tự';
      } else if (place.length < 6 && place.length > 0) {
        
        return  'Số lượng kí tự ít hơn 6 kí tự';
      
      } else if (place.length == 0) {
        return  null;
      } else {
        return null;
      }
  }
}