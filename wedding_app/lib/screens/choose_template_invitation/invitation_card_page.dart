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
import 'package:sizer/sizer.dart';
import 'package:wedding_app/utils/hex_color.dart';

class InvitationCardPage extends StatefulWidget {
  final TemplateCard template;
  final String brideName;
  final String groomName;
  final String dateTime;
  final String place;
  const InvitationCardPage(
      {Key key,
      @required this.template,
      this.brideName,
      this.groomName,
      this.dateTime,
      this.place})
      : super(key: key);
  @override
  _InvitationCardPageState createState() => _InvitationCardPageState();
}

class _InvitationCardPageState extends State<InvitationCardPage> {
  TemplateCard get template => widget.template;
  String get brideName => widget.brideName;
  String get groomName => widget.groomName;
  String get dateTime => widget.dateTime;
  String get place => widget.place;
  GlobalKey _containerKey = GlobalKey();
  String weddingId = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences sharedPrefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      weddingId = prefs.getString('wedding_id');
      print(weddingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSide = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizerUtil().init(constraints, orientation);
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: hexToColor("#d86a77"),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Text(
                "Thiệp Của Bạn",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.file_upload),
                  color: Colors.white,
                  onPressed: () {
                    showMyAlertDialog(_scaffoldKey.currentContext);
                  }),
            ],
          ),
          body: RepaintBoundary(
            key: _containerKey,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(0),
                  child: FadeInImage.memoryNetwork(
                      width: screenSide.width,
                      height: screenSide.height,
                      placeholder: kTransparentImage,
                      image: template.backgroundUrl),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0.w, 24.0.h, 20.0.w, 0),
                  child: Visibility(
                      visible: template.name == 'template4' ? true : false,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text('Trận trong mời bạn đến',
                                style: TextStyle(fontSize: 11.0.sp),
                                textAlign: TextAlign.center),
                            Text('dự tiệc cưới của chúng tôi',
                                style: TextStyle(fontSize: 11.0.sp),
                                textAlign: TextAlign.center),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 1.0.h, 0, 1.0.h),
                              child: Text(
                                brideName,
                                style: TextStyle(
                                    fontSize: (brideName.length > 15)
                                        ? 17.0.sp
                                        : 19.0.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text('Và'),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 1.0.h, 0, 1.0.h),
                              child: Text(groomName,
                                  style: TextStyle(
                                      fontSize: (groomName.length > 15)
                                          ? 17.0.sp
                                          : 19.0.sp),
                                  textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0.5.h, 0, 1.0.h),
                              child: Text('Hôn lễ được cử hành vào lúc',
                                  style: TextStyle(fontSize: 13.0.sp),
                                  textAlign: TextAlign.center),
                            ),
                            Text(dateTime,
                                style: TextStyle(fontSize: 14.0.sp),
                                textAlign: TextAlign.center),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 1.0.h, 0, 1.0.h),
                              child: Text('Tại ' + place,
                                  style: TextStyle(
                                      fontSize: (place.length > 15)
                                          ? 12.0.sp
                                          : 14.0.sp),
                                  textAlign: TextAlign.center),
                            ),
                            Text('Sự hiện diện của bạn',
                                style: TextStyle(fontSize: 11.0.sp),
                                textAlign: TextAlign.center),
                            Text('là vinh hạnh của chúng tôi',
                                style: TextStyle(fontSize: 11.0.sp),
                                textAlign: TextAlign.center)
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0.w, 29.0.h, 20.0.w, 0),
                  child: Visibility(
                      visible: template.name == 'template1' ? true : false,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text('Trận trong mời bạn đến',
                                style: TextStyle(
                                    fontSize: 10.0.sp, color: Colors.white),
                                textAlign: TextAlign.center),
                            Text('dự tiệc cưới của chúng tôi',
                                style: TextStyle(
                                    fontSize: 10.0.sp, color: Colors.white),
                                textAlign: TextAlign.center),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0.8.h, 0, 0.8.h),
                              child: Text(
                                brideName,
                                style: TextStyle(
                                    fontSize: (brideName.length > 15)
                                        ? 15.0.sp
                                        : 17.0.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text('Và',
                                style: TextStyle(
                                    fontSize: 10.0.sp, color: Colors.white),
                                textAlign: TextAlign.center),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0.8.h, 0, 0.8.h),
                              child: Text(groomName,
                                  style: TextStyle(
                                      fontSize: (groomName.length > 15)
                                          ? 15.0.sp
                                          : 17.0.sp,
                                      color: Colors.white),
                                  textAlign: TextAlign.center),
                            ),
                            Text(dateTime,
                                style: TextStyle(
                                    fontSize: 12.0.sp, color: Colors.white),
                                textAlign: TextAlign.center),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0.8.h, 0, 0.8.h),
                              child: Text('Tại ' + place,
                                  style: TextStyle(
                                      fontSize: (place.length > 15)
                                          ? 10.0.sp
                                          : 12.0.sp,
                                      color: Colors.white),
                                  textAlign: TextAlign.center),
                            ),
                            Text('Sự hiện diện của bạn',
                                style: TextStyle(
                                    fontSize: 10.0.sp, color: Colors.white),
                                textAlign: TextAlign.center),
                            Text('là vinh hạnh của chúng tôi',
                                style: TextStyle(
                                    fontSize: 10.0.sp, color: Colors.white),
                                textAlign: TextAlign.center)
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        );
      });
    });
  }

  showMyAlertDialog(BuildContext context) {
    GlobalKey _containerKey = GlobalKey();
    // Create AlertDialog
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Lưu lại"),
      content: Text("Bạn có muốn lưu lại mẫu thiệp này?"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: hexToColor("#d86a77")),
            child: Text("Có"),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
              takeScreenShot();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => ChooseTemplatePage(
                      isCreate: true,
                    ),
                  ),
                  (Route<dynamic> route) => false);
            }),
        TextButton(
            style: TextButton.styleFrom(
              primary: hexToColor("#d86a77"),
            ),
            child: Text("Không"),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
            }),
      ],
    );

    // Call showDialog function to show dialog.
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  Future<void> takeScreenShot() async {
    RenderRepaintBoundary renderRepaintBoundary =
        _containerKey.currentContext.findRenderObject();
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
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
        .collection('wedding/$weddingId/invitation_card')
        .doc('1')
        .set({"url": downloadUrl, "name": imgName});
  }
}
