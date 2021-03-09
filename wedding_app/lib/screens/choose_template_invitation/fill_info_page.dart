import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/wedding/wedding_bloc.dart';
import 'package:wedding_app/model/template_card.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'invitation_card_page.dart';
import 'package:intl/intl.dart';
class FillInfoPage extends StatefulWidget {
  final TemplateCard template;
  const FillInfoPage({Key key, @required this.template}): super (key: key);
  @override
  _FillInfoPageState createState() => _FillInfoPageState();
}

class _FillInfoPageState extends State<FillInfoPage> {
  TemplateCard get template => widget.template;
  TextEditingController _brideNameController = TextEditingController();
  TextEditingController _groomNameController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  var _errorMess = '';
  var _brideNameInvalid = false;
  var _groomNameInvalid = false;
  var _placeInvalid = false;
  var _dateTimeInvalid = false;
  String _noInputBrideName ='';
  String _noInputGroomName ='';
  String _noInputDateTime ='';
  String _noInputPlace ='';
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");


  @override
  Widget build(BuildContext context) {
    Wedding _wedding ;
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.black,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Text(
                  "Thông Tin Trên Thiệp",
                  style: TextStyle(color: Colors.grey),
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
                          BlocProvider.of<WeddingBloc>(context).add(
                              LoadWeddingByUser(state.user));

                          return BlocBuilder(
                            cubit: BlocProvider.of<WeddingBloc>(context),
                            builder: (context, state) {
                              if (state is WeddingLoaded) {
                                _noInputBrideName=state.wedding.brideName;
                                _noInputGroomName=state.wedding.groomName;
                                _noInputDateTime=dateFormat.format(state.wedding.weddingDate);
                                _noInputPlace=state.wedding.address;
                                return Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: TextField(
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                          controller: _brideNameController,
                                          decoration: InputDecoration(
                                              labelText: 'Tên Cô Dâu',
                                              hintText: state.wedding.brideName,
                                              errorText: _brideNameInvalid? _errorMess: null,
                                              labelStyle: TextStyle(
                                                  color: Colors.grey, fontSize: 15)),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: TextField(
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                          controller: _groomNameController,
                                          decoration: InputDecoration(
                                              labelText: 'Tên Chú Rể',
                                              hintText: state.wedding.groomName,
                                              errorText: _groomNameInvalid? _errorMess: null,
                                              labelStyle: TextStyle(
                                                  color: Colors.grey, fontSize: 15)),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: TextField(
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                          controller: _dateTimeController,
                                          decoration: InputDecoration(
                                              labelText: 'Thời gian ',
                                              hintText: dateFormat.format(state.wedding.weddingDate),
                                              errorText: _dateTimeInvalid? _errorMess: null,
                                              labelStyle: TextStyle(
                                                  color: Colors.grey, fontSize: 15)),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: TextField(
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                          controller: _placeController,
                                          decoration: InputDecoration(
                                              labelText: 'Địa điểm',
                                              hintText: state.wedding.address,
                                              errorText: _placeInvalid? _errorMess: null,
                                              labelStyle: TextStyle(
                                                  color: Colors.grey, fontSize: 15)),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: ElevatedButton(
                                        child: Text('Tạo thiệp mời'),
                                        onPressed: onSaveClick,
                                      ),
                                    ),
                                  ],
                                );
                              } else if (state is Loading) {
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
            )
        )));
  }
  void onSaveClick(){
    setState(() {
      final alpha = RegExp(r'^[^0-9\,!@#$%^&*()_+=-]+$');
      final alphanum = RegExp(r'^[^\,!@#$%^&*()_+=-]+$');
      final date = RegExp(r'^[^\,!@#$%^&*()_+=]+$');
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      if (_brideNameController.text.length > 32  ){
        _brideNameInvalid = true;
        _errorMess = 'Số lượng kí tự quá nhiều';
      }else if(_brideNameController.text.length < 2 && _brideNameController.text.length>0){
      _brideNameInvalid = true;
      _errorMess= 'Số lượng kí tự quá ngắn';
      }else if(!alpha.hasMatch(_brideNameController.text) && _brideNameController.text.length!=0){
        _brideNameInvalid = true;
        _errorMess= 'Tên người nhập không có số hay kí tự đặc biệt';
      }else if(template.name.endsWith('3') && _brideNameController.text.length>15){
        _brideNameInvalid = true;
        _errorMess= 'Mẫu thiệp mời không phù hợp với độ dài của tên';
      } else if(_brideNameController.text.length==0){
        _brideNameController.text =_noInputBrideName;
        _brideNameInvalid = false;
      }else{
        _brideNameInvalid = false;
      }

      if (_groomNameController.text.length > 32  ){
        _groomNameInvalid = true;
        _errorMess = 'Số lượng kí tự quá nhiều';
      }else if(_groomNameController.text.length < 2 && _groomNameController.text.length>0){
        _groomNameInvalid = true;
        _errorMess= 'Số lượng kí tự quá ngắn';
      }else if(!alpha.hasMatch(_groomNameController.text) && _groomNameController.text.length!=0){
        _groomNameInvalid = true;
        _errorMess= 'Tên người nhập không có số hay kí tự đặc biệt';
      }else if(template.name.endsWith('3') && _groomNameController.text.length>15){
        _groomNameInvalid = true;
        _errorMess= 'Mẫu thiệp mời không phù hợp với độ dài của tên';
      }else if(_groomNameController.text.length==0){
        _groomNameController.text =_noInputGroomName;
        _groomNameInvalid = false;
      } else {
        _groomNameInvalid = false;
      }

      if (_placeController.text.length > 32  ){
        _placeInvalid = true;
        _errorMess = 'Số lượng kí tự quá nhiều';
      }else if(_placeController.text.length < 2 && _placeController.text.length>0){
        _placeInvalid = true;
        _errorMess= 'Số lượng kí tự quá ngắn';
      }else if(!alphanum.hasMatch(_placeController.text) && _placeController.text.length!=0 ){
        _placeInvalid = true;
        _errorMess= 'Tên địa chỉ không có kí tự đặc biệt';
      }else if(_placeController.text.length==0){
        _placeController.text =_noInputPlace;
        _placeInvalid = false;
      }else {
        _placeInvalid = false;
      }

      if (_dateTimeController.text.length > 20  ){
        _dateTimeInvalid = true;
        _errorMess = 'Số lượng kí tự quá nhiều';
      }else if(_dateTimeController.text.length  < 20 && _dateTimeController.text.length>0){
        _dateTimeInvalid = true;
        _errorMess= 'Số lượng kí tự quá ngắn';
      }else if(!date.hasMatch(_dateTimeController.text) && _dateTimeController.text.length!=0 ){
        _dateTimeInvalid = true;
        _errorMess= 'Ngày tháng nhập không có chữ cái hay kí tự đặc biệt';
      }else if(_dateTimeController.text.length==0){
        _dateTimeController.text=_noInputDateTime;
        _dateTimeInvalid = false;
      }else {
        _dateTimeInvalid = false;
      }

      if(_brideNameInvalid == false && _groomNameInvalid == false && _placeInvalid == false && _dateTimeInvalid ==false){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InvitationCardPage(template:template,brideName: _brideNameController.text,groomName: _groomNameController.text,dateTime: _dateTimeController.text,place: _placeController.text,)),
        );
      }
    });
  }
}

