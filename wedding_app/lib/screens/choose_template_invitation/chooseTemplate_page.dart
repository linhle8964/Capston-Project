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
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:wedding_app/utils/hex_color.dart';
import '../../bloc/invitation_card/bloc.dart';
import '../../widgets/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';

class ChooseTemplatePage extends StatefulWidget {
  final bool isCreate;
  const ChooseTemplatePage({Key key, @required this.isCreate})
      : super(key: key);
  @override
  _ChooseTemplatePageState createState() => _ChooseTemplatePageState();
}

class _ChooseTemplatePageState extends State<ChooseTemplatePage> {
  bool get isCreate => widget.isCreate;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences sharedPrefs;

  bool uploading = false;
  List<File> _image = [];
  final picker = ImagePicker();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: hexToColor("#d86a77"),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
              },
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Center(
                      child: Text(
                    'Thiệp mời của bạn',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                Tab(
                  child: Center(
                      child: Text(
                    'Tạo Thiệp Mời',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                Tab(
                  child: Center(
                      child: Text('Tải Lên Thiệp Có Sẵn',
                          style: TextStyle(color: Colors.white))),
                )
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 30, 0),
              child: Text(
                "THIỆP MỜI",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              new MyCard(
                isCreate: isCreate,
              ),
              new CardList(),
              SingleChildScrollView(
                child: loading == false
                    ? Center(
                        child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: Text(
                              'Tải lên từ bộ sưu tập của bạn',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _image.length == 0
                                    ? Container(
                                        width: 250,
                                        height: 350,
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          border: new Border.all(
                                              color: Colors.black, width: 2.0),
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.add),
                                          iconSize: 100,
                                          onPressed: () =>
                                              !uploading ? chooseImage() : null,
                                        ),
                                      )
                                    : Container(
                                        width: 250,
                                        height: 350,
                                        decoration: new BoxDecoration(
                                            image: DecorationImage(
                                                image: FileImage(
                                                    _image[_image.length - 1]),
                                                fit: BoxFit.cover)),
                                        child: IconButton(
                                          icon: Icon(Icons.add),
                                          iconSize: 0,
                                          onPressed: () =>
                                              !uploading ? chooseImage() : null,
                                        ),
                                      ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                            child: SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: TextButton(
                                  style: TextButton.styleFrom(primary: hexToColor("#d86a77")),
                                  onPressed: _image.length > 0
                                      ? () {
                                          setState(() {
                                            uploading = true;
                                          });
                                          uploadFile();
                                          _image = [];
                                        }
                                      : null,
                                  child: Text(
                                    'Tải ảnh lên',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )),
                          )
                        ],
                      ))
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(100, 180, 90, 0),
                        child: Container(child: LoadingIndicator()),
                      ),
              ),
            ],
          )),
    );
  }

  chooseImage() async {
    if (await _requestPermission(Permission.storage)) {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      int bytes = await File(pickedFile?.path).length();
      if (bytes > 5242880) {
        showMyError2Dialog(context);
      } else {
        setState(() {
          _image.add(File(pickedFile?.path));
        });
        if (pickedFile.path == null) retriverLostData();
      }
    }
  }

  Future<void> retriverLostData() async {
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
    setState(() {
      loading = true;
    });
    int i = 1;
    String id = '';
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      String weddingId = prefs.getString('wedding_id');
      id = weddingId;
    });

    var img = _image[_image.length - 1];
    var storage = FirebaseStorage.instance;
    final Directory systemTempDir = Directory.systemTemp;
    final file = File('${systemTempDir.path}/demo.jpeg');
    String imgName = 'IMG_${DateTime.now().microsecondsSinceEpoch}';
    TaskSnapshot taskSnapshot =
        await storage.ref('invitation_card/$imgName').putFile(img);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('wedding/$id/invitation_card')
        .doc('1')
        .set({"url": downloadUrl, "name": imgName}).whenComplete(
            () => showMyAlertDialog(context));
    setState(() {
      loading = false;
    });
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    showMyErrorDialog(context);
    return false;
  }

  showMyErrorDialog(BuildContext context) {
    // Create AlertDialog
    GlobalKey _containerKey = GlobalKey();
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Ứng dụng chưa được cấp quyền"),
      content:
          Text("Bạn cần cấp quyền cho ứng dụng để thực hiện chức năng này!"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: hexToColor("#d86a77")),
            child: Text("Đóng"),
            onPressed: () {
              uploading = false;
              Navigator.of(_containerKey.currentContext).pop();
            }),
      ],
    );

    // Call showDialog function to show dialog.
    Future<String> futureValue = showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  showMyError2Dialog(BuildContext context) {
    // Create AlertDialog
    GlobalKey _containerKey = GlobalKey();
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Ảnh có dung lượng quá lớn"),
      content: Text("Bạn cần chọn ảnh có dung lượng nhỏ hơn 5MB"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: hexToColor("#d86a77")),
            child: Text("Đóng"),
            onPressed: () {
              uploading = false;
              Navigator.of(_containerKey.currentContext).pop();
            }),
      ],
    );

    // Call showDialog function to show dialog.
    Future<String> futureValue = showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  showMyAlertDialog(BuildContext context) {
    // Create AlertDialog
    GlobalKey _containerKey = GlobalKey();
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Lưu lại"),
      content: Text("Mẫu thiệp mới của bạn đã được lưu lại!"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: hexToColor("#d86a77")),
            child: Text("Hoàn thành"),
            onPressed: () {
              uploading = false;

              Navigator.of(_containerKey.currentContext).pop();
            }),
      ],
    );

    // Call showDialog function to show dialog.
    Future<String> futureValue = showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }
}

