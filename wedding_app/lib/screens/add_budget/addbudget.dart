import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/budget/bloc.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:intl/intl.dart';

String paymoney = "0";
bool isCheck = false;
CateBloc _cateBloc;
Category holder;
Category selectedCate;
List<Category> _values2 = [];
String budgetId = "";
String weddingId = "";
String id = "";
bool _checkboxListTile = false;
Category initialCate = new Category("", "");
TextEditingController budgetNameController = new TextEditingController();
TextEditingController moneyController = new TextEditingController();
TextEditingController payMoneyController = new TextEditingController();
TextEditingController budgetController = new TextEditingController();
final GlobalKey<ScaffoldState> scaffoldKey =
new GlobalKey<ScaffoldState>();

class BudgetNameValidate {
  static String budgetNameValidate(BuildContext context, String val) {
    if (val.length > 20) {
      return "tên quỹ không thể quá 20 kí tự";
    }
    if (val == "") {
      return "tên quỹ không thể trống";
    }
    return null;
  }

  static String moneyValidate(BuildContext context, String val) {
    if (val == "") {
      return "số tiền không thể trống";
    }if(val.length>15){
      return"số tiền không thể quá 999 tỷ đông";
    }
    else {
      if (double.parse(val.replaceAll(",", "")) < 1000) {
        return "Tiền phải lớn hơn 1000 đồng";
      }
    }

    return null;
  }

  static String payMoneyValidate(BuildContext context, String val) {
    if (val == "") {
      payMoneyController.text = "0";
    }else if(double.parse(val.replaceAll(",", "")) < 1000&&(double.parse(val.replaceAll(",", "")) > 0)) {
      return "Tiền đã trả phải lớn hơn 1000 đồng";
    }
    else if (double.parse(val.replaceAll(",", "")) >
        double.parse(moneyController.value.text.replaceAll(",", ""))) {
      showFailedSnackbar(context, "Xin Vui Lòng nhập lại quỹ");
      return "Tiền đã trả phải nhỏ hơn hoặc bằng kinh phí ban đầu";
    }

    return null;
  }

  static String noteValidate(BuildContext context, String val) {
    if (val.length > 100) {
      return "Ghi chú không được quá 100 kí tự";
    }
    return null;
  }
}

class AddBudget extends StatefulWidget {
  final bool isEditing;
  final Budget budget;

  const AddBudget({Key key, @required this.isEditing, this.budget})
      : super(key: key);

  @override
  _AddBudgetState createState() => _AddBudgetState();
}

