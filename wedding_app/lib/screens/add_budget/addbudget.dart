import 'package:flutter/material.dart';

class AddBudget extends StatefulWidget {
  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  @override
  Widget build(BuildContext context) {
    String _dropdownValue = 'One';
    List _values = ['One', 'Two', 'Free', 'Four'];
    int maxLines = 3;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.indigo,
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: Center(
              child: Text('NEW BUDGET'),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                    decoration: new InputDecoration(
                        labelText: 'Item Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        hintText: 'Item Name')),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      width: 250.0,
                      child: TextField(
                          decoration: new InputDecoration(
                              labelText: 'Your Budget',
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              hintText: 'Your Budget')),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      width: 125.0,
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
                              hintText: 'Item Name')),
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
                        hintText: 'How much have you paid for this')),
              ),
              Container(
                padding: EdgeInsets.only(left: 3, right: 225),
                child: TextButton(
                  onPressed: () {},
                  child: RichText(
                    text: TextSpan(children: [
                      WidgetSpan(
                          child: Icon(Icons.add),
                          alignment: PlaceholderAlignment.middle),
                      TextSpan(
                          text: 'partial payment',
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
                  child: DropdownButton(
                    value: _dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    style: TextStyle(color: Colors.deepPurple),
                    onChanged: (value) {
                      setState(() {
                        _dropdownValue = value;
                      });
                    },
                    items: _values.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                    maxLines: maxLines,
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        hintText: 'Notes')),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      child: RaisedButton(
                    onPressed: () {},
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    color: Colors.blueGrey,
                    child: const Text('Exit', style: TextStyle(fontSize: 20)),
                  )),
                  Container(
                    child: RaisedButton(
                        onPressed: () {},
                        textColor: Colors.white,

                        color: Colors.lightBlue,
                          child: const Text('Save',
                              style: TextStyle(fontSize: 20)),
                        )),

                ],
              )
            ],
          ),
        ));
  }
}
