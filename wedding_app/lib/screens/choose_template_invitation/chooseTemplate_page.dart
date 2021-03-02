import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/bloc/invitation_card/bloc.dart';
import 'package:wedding_app/bloc/template_card/bloc.dart';
import 'package:wedding_app/model/template_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wedding_app/screens/choose_template_invitation/fill_info_page.dart';
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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<TemplateCard> _templates = [];
  SharedPreferences sharedPrefs;

  @override
  void initState(){
    BlocProvider.of<TemplateCardBloc>(context).add(LoadTemplateCard());
    _templates = [];
  }
  @override
  Widget build(BuildContext context) {
    final screenSide= MediaQuery.of(context).size;
    return new Scaffold(
      body: new Container(
        child: BlocBuilder(
          cubit: BlocProvider.of<TemplateCardBloc>(context),
          builder: (context,state){
            if(state is TemplateCardLoaded){
              _templates = state.template;
            }
            return ListView.builder(
                itemCount: _templates.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  TemplateCard item = _templates[index];
                  print(index);
                  return InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                              BlocProvider.value(
                                  value: BlocProvider.of<TemplateCardBloc>(context),
                                child: BlocProvider.value(value: BlocProvider.of<InvitationCardBloc>(context),
                                child: FillInfoPage(
                                  //template: item,
                                ),)

                              )));
                    },
                    child: Container(
                      margin: EdgeInsets.all(3),
                      child: FadeInImage.memoryNetwork(
                          width: screenSide.width,
                          height: screenSide.height,
                          placeholder: kTransparentImage,
                          image: item.url),
                    ) ,
                  );
                });
          }
        )
      ),
    );
  }
}
void onUploadClick(){}
void onAddClick(){}