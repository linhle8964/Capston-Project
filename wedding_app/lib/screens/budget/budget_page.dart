import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/budget/bloc.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/category.dart';
import 'package:intl/intl.dart';
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
  bool _iSDone = false;
  List<Category> _categorys = [];
  static List<Budget> _list = [];
  List<Budget> _budgets = [];
  double sum = 0;
  double _cateSum = 0;
  String weddingID;
  double pay = 0;
  SharedPreferences sharedPrefs;
  static double wedBudget = 0;
  static double wedBudget1 = 0;
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

  showMyAlertDialog(BuildContext context) {
    GlobalKey _containerKey = GlobalKey();
    // Create AlertDialog
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Lưu lại"),
      content: Text("Bạn có muốn lưu lại kinh phí dưới dạng file excel?"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(backgroundColor: hexToColor("#d86a77")),
            child: Text(
              "Có",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
              downloadFile(_budgets, _categorys, context);
            }),
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: hexToColor("#d86a77"),
            ),
            child: Text(
              "Không",
              style: TextStyle(color: Colors.white),
            ),
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
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      weddingID = prefs.getString("wedding_id");
    });
    BlocProvider.of<CateBloc>(context).add(LoadTodos());

    wedBudget1 = 0;
    sum = 0;
    _list = [];
    _iSDone = true;
    _cateSum = 0;
    pay = 0;
    wedBudget = 0;
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment = CrossAxisAlignment.center;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text(
              'KINH PHÍ',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(context, String weddingID) {
    return <Widget>[
      new IconButton(
        icon: Icon(Icons.arrow_downward),
        onPressed: () {
          showMyAlertDialog(context);
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          showSearch(
              context: context,
              delegate: SearchPage<Budget>(
                searchLabel: "Tìm Kiếm",
                barTheme: ThemeData(
                  textTheme: TextTheme(
                    title: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    hintStyle: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white70, fontSize: 18),
                  ),
                  appBarTheme: AppBarTheme(
                      elevation: 0.0,
                      color: hexToColor("#d86a77")), //elevation did work
                ),
                suggestion: Center(
                  child: Text(
                    'Tìm kiếm theo tên công việc',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                failure: Center(
                  child: Text(
                    'Chưa có công việc tìm thấy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                builder: (Budget budget) => InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<CateBloc>(context),
                                  child: BlocProvider.value(
                                      value:
                                          BlocProvider.of<BudgetBloc>(context),
                                      child: AddBudget(
                                        budget: budget,
                                        isEditing: true,
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
                                  overflow: TextOverflow.ellipsis,
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
                              (budget.money - budget.payMoney).toString() + "₫",
                              overflow: TextOverflow.ellipsis,
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
              ));
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(

      cubit: BlocProvider.of<WeddingBloc>(context),
      builder: (context, state) {

        if (state is WeddingLoaded) {
          wedBudget = state.wedding.budget;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: hexToColor("#d86a77"),
              bottomOpacity: 0.0,
              title: _buildTitle(context),
              actions: _buildActions(context, weddingID),
              elevation: 0.0,
            ),
            body: BlocBuilder(
              cubit: BlocProvider.of<BudgetBloc>(context),
              builder: (context, state) {
                if (state is BudgetLoaded) {
                  _budgets = state.budgets;
                  return Stack(
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
                                Flexible(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.account_balance,
                                      color: Colors.deepPurple,
                                      size: 45,
                                    ),
                                    BlocBuilder(
                                        cubit: BlocProvider.of<BudgetBloc>(
                                            context),
                                        builder: (context, state) {
                                          if (state is BudgetLoaded) {
                                            _list = state.budgets;
                                            sum = 0;
                                            for (int i = 0;
                                                i < _budgets.length;
                                                i++) {
                                              sum += (_budgets[i].money -
                                                  _budgets[i].payMoney);
                                            }
                                            wedBudget1 = sum;
                                            return Visibility(
                                                visible: _iSDone,
                                                child: Text("Tổng kinh phí:"+
                                                    _formatNumber(
                                                            sum.toString()) +
                                                        "₫",  overflow:
                                                TextOverflow
                                                    .ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)));

                                          }
                                          if (state is BudgetLoading) {
                                            return Column(
                                              children: [
                                                Expanded(
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator())),
                                              ],
                                            );
                                          }

                                          return Container();
                                        })
                                  ],
                                )),
                                Container(
                                  height: 100,
                                  width: 2,
                                  color: Colors.deepPurple,
                                ),
                                BlocBuilder(
                                    cubit: BlocProvider.of<BudgetBloc>(context),
                                    builder: (context, state) {
                                      if (state is BudgetLoaded) {
                                        pay = 0;
                                        pay = wedBudget;
                                        return Flexible(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.account_balance_wallet,
                                              color: Colors.deepPurple,
                                              size: 45,
                                            ),
                                            BlocBuilder(
                                                cubit:
                                                    BlocProvider.of<BudgetBloc>(
                                                        context),
                                                builder: (context, state) {
                                                  if (state is BudgetLoaded) {
                                                    pay = wedBudget;
                                                    for (int i = 0;
                                                        i < _budgets.length;
                                                        i++) {
                                                      pay -=
                                                          _budgets[i].payMoney;
                                                    }
                                                    return Visibility(
                                                        visible: _iSDone,
                                                        child: Flexible(
                                                          child: Text("Số tiền còn lại:"+
                                                              _formatNumber(pay
                                                                      .toString()) +
                                                                  "₫",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: pay < 0
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .black)),
                                                        ));
                                                  } else if (state
                                                      is BudgetLoading) {
                                                    return Column(
                                                      children: [
                                                        Expanded(
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator())),
                                                      ],
                                                    );
                                                  }
                                                  return Container();
                                                })
                                          ],
                                        ));
                                      }
                                      if (state is WeddingLoading) {
                                        return Column(
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator())),
                                          ],
                                        );
                                      }
                                      return Container();
                                    }),
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
                                return BlocBuilder(
                                  cubit: BlocProvider.of<BudgetBloc>(context),
                                  builder: (context, state) {
                                    if (state is BudgetLoaded) {
                                      return ListView.builder(
                                          itemCount: _categorys.length,
                                          itemBuilder: (context, index) {
                                            Category item = _categorys[index];
                                            _cateSum = 0;
                                            for (int i = 0;
                                                i < _budgets.length;
                                                i++) {
                                              if (item.id ==
                                                  _budgets[i].cateID) {
                                                _cateSum += _budgets[i].money -
                                                    _budgets[i].payMoney;
                                              }
                                            }

                                            return Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Visibility(

                                                    child:  ListTile(
                                                      title: Text(item.cateName +
                                                          " | " +
                                                          _formatNumber(_cateSum
                                                              .toString()) +
                                                          " ₫"),
                                                    ),
                                                    visible:_cateSum==0?false:true,
                                                  )

                                                ),
                                                BlocBuilder(
                                                    cubit: BlocProvider.of<
                                                        BudgetBloc>(context),
                                                    builder: (context, state) {
                                                      if (state
                                                          is BudgetLoaded) {
                                                        _budgets =
                                                            state.budgets;
                                                        return ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                _budgets.length,
                                                            itemBuilder:
                                                                (context, i) {
                                                              Budget low =
                                                                  Budget(
                                                                      "",
                                                                      "",
                                                                      false,
                                                                      1,
                                                                      1,
                                                                      1,"");
                                                              if (item.id ==
                                                                  _budgets[i]
                                                                      .cateID) {
                                                                low =
                                                                    _budgets[i];
                                                                _isShow = true;
                                                              } else {
                                                                _isShow = false;
                                                              }

                                                              return Visibility(
                                                                  visible:
                                                                      _isShow,
                                                                  child: InkWell(
                                                                      onTap: () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => BlocProvider.value(
                                                                                    value: BlocProvider.of<CateBloc>(context),
                                                                                    child: BlocProvider.value(
                                                                                        value: BlocProvider.of<BudgetBloc>(context),
                                                                                        child: AddBudget(
                                                                                          isEditing: true,
                                                                                          budget: low,
                                                                                        )),
                                                                                  )),
                                                                        );
                                                                      },
                                                                      child: Card(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              60,
                                                                          padding: EdgeInsets.only(
                                                                              left: 15,
                                                                              right: 15),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  child: Text(low.budgetName, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                ),
                                                                              ),
                                                                              Visibility(
                                                                                  visible: low.payMoney != 0 && low.isComplete == false,
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                                                                      decoration: new BoxDecoration(
                                                                                        color: Colors.redAccent,
                                                                                        borderRadius: BorderRadius.circular(16),
                                                                                      ),
                                                                                      child: Text("Đã trả một phần", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal)),
                                                                                    ),
                                                                                  )),
                                                                              Visibility(
                                                                                  visible: low.isComplete,
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                                                                      decoration: new BoxDecoration(
                                                                                        color: Colors.greenAccent,
                                                                                        borderRadius: BorderRadius.circular(16),
                                                                                      ),
                                                                                      child: Text(" Hoàn Thành ", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal)),
                                                                                    ),
                                                                                  )),
                                                                              Flexible(
                                                                                  child: Text(
                                                                                _formatNumber((low.money - low.payMoney).toString()) + "₫",
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 1,
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                              ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        //
                                                                      )));
                                                            });
                                                      }
                                                      if (state
                                                          is BudgetLoading) {
                                                        return Column(
                                                          children: [
                                                            Expanded(
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                          ],
                                                        );
                                                      }
                                                      return Container();
                                                    }),
                                              ],
                                            );
                                          });
                                    } else if (state is BudgetLoading) {
                                      return Column(
                                        children: [
                                          Expanded(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator())),
                                        ],
                                      );
                                    }
                                    return Container();
                                  },
                                );
                              } else if (state is TodosLoading) {
                                return Column(
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      )
                    ],
                  );
                } else if (state is BudgetLoading) {
                  return Column(
                    children: [
                      Expanded(
                          child: Center(child: CircularProgressIndicator())),
                    ],
                  );
                } else {
                  BlocProvider.of<BudgetBloc>(context)
                      .add(GetAllBudget(weddingID));
                  return Stack(
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
                                    BlocBuilder(
                                        cubit: BlocProvider.of<BudgetBloc>(
                                            context),
                                        builder: (context, state) {
                                          if (state is BudgetLoaded) {
                                            _list = state.budgets;
                                            sum = 0;
                                            for (int i = 0;
                                                i < _budgets.length;
                                                i++) {
                                              sum += (_budgets[i].money -
                                                  _budgets[i].payMoney);
                                            }
                                            wedBudget1 = sum;
                                            return Visibility(
                                                visible: _iSDone,
                                                child: Text(
                                                    _formatNumber(
                                                            sum.toString()) +
                                                        "₫",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)));
                                            ;
                                          }
                                          if (state is BudgetLoading) {
                                            return Column(
                                              children: [
                                                Expanded(
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator())),
                                              ],
                                            );
                                          }

                                          return Container();
                                        })
                                  ],
                                ),
                                Container(
                                  height: 100,
                                  width: 2,
                                  color: Colors.deepPurple,
                                ),
                                BlocBuilder(
                                    cubit: BlocProvider.of<BudgetBloc>(context),
                                    builder: (context, state) {
                                      if (state is BudgetLoaded) {
                                        pay = 0;

                                        pay = wedBudget;
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.account_balance_wallet,
                                              color: Colors.deepPurple,
                                              size: 45,
                                            ),
                                            BlocBuilder(
                                                cubit:
                                                    BlocProvider.of<BudgetBloc>(
                                                        context),
                                                builder: (context, state) {
                                                  if (state is BudgetLoaded) {
                                                    pay = wedBudget;
                                                    for (int i = 0;
                                                        i < _budgets.length;
                                                        i++) {
                                                      pay -=
                                                          _budgets[i].payMoney;
                                                    }
                                                    return Visibility(
                                                      visible: _iSDone,
                                                      child: Text(
                                                          _formatNumber(pay
                                                                  .toString()) +
                                                              "₫",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: pay < 0
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black)),
                                                    );
                                                  } else if (state
                                                      is BudgetLoading) {
                                                    return Column(
                                                      children: [
                                                        Expanded(
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator())),
                                                      ],
                                                    );
                                                  }
                                                  return Container();
                                                })
                                          ],
                                        );
                                      }
                                      if (state is WeddingLoading) {
                                        return Column(
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator())),
                                          ],
                                        );
                                      }
                                      return Container();
                                    }),
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
                                return BlocBuilder(
                                  cubit: BlocProvider.of<BudgetBloc>(context),
                                  builder: (context, state) {
                                    if (state is BudgetLoaded) {
                                      return ListView.builder(
                                          itemCount: _categorys.length,
                                          itemBuilder: (context, index) {
                                            Category item = _categorys[index];
                                            _cateSum = 0;
                                            for (int i = 0;
                                                i < _budgets.length;
                                                i++) {
                                              if (item.id ==
                                                  _budgets[i].cateID) {
                                                _cateSum += _budgets[i].money -
                                                    _budgets[i].payMoney;
                                              }
                                            }

                                            return Column(
                                              children: <Widget>[
                                                Container(
                                                  child: ListTile(
                                                    title: Text(item.cateName +
                                                        " | " +
                                                        _formatNumber(_cateSum
                                                            .toString()) +
                                                        " ₫"),
                                                  ),
                                                ),
                                                BlocBuilder(
                                                    cubit: BlocProvider.of<
                                                        BudgetBloc>(context),
                                                    builder: (context, state) {
                                                      if (state
                                                          is BudgetLoaded) {
                                                        _budgets =
                                                            state.budgets;
                                                        return ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                _budgets.length,
                                                            itemBuilder:
                                                                (context, i) {
                                                              Budget low =
                                                                  Budget(
                                                                      "",
                                                                      "",
                                                                      false,
                                                                      1,
                                                                      1,
                                                                      1,"");
                                                              if (item.id ==
                                                                  _budgets[i]
                                                                      .cateID) {
                                                                low =
                                                                    _budgets[i];
                                                                _isShow = true;
                                                              } else {
                                                                _isShow = false;
                                                              }

                                                              return Visibility(
                                                                  visible:
                                                                      _isShow,
                                                                  child: InkWell(
                                                                      onTap: () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => BlocProvider.value(
                                                                                    value: BlocProvider.of<CateBloc>(context),
                                                                                    child: BlocProvider.value(
                                                                                        value: BlocProvider.of<BudgetBloc>(context),
                                                                                        child: AddBudget(
                                                                                          isEditing: true,
                                                                                          budget: low,
                                                                                        )),
                                                                                  )),
                                                                        );
                                                                      },
                                                                      child: Card(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              60,
                                                                          padding: EdgeInsets.only(
                                                                              left: 15,
                                                                              right: 15),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  child: Text(low.budgetName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                ),
                                                                              ),
                                                                              Flexible(fit: FlexFit.tight, child: SizedBox()),
                                                                              Visibility(
                                                                                  visible: low.payMoney != 0 && low.isComplete == false,
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                                                                      decoration: new BoxDecoration(
                                                                                        color: Colors.redAccent,
                                                                                        borderRadius: BorderRadius.circular(16),
                                                                                      ),
                                                                                      child: Text("Đã trả một phần", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal)),
                                                                                    ),
                                                                                  )),
                                                                              Visibility(
                                                                                  visible: low.isComplete,
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                                                                      decoration: new BoxDecoration(
                                                                                        color: Colors.greenAccent,
                                                                                        borderRadius: BorderRadius.circular(16),
                                                                                      ),
                                                                                      child: Text(" Hoàn Thành ", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal)),
                                                                                    ),
                                                                                  )),
                                                                              Text(
                                                                                _formatNumber((low.money - low.payMoney).toString()) + "₫",
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        //
                                                                      )));
                                                            });
                                                      }
                                                      if (state
                                                          is BudgetLoading) {
                                                        return Column(
                                                          children: [
                                                            Expanded(
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                          ],
                                                        );
                                                      }
                                                      return Container();
                                                    }),
                                              ],
                                            );
                                          });
                                    } else if (state is BudgetLoading) {
                                      return Column(
                                        children: [
                                          Expanded(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator())),
                                        ],
                                      );
                                    }
                                    return Container();
                                  },
                                );
                              } else if (state is TodosLoading) {
                                return Column(
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      )
                    ],
                  );
                }
              },
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
        if (state is WeddingLoading) {
          return Column(
            children: [
              Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          );
        }
        return Container();
      },
    );
  }
}
