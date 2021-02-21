import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:wedding_app/screens/choose_template_invitation/completeInvitation_page.dart';
import 'package:transparent_image/transparent_image.dart';
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
  bool uploading = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  List<File> _image = [];
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
                                child: IconButton(icon: Icon(Icons.add),iconSize: 100,onPressed: () =>
                                !uploading ? chooseImage() : null,),
                              ):Container(
                                width: 250,
                                height: 350,
                                decoration: new BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image[_image.length-1]),
                                        fit: BoxFit.cover)),
                                child: IconButton(icon: Icon(Icons.add),iconSize: 0,onPressed: () =>
                                !uploading ? chooseImage() : null,),
                                ),
                              ),
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
                                  uploadFile().whenComplete(() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompleteInvitationPage())));
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
  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url': value});
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('imageURLs').snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
            child: CircularProgressIndicator(),
          )
              : new Container(
            padding: EdgeInsets.all(4),
            child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return Container(
                    margin: EdgeInsets.all(3),
                    child: FadeInImage.memoryNetwork(
                        width: screenSide.width,
                        height: screenSide.height,
                        placeholder: kTransparentImage,
                        image: snapshot.data.docs[index].get('url')),
                  );
                }
            ),
          );
        },
      ),
    );
  }
}

void onUploadClick(){}
void onAddClick(){}
