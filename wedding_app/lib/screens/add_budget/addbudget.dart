import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/budget/bloc.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';

class AddBudget extends StatefulWidget {
  @override
  _AddBudgetState createState() => _AddBudgetState();

}

class _AddBudgetState extends State<AddBudget> {
  bool _visible = true;
  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("wedding_id");
  }

  bool _checkboxListTile = false;
  CateBloc _cateBloc;
  Category selectedCate;
  String _weddid="";
  List<Category> _values = [];
  List<Category> _values2 = [];
  Category initialCate = new Category("1G23wMGwdk1pnQWnT368", "other");
  TextEditingController budgetNameController = new TextEditingController();
  TextEditingController moneyController = new TextEditingController();
  TextEditingController payMoneyController = new TextEditingController();
  TextEditingController budgetController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _visible = false;
    _cateBloc = BlocProvider.of<CateBloc>(context);
    loadData();
    print(loadData());

  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CateBloc>(context).add(LoadTodos());
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    TextEditingController budgetNameController = new TextEditingController();
    TextEditingController moneyController = new TextEditingController();
    TextEditingController payMoneyController = new TextEditingController();
    TextEditingController budgetController = new TextEditingController();
    int maxLines = 3;

    return BlocBuilder(
      cubit: BlocProvider.of<BudgetBloc>(context),
      builder: (context , state ) {
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
                        child: TextField(
                          controller:budgetNameController ,
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
                              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                              width: 250.0,
                              child: TextField(
                                controller: moneyController,
                                  decoration: new InputDecoration(
                                      labelText: 'Số tiền',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.black, width: 2.0),
                                      ),
                                      hintText: 'Tiền')),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              width: 125.0,

                              child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                      Border.all(color: Colors.black, width: 2)),
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    activeColor: Colors.blue,
                                    controlAffinity: ListTileControlAffinity.leading,
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
                        child: TextField(
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
                            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: TextField(
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
                                    hintText: 'Trả theo phần 2')),
                          )),
                      Container(
                        padding: EdgeInsets.only(left: 3, right: 225),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _visible = !_visible;
                              print(_visible);
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
                                _values = state.cates;
                                _values2 = state.cates;
                                print(state.cates.toString());

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
                        child: TextField(
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
                                onPressed: () {},
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
                                      void _save(){
                                        Budget budget = new Budget( budgetNameController.text,selectedCate.id,1,
                                            money:double.parse(moneyController.text.replaceAll(",", "")),
                                            payMoney: double.parse(payMoneyController.text.replaceAll(",", "")));

                                        BlocProvider.of<BudgetBloc>(context)
                                            .add(CreateBudget(loadData().toString(),budget));
                                      };
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
      }
    );

  }


}