class MyCard extends StatefulWidget {
  final bool isCreate;
  const MyCard({Key key, @required this.isCreate}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new MyCardState();
  }
}

class MyCardState extends State<MyCard> {
  bool get isCreate => widget.isCreate;
  List<InvitationCard> _invitationCard = [];
  String weddingId = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences sharedPrefs;

  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;
  bool hasCard = true;

  Future<bool> saveImage(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/WeddingApp";
          directory = Directory(newPath);
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path,
            onReceiveProgress: (value1, value2) {
          setState(() {
            progress = value1 / value2;
          });
        });
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    showMyErrorDialog(context);
    return false;
  }

  downloadFile(String url) async {
    setState(() {
      loading = true;
      progress = 0;
    });
    bool downloaded = await saveImage(
        url, 'IMG_${DateTime.now().microsecondsSinceEpoch}.jpg');
    if (downloaded) {
      print("File Downloaded");
    } else {
      print("Problem Downloading File");
    }
    if (progress == 1) {
      showMyAlertDialog(context);
    }
    setState(() {
      loading = false;
    });
  }

  showMyErrorDialog(BuildContext context) {
    // Create AlertDialog
    GlobalKey _containerKey = GlobalKey();
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Ứng dụng chưa được cấp quyền"),
      content:
          Text("Bạn cần cấp quyền cho ứng dụng để thực hiện chức năng này!"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(
              primary: hexToColor("#d86a77"),
            ),
            child: Text("Đóng"),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
            }),
      ],
    );

    // Call showDialog function to show dialog.
    Future<String> futureValue = showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  showMyAlertDialog(BuildContext context) {
    // Create AlertDialog
    GlobalKey _containerKey = GlobalKey();
    AlertDialog dialog = AlertDialog(
      key: _containerKey,
      title: Text("Lưu lại"),
      content: Text("Mẫu thiệp mới của bạn đã được lưu lại!"),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: hexToColor("#d86a77")),
            child: Text("Hoàn thành"),
            onPressed: () {
              Navigator.of(_containerKey.currentContext).pop();
            }),
      ],
    );

    // Call showDialog function to show dialog.
    Future<String> futureValue = showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      weddingId = prefs.getString('wedding_id');
      print(weddingId);
    });

    _invitationCard = [];
  }

  @override
  Widget build(BuildContext context) {
    final screenSide = MediaQuery.of(context).size;
    String imageUrl = '';
    return new Scaffold(
      body: new Container(
        child: BlocBuilder(
          cubit: BlocProvider.of<InvitationCardBloc>(context),
          builder: (context, state) {
            if (weddingId != '') {
              BlocProvider.of<InvitationCardBloc>(context)
                  .add(LoadSuccess(weddingId));
            }
            if (state is InvitationCardLoading) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(140, 200, 50, 0),
                child: Container(child: LoadingIndicator()),
              );
            } else if (state is InvitationCardLoaded) {
              _invitationCard = state.invitations;

              if (_invitationCard.length == 0 && isCreate == false) {
                hasCard = false;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'Hiện tại bạn chưa tạo mẫu thiệp mời nào',
                        style: (TextStyle(fontSize: 16)),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Hãy tạo thiệp mời theo mẫu hoặc tải lên từ bộ sưu tập của bạn',
                        style: (TextStyle(fontSize: 18)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                );
              } else if (_invitationCard.length == 0 && isCreate == true) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(140, 200, 50, 0),
                  child: Container(child: LoadingIndicator()),
                );
              } else {
                return loading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            minHeight: 10,
                            value: progress,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: 1,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          InvitationCard item = _invitationCard[index];
                          imageUrl = item.id;

                          return Stack(
                            alignment: Alignment.bottomRight,
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  child: FadeInImage.memoryNetwork(
                                      width: screenSide.width,
                                      height: screenSide.height,
                                      placeholder: kTransparentImage,
                                      image: item.id),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  child: FloatingActionButton.extended(
                                    onPressed: () => downloadFile(imageUrl),
                                    label: Text('Tải xuống'),
                                    icon: Icon(Icons.download_outlined),
                                    backgroundColor: hexToColor("#d86a77"),
                                  ),
                                ),
                              )
                            ],
                          );
                        });
              }
            }
          },
        ),
      ),
    );
  }
}

class CardList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CardListState();
  }
}

class CardListState extends State<CardList> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<TemplateCard> _templates = [];
  SharedPreferences sharedPrefs;

  @override
  void initState() {
    BlocProvider.of<TemplateCardBloc>(context).add(LoadTemplateCard());
    _templates = [];
  }

  @override
  Widget build(BuildContext context) {
    final screenSide = MediaQuery.of(context).size;
    return new Scaffold(
      body: new Container(
          child: BlocBuilder(
              cubit: BlocProvider.of<TemplateCardBloc>(context),
              builder: (context, state) {
                if (state is TemplateCardLoaded) {
                  _templates = state.template;
                }
                return ListView.builder(
                    itemCount: _templates.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      TemplateCard item = _templates[index];
                      print(index);
                      return Stack(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    FillInfoPage(template: item),
                              ));
                            },
                            child: Container(
                              margin: EdgeInsets.all(3),
                              child: FadeInImage.memoryNetwork(
                                  width: screenSide.width,
                                  height: screenSide.height,
                                  placeholder: kTransparentImage,
                                  image: item.url),
                            ),
                          ),
                        ],
                      );
                    });
              })),
    );
  }
}

void onUploadClick() {}
void onAddClick() {}
