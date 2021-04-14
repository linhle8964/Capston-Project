import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_diary/screen/views/allvendor/all_vendor_page.dart';
import 'package:flutter_web_diary/screen/widgets/centered_view/centered_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_diary/bloc/vendor/bloc.dart';
import 'package:flutter_web_diary/bloc/category/bloc.dart';
import 'package:flutter_web_diary/model/vendor.dart';
import 'package:flutter_web_diary/model/category.dart';
import 'package:flutter_web_diary/util/hex_color.dart';
import 'package:flutter_web_diary/util/show_snackbar.dart';
import 'package:flutter_web_diary/screen/widgets/confirm_dialog.dart';
import 'package:flutter_web_diary/screen/widgets/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class AddVendorDesktopPage extends StatefulWidget {
  @override
  _AddVendorDesktopPageState createState() => _AddVendorDesktopPageState();
}

// Future<String> loadData() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   return preferences.getString(nameKey);
// }
class _AddVendorDesktopPageState extends State<AddVendorDesktopPage> {
  final numRegex = RegExp(r'^[^a-zA-Z\,!@#$%^&*()_+=-]+$');
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  var storage = FirebaseStorage.instance;
  CateBloc _cateBloc;
  Category holder;
  Category selectedCate;
  List<Category> _values2 = [];
  String vendorId = "";
  String frontImageUrl = '';
  String ownerImageUrl = '';
  Category initialCate = new Category("", "");
  TextEditingController vendorNameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController labelController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController frontImageController = new TextEditingController();
  TextEditingController ownerImageController = new TextEditingController();
  List<Uint8List> _frontImageData = [];
  List<Uint8List> _ownerImageData = [];
  List<String> _frontImageName = [];
  List<String> _ownerImageName = [];
  bool uploading = false;
  final picker = ImagePicker();
  SharedPreferences sharedPrefs;
  final _formkey = GlobalKey<FormState>();
  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

