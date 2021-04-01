import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/budget/bloc.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/screens/Budget/curveshape.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding_app/screens/add_budget/addbudget.dart';
import 'package:search_page/search_page.dart';
import 'package:wedding_app/utils/hex_color.dart';

import 'download_excel.dart';

class BudgetList extends StatefulWidget {
  @override
  _BudgetListState createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  bool isSearching = false;
  bool _isShow = false;
  List<Category> _categorys = [];
  List<Budget> _budgets = [];
  String id = "";
  String weddingId = "";
  SharedPreferences sharedPrefs;
  double sum = 0;
  double _cateSum = 0;

  showMyAlertDialog(BuildContext context) {
    GlobalKey _containerKey = GlobalKey();
    // Create AlertDialog
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Lưu lại"),
      content: Text("Bạn có muốn lưu lại kinh phí dưới dạng file excel?"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: hexToColor("#d86a77")),
            child: Text("Có"),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
              downloadFile(_budgets, _categorys, context);
            }),
        TextButton(
            style: TextButton.styleFrom(
              primary: hexToColor("#d86a77"),
            ),
            child: Text("Không"),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
            }),
      ],
    );

    // Call showDialog function to show dialog.
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  @override
  void initState() {
    BlocProvider.of<CateBloc>(context).add(LoadTodos());
    _budgets = [];
    _categorys = [];
    sum = 0;
    _cateSum = 0;
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      String weddingId = prefs.getString("wedding_id");
      print("test shared " + weddingId);
      id = weddingId;
    });
    BlocProvider.of<BudgetBloc>(context).add(GetAllBudget(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#d86a77"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: !isSearching
              ? Text(
                  '     KINH PHÍ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              : TextField(
                  onChanged: (value) {},
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Search Item",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
        ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    showMyAlertDialog(context);
                  },
                ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
                context: context,
                delegate: SearchPage<Budget>(
                  barTheme: ThemeData(
                      appBarTheme: AppBarTheme(
                          elevation: 0.0, color: hexToColor("#d86a77"))),
                  searchLabel: "Tìm Kiếm",
                  builder: (Budget budget) => InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<CateBloc>(context),
                                    child: BlocProvider.value(
                                        value: BlocProvider.of<BudgetBloc>(
                                            context),
                                        child: AddBudget(
                                          isEditing: true,
                                          budget: budget,
                                        )),
                                  )),
                        );
                      },
                      child: Card(
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            children: [
                              Container(
                                child: Text(budget.budgetName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Flexible(fit: FlexFit.tight, child: SizedBox()),
                              Visibility(
                                  visible: budget.isComplete,
                                  child: SizedBox(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 3, bottom: 3),
                                      decoration: new BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(" Hoàn Thành ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  )),
                              Text(
                                (budget.money - budget.payMoney).toString() +
                                    "₫",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        //
                      )),
                  filter: (Budget budget) =>
                      [budget.budgetName, budget.money.toString()],
                  items: _budgets,
                )),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              child: ClipPath(
                clipper: CustomShape(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
              )),
          Positioned(
            top: 30,
            left: 15,
            right: 15,
            child: Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: MediaQuery.of(context).size.height * .90,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_balance,
                          color: Colors.deepPurple,
                          size: 45,
                        ),
                        Text("10000")
                      ],
                    ),
                    Container(
                      height: 100,
                      width: 2,
                      color: Colors.deepPurple,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.deepPurple,
                          size: 45,
                        ),
                        BlocBuilder(
                            cubit: BlocProvider.of<BudgetBloc>(context),
                            builder: (context, state) {
                              BlocProvider.of<BudgetBloc>(context)
                                  .add(GetAllBudget(id));
                              if (state is BudgetLoaded) {
                                sum = 0;
                                _budgets = state.budgets;
                                for (int i = 0; i < _budgets.length; i++) {
                                  sum += (_budgets[i].money -
                                      _budgets[i].payMoney);
                                }
                              }
                              return Text(sum.toString());
                            })
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: 15,
            right: 15,
            bottom: 15,
            child: Container(
              child: BlocBuilder(
                cubit: BlocProvider.of<CateBloc>(context),
                builder: (context, state) {
                  if (state is TodosLoaded) {
                    _categorys = state.cates;
                  }
                  return BlocBuilder(
                    cubit: BlocProvider.of<BudgetBloc>(context),
                    builder: (context, state) {
                      BlocProvider.of<BudgetBloc>(context)
                        ..add(GetAllBudget(id));
                      if (state is BudgetLoaded) {
                        _budgets = state.budgets;
                      }
                      return ListView.builder(
                          itemCount: _categorys.length,
                          itemBuilder: (context, index) {
                            Category item = _categorys[index];
                            _cateSum = 0;
                            for (int i = 0; i < _budgets.length; i++) {
                              if (item.id == _budgets[i].cateID) {
                                _cateSum +=
                                    _budgets[i].money - _budgets[i].payMoney;
                              }
                            }

                            return Column(
                              children: <Widget>[
                                Container(
                                  child: ListTile(
                                    title: Text(item.cateName +
                                        " | " +
                                        _cateSum.toString() +
                                        " ₫"),
                                  ),
                                ),
                                BlocBuilder(
                                    cubit: BlocProvider.of<BudgetBloc>(context),
                                    builder: (context, state) {
                                      BlocProvider.of<BudgetBloc>(context)
                                        ..add(GetAllBudget(id));
                                      if (state is BudgetLoaded) {
                                        _budgets = state.budgets;
                                      }
                                      if (state is BudgetNotLoaded) {}

                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _budgets.length,
                                          itemBuilder: (context, i) {
                                            Budget low =
                                                Budget("", "", false, 1, 1, 1);
                                            if (item.id == _budgets[i].cateID) {
                                              low = _budgets[i];
                                              _isShow = true;
                                            } else {
                                              _isShow = false;
                                            }

                                            return Visibility(
                                                visible: _isShow,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (_) =>
                                                                    BlocProvider
                                                                        .value(
                                                                      value: BlocProvider.of<
                                                                              CateBloc>(
                                                                          context),
                                                                      child: BlocProvider.value(
                                                                          value: BlocProvider.of<BudgetBloc>(context),
                                                                          child: AddBudget(
                                                                            isEditing:
                                                                                true,
                                                                            budget:
                                                                                low,
                                                                          )),
                                                                    )),
                                                      );
                                                    },
                                                    child: Card(
                                                      child: Container(
                                                        height: 60,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                right: 15),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                  low
                                                                      .budgetName,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            Flexible(
                                                                fit: FlexFit
                                                                    .tight,
                                                                child:
                                                                    SizedBox()),
                                                            Visibility(
                                                                visible: low
                                                                    .isComplete,
                                                                child: SizedBox(
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 3,
                                                                        bottom:
                                                                            3),
                                                                    decoration:
                                                                        new BoxDecoration(
                                                                      color: Colors
                                                                          .greenAccent,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                    ),
                                                                    child: Text(
                                                                        " Hoàn Thành ",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.normal)),
                                                                  ),
                                                                )),
                                                            Text(
                                                              (low.money -
                                                                          low.payMoney)
                                                                      .toString() +
                                                                  "₫",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      //
                                                    )));
                                          });
                                    }),

                                // Card(
                                //   child:ListTile(
                                //     title:Text(item.items[index].itemName),
                                //     subtitle: Text(item.items[index].cost.toString()),
                                //   ),
                                // )
                              ],
                            );
                          });
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<CateBloc>(context),
                      child: BlocProvider.value(
                          value: BlocProvider.of<BudgetBloc>(context),
                          child: AddBudget(
                            isEditing: false,
                          )),
                    )),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: hexToColor("#d86a77"),
      ),
    );
  }
}
