import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/budget/bloc.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';

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
  bool _visible = true;

  bool get isEditing => widget.isEditing;

  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("wedding_id");
  }

  bool _checkboxListTile = false;
  CateBloc _cateBloc;
  Category holder;
  Category selectedCate;
  List<Category> _values2 = [];
  String budgetId = "";
  String weddingId = "";
  String id="";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Category initialCate = new Category("1G23wMGwdk1pnQWnT368", "other");
  TextEditingController budgetNameController = new TextEditingController();
  TextEditingController moneyController = new TextEditingController();
  TextEditingController payMoneyController = new TextEditingController();
  TextEditingController budgetController = new TextEditingController();
  SharedPreferences sharedPrefs;
  @override
  void initState() {
    super.initState();
    _visible = false;
    _cateBloc = BlocProvider.of<CateBloc>(context);
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      String weddingId = prefs.getString("wedding_id");
      print("test shared "+ weddingId);
      id=weddingId;
    });
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CateBloc>(context).add(LoadTodos());

    print(isEditing);
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    TextEditingController budgetNameController = new TextEditingController();
    budgetNameController.text = isEditing ? widget.budget.BudgetName : "";
    TextEditingController moneyController = new TextEditingController();
    moneyController.text = isEditing ? widget.budget.money.toString() : "";
    TextEditingController payMoneyController = new TextEditingController();
    payMoneyController.text =
        isEditing ? widget.budget.payMoney.toString() : "";
    TextEditingController budgetController = new TextEditingController();
    int maxLines = 3;
    void getDropDownItem() {
      setState(() {
        holder = selectedCate;
      });
    }

    return BlocBuilder(
        cubit: BlocProvider.of<BudgetBloc>(context),
        builder: (context, state) {
          print(ModalRoute.of(context).settings.name.toString());
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.indigo,
                bottomOpacity: 0.0,
                elevation: 0.0,
                title: Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Text('Thêm Quỹ')),
              ),
              body: SingleChildScrollView(
                  child: SizedBox(
                height: queryData.size.height,
                width: queryData.size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                          controller: budgetNameController,
                          decoration: new InputDecoration(
                              labelText: 'Tên Quỹ',
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Tên Quỹ')),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            width: 250.0,
                            child: TextFormField(
                                controller: moneyController,
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
                                    hintText: 'Tiền')),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            width: 125.0,

                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  activeColor: Colors.blue,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text('Chưa hoàn thành'),
                                  value: _checkboxListTile,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkboxListTile = !_checkboxListTile;
                                    });
                                  },
                                )),
                            // TextField(
                            //     decoration: new InputDecoration(
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide:
                            //           BorderSide(color: Colors.blue, width: 2.0),
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //           borderSide:
                            //           BorderSide(color: Colors.black, width: 2.0),
                            //         ),
                            //         hintText: 'Item Name')),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                          controller: payMoneyController,
                          decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Trả theo phần 1')),
                    ),
                    Visibility(
                        visible: _visible,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: TextFormField(
                              decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  hintText: 'Trả theo phần 2')),
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 3, right: 225),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _visible = !_visible;
                          });
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                                child: Icon(Icons.add),
                                alignment: PlaceholderAlignment.middle),
                            TextSpan(
                                text: 'Trả theo phần',
                                style: TextStyle(color: Colors.redAccent))
                          ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2)),
                        child: BlocBuilder(
                          cubit: _cateBloc,
                          builder: (context, state) {
                            if (state is TodosLoaded) {
                              _values2 = state.cates;
                              print(state.cates.toString());
                              if (isEditing == true && state is TodosLoaded) {
                                for (int i = 0; i < state.cates.length; i++) {
                                  if (state.cates[i].id ==
                                      widget.budget.CateID) {
                                    initialCate = state.cates[i];
                                  }
                                }
                              }
                              return DropdownButtonFormField(
                                value: selectedCate ?? initialCate,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,
                                style: TextStyle(color: Colors.deepPurple),
                                items: _values2.map((Category cate) {
                                  return DropdownMenuItem<Category>(
                                    value: cate,
                                    child: Text(cate.CateName),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => selectedCate = val),
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
                          decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Ghi chú')),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.red,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.delete_forever_outlined),
                              color: Colors.white,
                              iconSize: 40,
                              onPressed: () {
                                BlocProvider.of<BudgetBloc>(context)
                                  ..add(DeleteBudget(id,
                                      widget.budget.id));

                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.only(left: 0.0, right: 40.0),
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.cancel_outlined),
                                  color: Colors.white,
                                  iconSize: 30,
                                  onPressed: () {},
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.only(right: 0.0, left: 40.0),
                            color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'SAVE',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_outlined),
                                  color: Colors.white,
                                  iconSize: 30,
                                  onPressed: () {
                                    getDropDownItem();
                                    if (isEditing) {
                                      Budget budget = new Budget(
                                          budgetNameController.text,
                                          holder.id,
                                          double.parse(moneyController.text),
                                          double.parse(payMoneyController.text),
                                          1,
                                          id: widget.budget.id);
                                      print(budget.toString());
                                      BlocProvider.of<BudgetBloc>(context)
                                        ..add(UpdateBudget(
                                            budget, id));
                                      Navigator.pop(context);
                                    } else if (isEditing != true) {
                                      Budget budget = new Budget(
                                          budgetNameController.text,
                                          holder.id,
                                          double.parse(moneyController.text),
                                          double.parse(payMoneyController.text),
                                          1);
                                      BlocProvider.of<BudgetBloc>(context).add(
                                          CreateBudget(
                                              id, budget));
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )));
        });
  }
}
