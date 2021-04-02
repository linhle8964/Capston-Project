import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:flutter/services.dart";
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/validate_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/utils/alert_dialog.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';

class CreateWeddingPage extends StatefulWidget {
  final bool isEditing;
  final Wedding wedding;

  CreateWeddingPage({
    Key key,
    @required this.isEditing,
    this.wedding,
  }) : super(key: key);
  @override
  _CreateWeddingPageState createState() => _CreateWeddingPageState();
}

class _CreateWeddingPageState extends State<CreateWeddingPage> {
  TextEditingController groomNameController = new TextEditingController();
  TextEditingController brideNameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController budgetController = new TextEditingController();

  bool get isPopulated =>
      groomNameController.text.isNotEmpty &&
      brideNameController.text.isNotEmpty &&
      addressController.text.isNotEmpty &&
      budgetController.text.isNotEmpty;

  bool isSubmitButtonEnabled(ValidateWeddingState state) {
    return state.isFormValid &&
        _selectedDate != 'Chọn ngày: ' &&
        _selectedTime != 'Chọn giờ: ' &&
        isPopulated;
  }

  bool _absorbing = false;
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
      firstDate: !widget.isEditing
          ? DateTime.now()
          : DateTime.now().subtract(Duration(days: 100)),
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
    groomNameController.text = widget.isEditing ? widget.wedding.groomName : "";
    brideNameController.text = widget.isEditing ? widget.wedding.brideName : "";
    addressController.text = widget.isEditing ? widget.wedding.address : "";
    budgetController.text = widget.isEditing
        ? _formatNumber(widget.wedding.budget.toInt().toString())
        : "";
    _selectedDate = widget.isEditing
        ? DateFormat('dd-MM-yyyy').format(widget.wedding.weddingDate)
        : 'Chọn ngày: ';
    _selectedTime = widget.isEditing
        ? DateFormat('hh:mm').format(widget.wedding.weddingDate)
        : 'Chọn giờ: ';
    groomNameController.addListener(_onGroomNameChanged);
    brideNameController.addListener(_onBrideNameChanged);
    addressController.addListener(_onAddressChanged);
    budgetController.addListener(_onBudgetChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
          listeners: [
            BlocListener<WeddingBloc, WeddingState>(
              listener: (context, state) {
                if (state is Success) {
                  setState(() {
                    _absorbing = false;
                  });
                  showSuccessSnackbar(context, state.message);
                  widget.isEditing
                      ? Navigator.pop(context)
                      : BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoggedIn());
                } else if (state is Failed) {
                  setState(() {
                    _absorbing = false;
                  });
                  showFailedSnackbar(context, state.message);
                } else if (state is Loading) {
                  setState(() {
                    _absorbing = true;
                  });
                  showProcessingSnackbar(context, state.message);
                }
              },
            ),
            BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (route) => false);
                }
              },
            )
          ],
          child: BlocBuilder(
              cubit: BlocProvider.of<ValidateWeddingBloc>(context),
              builder: (context, state) {
                return AbsorbPointer(
                  absorbing: _absorbing,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: hexToColor("#d86a77"),
                      title: Center(
                        child: Text(widget.isEditing
                            ? "CHỈNH SỬA ĐÁM CƯỚI"
                            : "TẠO ĐÁM CƯỚI"),
                      ),
                      actions: [
                        IconButton(
                            icon: Icon(
                              Icons.check,
                              size: 40,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (isSubmitButtonEnabled(state)) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        PersonDetailsDialog(
                                          message: widget.isEditing
                                              ? "Bạn có muốn chỉnh sửa đám cưới"
                                              : "Bạn có muốn tạo đám cưới?",
                                          onPressedFunction: () async {
                                            _save(state);
                                          },
                                        ));
                              } else {
                                String message = "";
                                if (!state.isFormValid) {
                                  message = "Bạn chưa điền đúng các thông ton";
                                } else if (_selectedDate == 'Chọn ngày: ' ||
                                    _selectedTime == 'Chọn giờ: ' ||
                                    isPopulated) {
                                  message = "Bạn chưa điền đủ các thông tin";
                                } else {
                                  message = "Bạn chưa điền đủ các thông tin";
                                }
                                showSuccessAlertDialog(context, "Thông báo",
                                    message, () => Navigator.pop(context));
                              }
                            }),
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
                            TextField(
                              controller: groomNameController,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                ),
                                hintText: 'TÊN CHÚ RỂ',
                                errorText: !state.isGroomNameValid
                                    ? "Tên không được  chứa số hoặc ký tự đặc biệt"
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
                                    ? "Tên không được chứa số hoặc ký tự đặc biệt"
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
                                    ? "Địa chỉ không được chứa ký tự đặc biệt"
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
                                  errorText: !state.isBudgetValid
                                      ? "Số tiền phải lớn hơn 100.000đ và là bội số của 1000"
                                      : null,
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
                  ),
                );
              })),
    );
  }

  void _onBrideNameChanged() {
    BlocProvider.of<ValidateWeddingBloc>(context)
        .add(BrideNameChanged(brideName: brideNameController.text));
  }

  void _onGroomNameChanged() {
    BlocProvider.of<ValidateWeddingBloc>(context).add(
      GroomNameChanged(groomName: groomNameController.text),
    );
  }

  void _onAddressChanged() {
    BlocProvider.of<ValidateWeddingBloc>(context)
        .add(AddressChanged(address: addressController.text));
  }

  void _onBudgetChanged() {
    BlocProvider.of<ValidateWeddingBloc>(context)
        .add(BudgetChanged(budget: budgetController.text));
  }

  void _save(ValidateWeddingState state) {
    String weddingDateStr = _selectedDate.trim() + " " + _selectedTime.trim();
    var parsedDate = new DateFormat("dd-MM-yyyy hh:mm").parse(weddingDateStr);
    Wedding wedding = new Wedding(brideNameController.text,
        groomNameController.text, parsedDate, "default", addressController.text,
        id: widget.isEditing ? widget.wedding.id : null,
        dateCreated:
            widget.isEditing ? widget.wedding.dateCreated : DateTime.now(),
        budget: double.parse(budgetController.text.replaceAll(",", "")),
        modifiedDate: DateTime.now());
    widget.isEditing
        ? BlocProvider.of<WeddingBloc>(context).add(UpdateWedding(wedding))
        : BlocProvider.of<WeddingBloc>(context).add(CreateWedding(wedding));
  }
}