// Future<String> loadData() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   return preferences.getString(nameKey);
// }
class _AddBudgetState extends State<AddBudget> {
  bool get isEditing => widget.isEditing;

  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("wedding_id");
  }

  SharedPreferences sharedPrefs;
  final _formkey = GlobalKey<FormState>();
  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

  @override
  void initState() {
    super.initState();
    _cateBloc = BlocProvider.of<CateBloc>(context);
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      selectedCate=null;
      String weddingId = prefs.getString("wedding_id");
      print("test shared " + weddingId);
      id = weddingId;
      budgetNameController.text = isEditing ? widget.budget.budgetName : "";
      payMoneyController.text = widget.isEditing
          ? _formatNumber(widget.budget.payMoney.toString())
          : "";
      moneyController.text =
          isEditing ? _formatNumber(widget.budget.money.toString()) : "";
      _checkboxListTile = isEditing ? widget.budget.isComplete : false;
      budgetController.text = isEditing ? widget.budget.note : "";
    });
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CateBloc>(context).add(LoadTodos());
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    int maxLines = 3;

    return BlocBuilder(
        cubit: BlocProvider.of<BudgetBloc>(context),
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: hexToColor("#d86a77"),
                bottomOpacity: 0.0,
                elevation: 0.0,
                title: Text(
                  isEditing?"Sửa Quỹ":"Thêm Quỹ",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                actions: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) =>
                                PersonDetailsDialog(
                                  message: isEditing
                                      ? "Bạn đang sửa kinh phí"
                                      : "Bạn đang thêm kinh phí",
                                  onPressedFunction: () {
                                    print("test " +
                                            moneyController.value.text
                                                .replaceAll(",", "") ==
                                        payMoneyController.value.text
                                            .replaceAll(",", ""));
                                    if (moneyController.value.text
                                            .replaceAll(",", "")
                                            .trim() !=
                                        payMoneyController.value.text
                                            .replaceAll(",", "")
                                            .trim()) {
                                      setState(() {
                                        _checkboxListTile = false;
                                      });
                                    } else if (moneyController.value.text
                                            .replaceAll(",", "")
                                            .trim() ==
                                        payMoneyController.value.text
                                            .replaceAll(",", "")
                                            .trim()) {
                                      setState(() {
                                        _checkboxListTile = true;
                                      });
                                    }
                                    updateBudget();
                                  },
                                ));
                      },
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                  child: SizedBox(
                height: queryData.size.height,
                width: queryData.size.width,
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                            controller: budgetNameController,
                            validator: (val) {
                              return BudgetNameValidate.budgetNameValidate(
                                  context, val);
                            },
                            decoration: new InputDecoration(
                                labelText: 'Tên Quỹ',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                hintText: 'Tên Quỹ')),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                width: queryData.size.width * 2 / 3,
                                child: TextFormField(
                                    controller: moneyController,
                                    keyboardType: TextInputType.number,
                                    onSaved: (input) => moneyController.text =
                                        input.replaceAll(",", ""),
                                    onChanged: (string) {
                                      print("test " + string);
                                      string =
                                          '${_formatNumber(string.replaceAll(',', ''))}';
                                      moneyController.value = TextEditingValue(
                                        text: string,
                                        selection: TextSelection.collapsed(
                                            offset: string.length),
                                      );
                                    },
                                    validator: (val) {
                                      return BudgetNameValidate.moneyValidate(
                                          context, val);
                                    },
                                    decoration: new InputDecoration(
                                      labelText: 'Số tiền',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      hintText: 'Tiền',
                                    ))),
                            Container(
                                padding: EdgeInsets.only(bottom: 20),
                                width: queryData.size.width * 2 / 7,
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 2)),
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      activeColor: Colors.blue,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text('Hoàn thành'),
                                      value: _checkboxListTile,
                                      onChanged: (value) {
                                        setState(() {
                                          _checkboxListTile =
                                              !_checkboxListTile;
                                          payMoneyController.text =
                                              moneyController.text;
                                        });
                                      },
                                    ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: TextFormField(
                            controller: payMoneyController,
                            keyboardType: TextInputType.number,
                            onChanged: (string) {
                              print("test " +
                                      moneyController.value.text
                                          .replaceAll(",", "") ==
                                  string.replaceAll(",", ""));
                              if (moneyController.value.text
                                      .replaceAll(",", "")
                                      .trim() !=
                                  string.replaceAll(",", "").trim()) {
                                setState(() {
                                  _checkboxListTile = false;
                                });
                              } else if (moneyController.value.text
                                      .replaceAll(",", "")
                                      .trim() ==
                                  string.replaceAll(",", "").trim()) {
                                setState(() {
                                  _checkboxListTile = true;
                                });
                              }
                              print("test " + string);
                              string =
                                  '${_formatNumber(string.replaceAll(',', ''))}';
                              payMoneyController.value = TextEditingValue(
                                text: string,
                                selection: TextSelection.collapsed(
                                    offset: string.length),
                              );
                            },
                            validator: (val) {
                              return BudgetNameValidate.payMoneyValidate(
                                  context, val);
                            },
                            decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                hintText: 'Số tiền đã trả')),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 2)),
                          child: BlocBuilder(
                            cubit: _cateBloc,
                            builder: (context, state) {
                              if (state is TodosLoaded) {
                                _values2 = state.cates;
                                print(state.cates.toString());
                                if (isEditing == true && state is TodosLoaded) {
                                  for (int i = 0; i < state.cates.length; i++) {
                                    if (state.cates[i].id ==
                                        widget.budget.cateID) {
                                      initialCate = state.cates[i];
                                    }
                                  }
                                }
                                return DropdownButtonFormField(
                                  value: isEditing ? initialCate : selectedCate,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  isExpanded: true,
                                  style: TextStyle(color: Colors.deepPurple),
                                  items: _values2.map((Category cate) {
                                    return DropdownMenuItem<Category>(
                                      value: cate,
                                      child: Text(cate.cateName),
                                    );
                                  }).toList(),
                                  onChanged: (val) =>
                                      setState(() => selectedCate = val),
                                  onSaved: (val) => selectedCate = val,
                                );
                              } else if (state is TodosLoading) {
                                return LoadingIndicator();
                              } else if (state is TodosNotLoaded) {}
                              return LoadingIndicator();
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                            maxLines: maxLines,
                            controller: budgetController,
                            validator: (val) {
                              return BudgetNameValidate.noteValidate(
                                  context, val);
                            },
                            decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                hintText: 'Ghi chú')),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: isEditing,
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.red,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.delete_forever_outlined),
                                  color: Colors.white,
                                  iconSize: 40,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            PersonDetailsDialog(
                                              message: "Bạn đang xóa",
                                              onPressedFunction: () {
                                                BlocProvider.of<BudgetBloc>(
                                                    context)
                                                  ..add(DeleteBudget(
                                                      id, widget.budget.id));
                                                Navigator.pop(context);
                                              },
                                            ));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )));
        });
  }

  void updateBudget() {
    if (_formkey.currentState.validate()) {
      if (isEditing) {
        Budget budget = new Budget(
            budgetNameController.text,
            selectedCate == null ? initialCate.id : selectedCate.id,
            _checkboxListTile,
            double.parse(moneyController.text.replaceAll(',', '')),
            payMoneyController.text == null
                ? double.parse("0")
                : double.parse(payMoneyController.text.replaceAll(',', '')),
            1,
            budgetController.text,
            id: widget.budget.id);
        print(budget.toString());
        if (budget != null && budgetNameController.text.trim().isNotEmpty) {
          BlocProvider.of<BudgetBloc>(context)..add(UpdateBudget(budget, id));
          showSuccessSnackbar(context, "Sửa kinh phí thành công");
          Navigator.pop(context);
        } else if (selectedCate == null) {
          showFailedSnackbar(context, "Thư mục không thể trống");
        } else if (budget.budgetName == null) {
          showFailedSnackbar(context, "Tên quỹ không thể trống");
        }
      } else if (isEditing != true) {
        bool _isSet = false;
        if (selectedCate != null &&
            selectedCate.cateName.trim().isNotEmpty &&
            budgetNameController.text.trim().isNotEmpty &&
            moneyController.text.trim().isNotEmpty) {
          Budget budget = new Budget(
              budgetNameController.text,
              selectedCate.id,
              _checkboxListTile,
              double.parse(moneyController.text.replaceAll(',', '')),
              payMoneyController.text == null
                  ? double.parse("0")
                  : double.parse(payMoneyController.text.replaceAll(',', '')),
              1,
              budgetController.text);
          BlocProvider.of<BudgetBloc>(context).add(CreateBudget(id, budget));
          showSuccessSnackbar(context, "Thêm kinh phí thành công");
          Navigator.pop(context);

          _isSet = true;
        } else if (selectedCate == null && _isSet == false) {
          showFailedSnackbar(context, "Thư mục không thể trống");
        } else if (budgetNameController.text == null && _isSet == false) {
          showFailedSnackbar(context, "Tên quỹ không thể trống");
        }
      }
    }
  }
}
