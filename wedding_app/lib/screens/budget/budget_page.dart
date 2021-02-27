import 'dart:convert';

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

class BudgetList extends StatefulWidget {
  @override
  _BudgetListState createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isSearching = false;
  List<Category> _categorys = [];
  List<Budget> _budgets = [];
  String id = "";
  String weddingId = "";
  SharedPreferences sharedPrefs;
  double sum = 0;

  @override
  void initState() {
    BlocProvider.of<BudgetBloc>(context);
    BlocProvider.of<CateBloc>(context).add(LoadTodos());
    _budgets = [];
    _categorys = [];
    sum = 0;
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      String weddingId = prefs.getString("wedding_id");
      print("test shared " + weddingId);
      id = weddingId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: !isSearching
              ? Text(
                  'BUDGETS',
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
                  icon: Icon(Icons.search),
                  onPressed: () => showSearch(
                      context: context,

                      delegate: SearchPage<Budget>(
                        searchLabel: "Tim Kiem Kinh Phi",
                        builder: (Budget) => Card(
                          child: Container(
                            height: 60,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: [
                                Container(
                                  child: Text(Budget.BudgetName,
                                      style: TextStyle(
                                        color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Flexible(fit: FlexFit.tight, child: SizedBox()),
                                Text(
                                  Budget.money.toString() + "₫",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          //
                        ),
                        filter: (Budget) =>
                            [Budget.BudgetName, Budget.money.toString()],
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
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.blue, Colors.red])),
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
                                sum=0;
                                _budgets = state.budgets;
                                for (int i = 0; i < _budgets.length; i++) {
                                  sum += _budgets[i].money;
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
                  return ListView.builder(
                      itemCount: _categorys.length,
                      itemBuilder: (context, index) {
                        Category item = _categorys[index];
                        print(index);
                        return Column(
                          children: <Widget>[
                            Container(
                              child: ListTile(
                                title: Text(item.CateName + " | " + " ₫"),
                              ),
                            ),
                            BlocBuilder(
                                cubit: BlocProvider.of<BudgetBloc>(context),
                                builder: (context, state) {
                                  if (state is BudgetLoading) {}
                                  if (state is BudgetLoaded) {
                                    print("test index" + index.toString());
                                    _budgets = state.budgets;
                                    print(item.CateName);
                                  }
                                  if (state is BudgetNotLoaded) {}

                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _budgets.length,
                                      itemBuilder: (context, i) {
                                        Budget low = _budgets[i];

                                        return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        BlocProvider.value(
                                                          value: BlocProvider
                                                              .of<CateBloc>(
                                                                  context),
                                                          child: BlocProvider
                                                              .value(
                                                                  value: BlocProvider
                                                                      .of<BudgetBloc>(
                                                                          context),
                                                                  child:
                                                                      AddBudget(
                                                                    isEditing:
                                                                        true,
                                                                    budget: low,
                                                                  )),
                                                        )),
                                              );
                                            },
                                            child: Card(
                                              child: Container(
                                                height: 60,
                                                padding: EdgeInsets.only(
                                                    left: 15, right: 15),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                          low.BudgetName,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    Flexible(
                                                        fit: FlexFit.tight,
                                                        child: SizedBox()),
                                                    Text(
                                                      low.money.toString() +
                                                          "₫",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              //
                                            ));
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
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
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
        label: Text('add a item'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
