import 'dart:io';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:transparent_image/transparent_image.dart';
import 'Dart:typed_data';
import 'Dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/model/template_card.dart';
import 'package:flutter/rendering.Dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding_app/screens/choose_template_invitation/chooseTemplate_page.dart';
class InvitationCardPage extends StatefulWidget {
  final TemplateCard template;
  final String brideName;
  final String groomName;
  final String dateTime;
  final String place;
  const InvitationCardPage({Key key, @required this.template, this.brideName, this.groomName, this.dateTime, this.place}): super (key: key);
  @override
  _InvitationCardPageState createState() => _InvitationCardPageState();
}

class _InvitationCardPageState extends State<InvitationCardPage> {
  TemplateCard get template => widget.template;
  String get brideName => widget.brideName;
  String get groomName => widget.groomName;
  String get dateTime => widget.dateTime;
  String get place => widget.place;
  GlobalKey _containerKey= GlobalKey();
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
  }




  @override
  Widget build(BuildContext context) {
    final screenSide= MediaQuery.of(context).size;

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.black,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                child: Text(
                  "Thiệp Của Bạn",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.file_upload),
                  color: Colors.black,
                  onPressed: (){
                    takeScreenShot();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChooseTemplatePage(isCreate: true,)),
                    );
                  }
                ),
              ],
            ),
            body: RepaintBoundary(
                  key: _containerKey,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(3),
                        child: FadeInImage.memoryNetwork(
                            width: screenSide.width,
                            height: screenSide.height,
                            placeholder: kTransparentImage,
                            image: template.backgroundUrl),
                      ) ,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 140, 30, 100),
                        child: Visibility(
                            visible: template.name=='template4' ? true: false,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Text('Trận trong mời bạn đến',style: TextStyle(fontSize: 13),),
                                  Text('dự tiệc cưới của chúng tôi',style: TextStyle(fontSize: 13),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                    child: Text (brideName,style: TextStyle(fontSize: (brideName.length > 15)? 20:22),textAlign: TextAlign.center,),
                                  ),
                                  Text ('Và'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                                    child: Text(groomName,style: TextStyle(fontSize: (groomName.length > 15)? 20:22),textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Hôn lễ được cử hành vào lúc',style: TextStyle(fontSize: 15)),
                                  ),
                                  Text(dateTime,style: TextStyle(fontSize: 15)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Tại '+place,style: TextStyle(fontSize: (groomName.length > 15)? 13:15),textAlign: TextAlign.center),
                                  ),
                                  Text('Sự hiện diện của bạn'),
                                  Text('là vinh hạnh của chúng tôi')
                                ],
                              ),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 170, 30, 100),
                        child: Visibility(
                            visible: template.name=='template1' ? true: false,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Text('Trận trong mời bạn đến',style: TextStyle(fontSize: 11,color: Colors.white),),
                                  Text('dự tiệc cưới của chúng tôi',style: TextStyle(fontSize: 11,color: Colors.white),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                                    child: Text (brideName,style: TextStyle(fontSize: (brideName.length > 15)? 18:22,color: Colors.white),textAlign: TextAlign.center,),
                                  ),
                                  Text ('Và',style: TextStyle(fontSize: 11,color: Colors.white),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 8, 40, 7),
                                    child: Text(groomName,style: TextStyle(fontSize: (groomName.length > 15)? 18:22,color: Colors.white),textAlign: TextAlign.center),
                                  ),
                                  Text(dateTime,style: TextStyle(fontSize: 13,color: Colors.white)),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('Tại '+place,style: TextStyle(fontSize: 13,color: Colors.white)),
                                  ),
                                  Text('Sự hiện diện của bạn',style: TextStyle(fontSize: 11,color: Colors.white)),
                                  Text('là vinh hạnh của chúng tôi',style: TextStyle(fontSize: 11,color: Colors.white))
                                ],
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),


        ));

  }


  Future<void> takeScreenShot() async{
    RenderRepaintBoundary renderRepaintBoundary = _containerKey.currentContext.findRenderObject();
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    print(uint8list);
    var storage = FirebaseStorage.instance;
    final Directory systemTempDir = Directory.systemTemp;
    final file = File('${systemTempDir.path}/demo.jpeg');
    String imgName = 'IMG_${DateTime.now().microsecondsSinceEpoch}';
    await file.writeAsBytes(uint8list);
    TaskSnapshot taskSnapshot =
    await storage.ref('invitation_card/$imgName').putFile(file);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('wedding/$weddingId/invitation_card').doc('1')
        .set({"url": downloadUrl, "name": imgName});

  }
}

