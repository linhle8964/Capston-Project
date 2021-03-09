import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/bloc/invitation_card/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wedding_app/bloc/template_card/bloc.dart';
import 'package:wedding_app/model/Invitation_card.dart';
import 'package:wedding_app/model/template_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wedding_app/screens/choose_template_invitation/fill_info_page.dart';

import '../../bloc/invitation_card/bloc.dart';
import '../../widgets/loading_indicator.dart';

class ChooseTemplatePage extends StatefulWidget {
  final bool isCreate;
  const ChooseTemplatePage({Key key, @required this.isCreate}): super (key: key);
  @override
  _ChooseTemplatePageState createState() => _ChooseTemplatePageState();
}

class _ChooseTemplatePageState extends State<ChooseTemplatePage> {
  bool get isCreate => widget.isCreate;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences sharedPrefs;


  bool uploading = false;
  List<File> _image=[];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(
                      child: Center(child: Text('Thiệp mời của bạn',style: TextStyle(color: Colors.grey),)),
                    ),
                    Tab(
                      child: Center(child: Text('Tạo Thiệp Mời',style: TextStyle(color: Colors.grey),)),
                    ),
                    Tab(child: Center(child: Text('Tải Lên Thiệp Có Sẵn',style: TextStyle(color: Colors.grey))),)
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
                  new MyCard(isCreate: isCreate,),
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
                                child: _image.length ==0 ?
                                Container(
                                  width: 250,
                                  height: 350,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    border: new Border.all(color: Colors.black, width: 2.0),
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  child: IconButton(icon: Icon(Icons.add),iconSize: 100,onPressed: ()=>
                                    !uploading ? chooseImage() : null,),
                                ):Container(
                                  width: 250,
                                    height: 350,
                                  decoration: new BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(_image[_image.length -1]),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                  child: IconButton(icon: Icon(Icons.add),iconSize: 0,onPressed: ()=>
                                  !uploading ? chooseImage() : null,),
                                ),
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                            child: SizedBox(
                                width: double.infinity,
                                height: 40,
                                child:ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      uploading = true;
                                    });
                                    uploadFile();
                                  },
                                  child: Text('Tải ảnh lên',style: TextStyle(color: Colors.white,fontSize: 20),),
                                )
                            ),
                          )
                        ],
                      )
                  ),
                ],
              )
          )),
      );
  }
  chooseImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));

    });
    if (pickedFile.path == null) retriverLostData();
  }
  Future<void> retriverLostData () async {
    final LostData response = await picker.getLostData();
    if(response.isEmpty){
      return;
    }
    if(response.file != null){
      setState(() {
        _image.add(File(response.file.path));
      });
    }else{
      print(response.file);
    }
  }
  Future uploadFile() async{
    int i=1;
    String id = '';
    SharedPreferences.getInstance().then((prefs){
      setState(() => sharedPrefs = prefs);
      String weddingId = prefs.getString('wedding_id');
      id = weddingId;
    });
    for (var img in _image){
      print(id);
      var storage = FirebaseStorage.instance;
      final Directory systemTempDir = Directory.systemTemp;
      final file = File('${systemTempDir.path}/demo.jpeg');
      String imgName = 'IMG_${DateTime.now().microsecondsSinceEpoch}';

      TaskSnapshot taskSnapshot =
      await storage.ref('invitation_card/$imgName').putFile(img);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('wedding/$id/invitation_card').doc('1')
          .set({"url": downloadUrl, "name": imgName});
    }
  }
}

class MyCard extends StatefulWidget{
  final bool isCreate;
  const MyCard({Key key, @required this.isCreate}): super (key: key);
  @override
  State<StatefulWidget> createState(){
    return new MyCardState();
  }
}
class MyCardState extends State<MyCard>{
  bool get isCreate => widget.isCreate;
  List<InvitationCard> _invitationCard = [];
  String weddingId='';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences sharedPrefs;
  @override
  void initState(){
    SharedPreferences.getInstance().then((prefs){
      setState(() => sharedPrefs = prefs);
      weddingId = prefs.getString('wedding_id');
      print(weddingId);
    });

    _invitationCard = [];
  }

  @override
  Widget build(BuildContext context) {
    final screenSide= MediaQuery.of(context).size;

    return new Scaffold(
      body: new Container(
        child: BlocBuilder(
          cubit: BlocProvider.of<InvitationCardBloc>(context),
          builder: (context,state){
            if(weddingId != ''){
              BlocProvider.of<InvitationCardBloc>(context).add(LoadSuccess(weddingId));
            }
            if (state is InvitationCardLoading) {
              return  Padding(
                padding: const EdgeInsets.fromLTRB(140, 200, 50, 0),
                child: Container(
                    child: LoadingIndicator()
                ),
              );
            } else if(state is InvitationCardLoaded){
              _invitationCard = state.invitations;
              if(_invitationCard.length == 0 && isCreate == false){
                return Padding(
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                  child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Hiện tại bạn chưa tạo mẫu thiệp mời nào',style: (TextStyle(fontSize: 16)),textAlign: TextAlign.center,
                          ),
                          Text(
                            'Hãy tạo thiệp mời theo mẫu hoặc tải lên từ bộ sưu tập của bạn',style: (TextStyle(fontSize: 18)),textAlign: TextAlign.center,
                          ),
                        ],
                      )

                  ),
                );
              }else if(_invitationCard.length == 0 && isCreate == true){
                return Padding(
                  padding: const EdgeInsets.fromLTRB(140, 200, 50, 0),
                  child: Container(
                     child: LoadingIndicator()
                  ),
                );
              }
              else{
                return ListView.builder(
                    itemCount: 1,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      InvitationCard item = _invitationCard[index];
                      print(index);

                      return Stack(
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                            },
                            child: Container(
                              margin: EdgeInsets.all(3),
                              child: FadeInImage.memoryNetwork(
                                  width: screenSide.width,
                                  height: screenSide.height,
                                  placeholder: kTransparentImage,
                                  image: item.id),
                            ) ,
                          ),
                        ],
                      );
                    }
                );}
            }

          },
        ),
    ),
    );
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
            return  ListView.builder(
                  itemCount: _templates.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    TemplateCard item = _templates[index];
                    print(index);
                    return Stack(
                      children: <Widget>[
                         InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FillInfoPage(template: item),
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.all(3),
                            child: FadeInImage.memoryNetwork(
                                width: screenSide.width,
                                height: screenSide.height,
                                placeholder: kTransparentImage,
                                image: item.url),
                          ) ,
                        ),
                      ],
                    );
                  });
            ;
          }
        )
      ),
    );
  }
}
void onUploadClick(){}
void onAddClick(){}