  @override
  void initState() {
    super.initState();
    _cateBloc = BlocProvider.of<CateBloc>(context);

    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      vendorId = "";
      vendorNameController.text = "";
      descriptionController.text = "";
      emailController.text = "";
      labelController.text = "";
      locationController.text = "";
      phoneController.text = "";
      //holder = Category(widget.vendor.cateID, "");
    });
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CateBloc>(context).add(LoadTodos());
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    int maxLines = 3;

    return BlocBuilder(
        cubit: BlocProvider.of<VendorBloc>(context),
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                leading: Icon(
                  Icons.add_alarm_outlined,
                  color: hexToColor("#d86a77"),
                ),
                backgroundColor: hexToColor("#d86a77"),
                bottomOpacity: 0.0,
                elevation: 0.0,
                title: Center(child: Text("Thêm dịch vụ")),
                actions: [
                  Builder(
                      builder: (ctx) => Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.check,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          PersonDetailsDialog(
                                            message: "Bạn đang thêm dịch vụ",
                                            onPressedFunction: () {
                                              updateVendor();
                                            },
                                          ));
                                },
                              ),
                            ],
                          )),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(
                    queryData.size.width * 5 / 20,
                    queryData.size.height / 40,
                    queryData.size.width * 5 / 20,
                    0),
                child: Center(
                    child: SingleChildScrollView(
                        child: SizedBox(
                  height: queryData.size.height,
                  width: queryData.size.width,
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                                controller: vendorNameController,
                                validator: (val) {
                                  if (val == "") {
                                    showFailedSnackbar(context,
                                        "Xin Vui Lòng Nhập Tên Dịch Vụ");
                                    return "Tên Dịch Vụ không được để trống";
                                  } else if (val.length > 20) {
                                    showFailedSnackbar(context,
                                        "Xin Vui Lòng Nhập Tên Dịch Vụ Dưới 20 Kí Tự");
                                    return "Tên Dịch Vụ chỉ được dưới 20 kí tự";
                                  }
                                  return null;
                                },
                                decoration: new InputDecoration(
                                    labelText: 'Tên Dịch Vụ',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2.0),
                                    ),
                                    hintText: 'Tên Dịch Vụ')),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  width: queryData.size.width / 4,
                                  child: TextFormField(
                                      controller: labelController,
                                      validator: (val) {
                                        if (val == "") {
                                          showFailedSnackbar(context,
                                              "Xin Vui Lòng Nhập Nhãn Hiệu ");
                                          return "Nhãn Hiệu không được để trống";
                                        } else if (val.length > 20) {
                                          showFailedSnackbar(context,
                                              "Xin Vui Lòng Nhập Nhãn Hiệu Dưới 20 Kí Tự");
                                          return "Nhãn Hiệu chỉ được dưới 20 kí tự";
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                        labelText: 'Nhãn Hiệu',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0),
                                        ),
                                        hintText: 'Nhãn Hiệu',
                                      ))),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  width: queryData.size.width / 4,
                                  child: TextFormField(
                                      controller: phoneController,
                                      validator: (val) {
                                        if (val == "") {
                                          showFailedSnackbar(context,
                                              "Xin Vui Lòng Nhập Số Điện Thoại");
                                          return "Số điện thoại không được để trống";
                                        } else if (!numRegex.hasMatch(val)) {
                                          showFailedSnackbar(context,
                                              "Xin vui lòng nhập số điện thoại chỉ gồm các chữ số");
                                          return "Số điện thoại chỉ được phép có số";
                                        } else if (val.length != 10) {
                                          showFailedSnackbar(context,
                                              "Xin vui lòng nhập số điện thoại gồm 10 chữ số");
                                          return "Số điện thoại chỉ được phép có 10 chữ số";
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                        labelText: 'Số điện thoại',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0),
                                        ),
                                        hintText: 'Số điện thoại',
                                      ))),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: TextFormField(
                              controller: emailController,
                              validator: (val) {
                                if (val == "") {
                                  showFailedSnackbar(
                                      context, "Xin Vui Lòng Nhập email");
                                  return "Email không được để trống";
                                } else if (!emailRegex.hasMatch(val)) {
                                  showFailedSnackbar(
                                      context, "Email không hợp lệ");
                                  return "Email không hợp lệ";
                                }else if (val.length > 36) {
                                    showFailedSnackbar(context,
                                        "Xin Vui Lòng Nhập Email Dưới 36 Kí Tự");
                                    return "Email chỉ được dưới 36 kí tự";
                                  }
                                return null;
                              },
                              decoration: new InputDecoration(
                                  labelText: 'Email',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  hintText: 'Email')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: BlocBuilder(
                              cubit: _cateBloc,
                              builder: (context, state) {
                                if (state is TodosLoaded) {
                                  _values2 = state.cates;

                                  return DropdownButtonFormField(
                                    value: selectedCate,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    isExpanded: true,
                                    style: TextStyle(color: Colors.deepPurple),
                                    items: _values2.map((Category cate) {
                                      return DropdownMenuItem<Category>(
                                        value: cate,
                                        child: Text(cate.cateName),
                                      );
                                    }).toList(),
                                    onChanged: (val) =>
                                        setState(() => selectedCate = val),
                                    onSaved: (val) => selectedCate = val,
                                    validator: (val) {
                                      if (val == null) {
                                        showFailedSnackbar(context,
                                            "Xin Vui Lòng Chọn Loại Dịch Vụ");
                                        return "Loại dịch vụ không được để trống";
                                      }
                                      return null;
                                    },
                                  );
                                } else if (state is TodosLoading) {
                                  return LoadingIndicator();
                                } else if (state is TodosNotLoaded) {}
                                return LoadingIndicator();
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: TextFormField(
                              controller: locationController,
                              validator: (val) {
                                if (val == "") {
                                  showFailedSnackbar(
                                      context, "Xin Vui Lòng Nhập Địa Chỉ");
                                  return "Địa chỉ không được để trống";
                                }else if (val.length > 50) {
                                    showFailedSnackbar(context,
                                        "Xin Vui Lòng Nhập Miêu Tả Dưới 50 Kí Tự");
                                    return "Miêu tả chỉ được dưới 50 kí tự";
                                  }
                                return null;
                              },
                              decoration: new InputDecoration(
                                  labelText: 'Địa chỉ',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  hintText: 'Địa chỉ')),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: TextFormField(
                              controller: descriptionController,
                              validator: (val) {
                                if (val == "") {
                                  showFailedSnackbar(
                                      context, "Xin Vui Lòng Nhập Miêu Tả ");
                                  return "Miêu Tả  không được để trống";
                                }else if (val.length > 100) {
                                    showFailedSnackbar(context,
                                        "Xin Vui Lòng Nhập Miêu Tả Dưới 100 Kí Tự");
                                    return "Miêu tả chỉ được dưới 100 kí tự";
                                  }
                                return null;
                              },
                              decoration: new InputDecoration(
                                  labelText: 'Miêu Tả',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  hintText: 'Miêu Tả')),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: _frontImageData.length == 0
                                  ? Container(
                                      child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                              width: queryData.size.width / 5,
                                              child: TextFormField(
                                                  enabled: false,
                                                  controller:
                                                      frontImageController,
                                                  decoration:
                                                      new InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue,
                                                          width: 2.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0),
                                                    ),
                                                    hintText: 'Ảnh Dịch Vụ',
                                                  ))),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              primary: hexToColor("#d86a77")),
                                          onPressed: () => !uploading
                                              ? chooseImage(true)
                                              : null,
                                          child: Text(
                                            'Chọn ảnh dịch vụ ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ))
                                  : Container(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                                width: queryData.size.width / 5,
                                                child: TextFormField(
                                                    enabled: false,
                                                    controller:
                                                        frontImageController,
                                                    decoration:
                                                        new InputDecoration(
                                                      labelText: _frontImageName
                                                                  .length ==
                                                              0
                                                          ? ""
                                                          : _frontImageName[
                                                              _frontImageName
                                                                      .length -
                                                                  1],
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.blue,
                                                            width: 2.0),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0),
                                                      ),
                                                      hintText: 'Ảnh Dịch Vụ',
                                                    ))),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                primary: hexToColor("#d86a77")),
                                            onPressed: () => !uploading
                                                ? chooseImage(true)
                                                : null,
                                            child: Text(
                                              'Chọn ảnh dịch vụ ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: _frontImageData.length == 0
                                  ? Container(
                                      child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                              width: queryData.size.width / 5,
                                              child: TextFormField(
                                                  enabled: false,
                                                  controller:
                                                      ownerImageController,
                                                  decoration:
                                                      new InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue,
                                                          width: 2.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0),
                                                    ),
                                                    hintText: 'Ảnh Logo',
                                                  ))),
                                        ),
                                        TextButton(
                                          onPressed: () => !uploading
                                              ? chooseImage(true)
                                              : null,
                                          child: Text(
                                            'Chọn ảnh Logo ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ))
                                  : Container(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                                width: queryData.size.width / 5,
                                                child: TextFormField(
                                                    enabled: false,
                                                    controller:
                                                        ownerImageController,
                                                    decoration:
                                                        new InputDecoration(
                                                      labelText: _ownerImageName
                                                                  .length ==
                                                              0
                                                          ? ""
                                                          : _ownerImageName[
                                                              _ownerImageName
                                                                      .length -
                                                                  1],
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.blue,
                                                            width: 2.0),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0),
                                                      ),
                                                      hintText: 'Ảnh Dịch Vụ',
                                                    ))),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                primary: hexToColor("#d86a77")),
                                            onPressed: () => !uploading
                                                ? chooseImage(false)
                                                : null,
                                            child: Text(
                                              'Chọn ảnh logo ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            )),
                      ],
                    ),
                  ),
                ))),
              ));
        });
  }

  void chooseImage(bool type) async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (pickedFile != null) {
      int bytes = pickedFile.files.single.size;
      if (bytes > 5242880) {
        showMyError2Dialog(context);
      } else {
        if (type) {
          setState(() {
            _frontImageData.add(pickedFile.files.single.bytes);
            _frontImageName.add(pickedFile.files.single.name);
          });
          Uint8List frontImagedata =
              _frontImageData[_frontImageData.length - 1];
          String frontImageName = _frontImageName[_frontImageName.length - 1];
          TaskSnapshot frontSnapshot = await storage
              .ref('vendor/$frontImageName')
              .putData(frontImagedata);
          frontImageUrl = await frontSnapshot.ref.getDownloadURL();
        } else {
          setState(() {
            _ownerImageData.add(pickedFile.files.single.bytes);
            _ownerImageName.add(pickedFile.files.single.name);
          });
          Uint8List ownerImagedata =
              _ownerImageData[_ownerImageData.length - 1];
          String ownerImageName = _ownerImageName[_ownerImageName.length - 1];
          TaskSnapshot taskSnapshot = await storage
              .ref('vendor/$ownerImageName')
              .putData(ownerImagedata);
          ownerImageUrl = await taskSnapshot.ref.getDownloadURL();
        }
      }
    }
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

  void updateVendor() {
    if (_formkey.currentState.validate()) {
      bool _isSet = false;

      if (selectedCate != null &&
          selectedCate.cateName.trim().isNotEmpty &&
          labelController.text.trim().isNotEmpty &&
          vendorNameController.text.trim().isNotEmpty &&
          locationController.text.trim().isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty) {
        Vendor vendor = new Vendor(
            labelController.text,
            vendorNameController.text,
            selectedCate == null ? initialCate.id : selectedCate.id,
            locationController.text,
            descriptionController.text,
            frontImageUrl,
            ownerImageUrl,
            emailController.text,
            phoneController.text);
        BlocProvider.of<VendorBloc>(context).add(AddVendor(vendor));
        Navigator.pop(context);

        _isSet = true;
      } else if (_isSet == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('có lỗi xảy ra'),
          ),
        );
      }
    }
  }
}
