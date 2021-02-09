import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:flutter/services.dart";
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/create_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_app/utils/show_snackbar.dart';

class CreateWeddingPage extends StatefulWidget {
  final User user;

  CreateWeddingPage({Key key, @required this.user}) : super(key: key);

  @override
  _CreateWeddingPageState createState() => _CreateWeddingPageState();
}

class _CreateWeddingPageState extends State<CreateWeddingPage> {
  TextEditingController groomNameController = new TextEditingController();
  TextEditingController brideNameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController budgetController = new TextEditingController();

  bool isSubmitButtonEnabled(CreateWeddingState state) {
    return state.isFormValid;
  }

  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String _selectedDate = 'Chọn ngày: ';
  String _selectedTime = 'Chọn giờ: ';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: _selectedDate != 'Chọn ngày: '
          ? new DateFormat("dd-MM-yyyy").parse(_selectedDate)
          : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat('dd-MM-yyyy').format(d);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime != 'Chọn giờ: '
          ? new DateFormat("hh:mm").parse(_selectedTime)
          : DateTime.now()),
    );
    if (time != null)
      setState(() {
        _selectedTime = time.toString().substring(10, 15);
      });
  }

  @override
  void initState() {
    super.initState();
    groomNameController.addListener(_onGroomNameChanged);
    brideNameController.addListener(_onBrideNameChanged);
    addressController.addListener(_onAddressChanged);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      home: Scaffold(
        body: BlocListener(
            cubit: BlocProvider.of<WeddingBloc>(context),
            listener: (context, state) {
              if (state is Success) {
                FocusScope.of(context).unfocus();
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              } else if (state is Failed) {
                showSnackbar(context, "Có lỗi xảy ra", true);
              } else if (state is Loading) {
                showSnackbar(context, "Đang xử lý dữ liệu", false);
              }
            },
            child: BlocBuilder(
                cubit: BlocProvider.of<CreateWeddingBloc>(context),
                builder: (context, state) {
                  return Scaffold(
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
                            onPressed: () => _save(state)),
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "THÔNG TIN CỦA BẠN",
                              style: new TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  maxRadius: 70.0,
                                  minRadius: 15.0,
                                  backgroundImage:
                                      AssetImage('assets/puppy.jpg'),
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
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
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: groomNameController,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                ),
                                hintText: 'TÊN CHÚ RỂ',
                                errorText: !state.isGroomNameValid
                                    ? "Tên phải có tối thiểu 6 ký tự"
                                    : null,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: brideNameController,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                ),
                                errorText: !state.isBrideNameValid
                                    ? "Tên phải có tối thiểu 6 ký tự"
                                    : null,
                                hintText: 'TÊN CÔ DÂU',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
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
                                    _selectDate(context);
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
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: addressController,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                ),
                                errorText: !state.isAddressValid
                                    ? "Địa chỉ không được rỗng"
                                    : null,
                                hintText: 'ĐỊA CHỈ',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: budgetController,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                  ),
                                  hintText: 'SỐ TIỀN',
                                  suffixText: 'VND',
                                  suffixStyle:
                                      const TextStyle(color: Colors.black)),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (string) {
                                string =
                                    '${_formatNumber(string.replaceAll(',', ''))}';
                                budgetController.value = TextEditingValue(
                                  text: string,
                                  selection: TextSelection.collapsed(
                                      offset: string.length),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
      ),
    );
  }

  void _onBrideNameChanged() {
    BlocProvider.of<CreateWeddingBloc>(context)
        .add(BrideNameChanged(brideName: brideNameController.text));
  }

  void _onGroomNameChanged() {
    BlocProvider.of<CreateWeddingBloc>(context).add(
      GroomNameChanged(groomName: groomNameController.text),
    );
  }

  void _onAddressChanged() {
    BlocProvider.of<CreateWeddingBloc>(context)
        .add(AddressChanged(address: addressController.text));
  }

  void _save(CreateWeddingState state) {
    if (isSubmitButtonEnabled(state)) {
      String weddingDateStr = _selectedDate.trim() + " " + _selectedTime.trim();
      print(weddingDateStr);
      var parsedDate = new DateFormat("dd-MM-yyyy hh:mm").parse(weddingDateStr);
      Wedding wedding = new Wedding(
          groomNameController.text,
          brideNameController.text,
          parsedDate,
          "default",
          addressController.text,
          dateCreated: DateTime.now(),
          budget: double.parse(budgetController.text.replaceAll(",", "")),
          modifiedDate: DateTime.now());
      BlocProvider.of<WeddingBloc>(context)
          .add(CreateWedding(wedding, widget.user));
    } else {
      showSnackbar(context, "Hãy điền đầy đủ thông tin", true);
    }
  }
}
