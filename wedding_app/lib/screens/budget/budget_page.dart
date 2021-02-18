import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/screens/Budget/curveshape.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/screens/Budget/model/category.dart';
import 'package:wedding_app/screens/Budget/model/item.dart';
import 'package:wedding_app/screens/add_budget/addbudget.dart';
import 'package:wedding_app/screens/edit_task/edit_task.dart';

class BudgetList extends StatefulWidget {
  @override
  _BudgetListState createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final List<Item> Items = [];
    final it = Item("HoneyMoon", 10000);
    final it1 = Item("Dinner", 10000);
    final it2 = Item("Water", 10000);
    Items.add(it);
    Items.add(it1);
    Items.add(it2);
    final List<category> Categorys = [];
    final cate = category("Entertainment and music", Items);
    final cate2 = category("other", Items);
    Categorys.add(cate);
    Categorys.add(cate2);
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
            onPressed: () {
              setState(() {
                this.isSearching = true;
              });
            },
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
                width: MediaQuery
                    .of(context)
                    .size
                    .height * .90,
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
                        Text("Total")
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
              child: ListView.builder(
                  itemCount: Categorys.length,
                  itemBuilder: (context, index) {
                    final item = Categorys[index];
                    double sum = 0;
                    for (int i = 0; i < item.items.length; i++) {
                      sum += item.items[i].cost;
                    }
                    return Column(
                      children: <Widget>[
                        Container(
                          child: ListTile(
                            title: Text(
                                item.header + " | " + sum.toString() + " ₫"),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: item.items.length,
                            itemBuilder: (context, i) {
                              final low = item.items[i];
                              return Card(
                                  child: Container(
                                    height: 60,
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Text(low.itemName,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)
                                          ),
                                        ),
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Text(
                                          low.cost.toString() + "₫",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ));
                            })
                        // Card(
                        //   child:ListTile(
                        //     title:Text(item.items[index].itemName),
                        //     subtitle: Text(item.items[index].cost.toString()),
                        //   ),
                        // )
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

          Navigator.of(context).push(
              MaterialPageRoute<AddBudget>(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<CateBloc>(context),
                  child: AddBudget(),
                ),
              ));


        },
        label: Text('add a item'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
