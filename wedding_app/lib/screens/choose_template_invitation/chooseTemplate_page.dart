import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/bloc/invitation_card/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences sharedPrefs;


  bool uploading = false;
  List<File> _image=[];
  final picker = ImagePicker();

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
                              child:RaisedButton(
                                color: Colors.blue,
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
        ));
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
          .collection('wedding/$id/invitation_card')
          .add({"url": downloadUrl, "name": imgName});
    }
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