import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(ChooseTemplatePage());
}

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
            Center(child: Text("ai thiep")),
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
            new Container(
              width: screenSide.width,
              height: screenSide.height,
              child: Image.asset('assets/cardTemplate/template1.jpg',height: screenSide.height,),
            ),
            new Container(
              width: screenSide.width,
              height: screenSide.height,
              child: Image.asset('assets/cardTemplate/template2.jpg',height: screenSide.height,),
            ),
            new Container(
              width: screenSide.width,
              height: screenSide.height,
              child: Image.asset('assets/cardTemplate/template3.jpg',height: screenSide.height,),
            ),
            new Container(
              width: screenSide.width,
              height: screenSide.height,
              child: Image.asset('assets/cardTemplate/template4.jpg',height: screenSide.height,),
            ),
          ],
        ),
      ),
    );
  }
}
