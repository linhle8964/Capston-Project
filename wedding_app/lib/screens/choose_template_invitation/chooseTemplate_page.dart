import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class ChooseTemplatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChooseTemplate',
      home: ChooseTemplate(),
    );
  }
}

class ChooseTemplate extends StatefulWidget {
  @override
  _ChooseTemplateState createState() => _ChooseTemplateState();
}

class _ChooseTemplateState extends State<ChooseTemplate> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstances();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: null,
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text('Tạo Thiệp Mời',style: TextStyle(color: Colors.grey),),
                  ),
                  Tab(child: Text('Tải Lên Thiệp Có Sẵn',style: TextStyle(color: Colors.grey)),)
                ],
              ),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 30, 0),
                child: Text(
                  "THIỆP MỜI",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                new CardList(),
                Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Text('Tải lên từ bộ sưu tập của bạn',style: TextStyle(fontSize: 20),),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 250,
                                height: 350,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(color: Colors.black, width: 2.0),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: IconButton(icon: Icon(Icons.add),iconSize: 100,onPressed: onAddClick,),
                              ),
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                          child: SizedBox(
                              width: double.infinity,
                              height: 40,
                              child:RaisedButton(
                                color: Colors.blue,
                                onPressed: onUploadClick,
                                child: Text('Tải ảnh lên',style: TextStyle(color: Colors.white,fontSize: 20),),
                              )
                          ),
                        )
                      ],
                    )
                ),
              ],
            )
        ));
  }
}
class CardList extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return new CardListState();
  }
}
class CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    final screenSide= MediaQuery.of(context).size;
    return new Scaffold(
      body: new Container(
        child: new ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: screenSide.width,
                height: screenSide.height,
                child: Image.asset('assets/cardTemplate/template1.jpg',height: screenSide.height,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: screenSide.width,
                height: screenSide.height,
                child: Image.asset('assets/cardTemplate/template2.jpg',height: screenSide.height,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: screenSide.width,
                height: screenSide.height,
                child: Image.asset('assets/cardTemplate/template3.jpg',height: screenSide.height,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: screenSide.width,
                height: screenSide.height,
                child: Image.asset('assets/cardTemplate/template4.jpg',height: screenSide.height,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void onUploadClick(){}
void onAddClick(){}