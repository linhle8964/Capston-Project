import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/utils/hex_color.dart';
downloadFile(List<Guest> guests, BuildContext context, String role) async {
  if(guests.length==0){
    showErrorEmtyDialog(context);
  }else{

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Khách mời'];
    excel.delete('Sheet1');
    CellStyle cellStyle = CellStyle(backgroundColorHex: "#d86a77", fontFamily : getFontFamily(FontFamily.Arial),fontSize: 19,fontColorHex: 'ffffff',bold: true);
    sheetObject.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("E1"));
    var cell = sheetObject.cell(CellIndex.indexByString('A1'));
    cell.value = 'Danh sách khách mời'; // dynamic values support provided;
    cell.cellStyle = cellStyle;

    if(role != 'wedding_admin'){
      CellStyle titleCellStyle = CellStyle(backgroundColorHex: "#d86a77", fontFamily : getFontFamily(FontFamily.Arial),fontSize: 12,fontColorHex: 'ffffff');
      List<String> titleListEditor = ["Tên khách mời", "Phân loại khách mời", "Số điện thoại", 'Số khách đi cùng','Lời chúc mừng',"Ghi chú", "Trạng thái"];
      sheetObject.merge(CellIndex.indexByString("A3"), CellIndex.indexByString("B3"));
      sheetObject.merge(CellIndex.indexByString("C3"), CellIndex.indexByString("E3"));
      sheetObject.merge(CellIndex.indexByString("F3"), CellIndex.indexByString("G3"));
      sheetObject.merge(CellIndex.indexByString("H3"), CellIndex.indexByString("I3"));
      sheetObject.merge(CellIndex.indexByString("J3"), CellIndex.indexByString("K3"));
      sheetObject.merge(CellIndex.indexByString("L3"), CellIndex.indexByString("M3"));
      sheetObject.merge(CellIndex.indexByString("N3"), CellIndex.indexByString("O3"));
      var titleCell0 = sheetObject.cell(CellIndex.indexByString('A3'));
      titleCell0.value = titleListEditor[0];
      titleCell0.cellStyle = titleCellStyle;
      var titleCell1 = sheetObject.cell(CellIndex.indexByString('C3'));
      titleCell1.value = titleListEditor[1];
      titleCell1.cellStyle = titleCellStyle;
      var titleCell2 = sheetObject.cell(CellIndex.indexByString('F3'));
      titleCell2.value = titleListEditor[2];
      titleCell2.cellStyle = titleCellStyle;
      var titleCell3 = sheetObject.cell(CellIndex.indexByString('H3'));
      titleCell3.value = titleListEditor[3];
      titleCell3.cellStyle = titleCellStyle;
      var titleCell4 = sheetObject.cell(CellIndex.indexByString('J3'));
      titleCell4.value = titleListEditor[4];
      titleCell4.cellStyle = titleCellStyle;
      var titleCell5 = sheetObject.cell(CellIndex.indexByString('L3'));
      titleCell5.value = titleListEditor[5];
      titleCell5.cellStyle = titleCellStyle;
      var titleCell6 = sheetObject.cell(CellIndex.indexByString('N3'));
      titleCell6.value = titleListEditor[6];
      titleCell6.cellStyle = titleCellStyle;
      for (int i = 0; i < guests.length; i++) {
        List<String> dataList =[];
        dataList.add(guests[i].name);
        if(guests[i].type==0){
          dataList.add('Chưa sắp xếp ');
        }else if(guests[i].type==1){
          dataList.add('Khách nhà trai');
        }else if(guests[i].type==2) {
          dataList.add('Khách nhà gái');
        }
        dataList.add(guests[i].phone);
        if(guests[i].companion==0){
          dataList.add('0');
        }else{
          dataList.add(guests[i].companion.toString());
        }
        dataList.add(guests[i].congrat);
        dataList.add(guests[i].description);
        if(guests[i].status==0){
          dataList.add('Chưa trả lời');
        }else if((guests[i].status==1)){
          dataList.add('Khách sẽ tới');
        }else if(guests[i].status==2){
          dataList.add('Khách sẽ không tới');
        }
        sheetObject.merge(CellIndex.indexByString("A"+(4+i).toString()), CellIndex.indexByString("B"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("C"+(4+i).toString()), CellIndex.indexByString("E"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("F"+(4+i).toString()), CellIndex.indexByString("G"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("H"+(4+i).toString()), CellIndex.indexByString("I"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("J"+(4+i).toString()), CellIndex.indexByString("K"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("L"+(4+i).toString()), CellIndex.indexByString("M"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("N"+(4+i).toString()), CellIndex.indexByString("O"+(4+i).toString()));
        var dataCell0 = sheetObject.cell(CellIndex.indexByString("A"+(4+i).toString()));
        dataCell0.value = dataList[0];
        var dataCell1 = sheetObject.cell(CellIndex.indexByString("C"+(4+i).toString()));
        dataCell1.value = dataList[1];
        var dataCell2 = sheetObject.cell(CellIndex.indexByString("F"+(4+i).toString()));
        dataCell2.value = dataList[2];
        var dataCell3 = sheetObject.cell(CellIndex.indexByString("H"+(4+i).toString()));
        dataCell3.value = dataList[3];
        var dataCell4 = sheetObject.cell(CellIndex.indexByString("J"+(4+i).toString()));
        dataCell4.value = dataList[4];
        var dataCell5 = sheetObject.cell(CellIndex.indexByString("L"+(4+i).toString()));
        dataCell5.value = dataList[5];
        var dataCell6 = sheetObject.cell(CellIndex.indexByString("N"+(4+i).toString()));
        dataCell6.value = dataList[6];
      }
    }else{
      CellStyle titleCellStyle = CellStyle(backgroundColorHex: "#d86a77", fontFamily : getFontFamily(FontFamily.Arial),fontSize: 12,fontColorHex: 'ffffff');
      List<String> titleListAdmin = ["Tên khách mời", "Phân loại khách mời", "Số điện thoại", 'Số khách đi cùng','Lời chúc mừng',"Ghi chú", "Trạng thái",'Số tiền mừng'];
      sheetObject.merge(CellIndex.indexByString("A3"), CellIndex.indexByString("B3"));
      sheetObject.merge(CellIndex.indexByString("C3"), CellIndex.indexByString("E3"));
      sheetObject.merge(CellIndex.indexByString("F3"), CellIndex.indexByString("G3"));
      sheetObject.merge(CellIndex.indexByString("H3"), CellIndex.indexByString("I3"));
      sheetObject.merge(CellIndex.indexByString("J3"), CellIndex.indexByString("K3"));
      sheetObject.merge(CellIndex.indexByString("L3"), CellIndex.indexByString("M3"));
      sheetObject.merge(CellIndex.indexByString("N3"), CellIndex.indexByString("O3"));
      sheetObject.merge(CellIndex.indexByString("P3"), CellIndex.indexByString("Q3"));
      var titleCell0 = sheetObject.cell(CellIndex.indexByString('A3'));
      titleCell0.value = titleListAdmin[0];
      titleCell0.cellStyle = titleCellStyle;
      var titleCell1 = sheetObject.cell(CellIndex.indexByString('C3'));
      titleCell1.value = titleListAdmin[1];
      titleCell1.cellStyle = titleCellStyle;
      var titleCell2 = sheetObject.cell(CellIndex.indexByString('F3'));
      titleCell2.value = titleListAdmin[2];
      titleCell2.cellStyle = titleCellStyle;
      var titleCell3 = sheetObject.cell(CellIndex.indexByString('H3'));
      titleCell3.value = titleListAdmin[3];
      titleCell3.cellStyle = titleCellStyle;
      var titleCell4 = sheetObject.cell(CellIndex.indexByString('J3'));
      titleCell4.value = titleListAdmin[4];
      titleCell4.cellStyle = titleCellStyle;
      var titleCell5 = sheetObject.cell(CellIndex.indexByString('L3'));
      titleCell5.value = titleListAdmin[5];
      titleCell5.cellStyle = titleCellStyle;
      var titleCell6 = sheetObject.cell(CellIndex.indexByString('N3'));
      titleCell6.value = titleListAdmin[6];
      titleCell6.cellStyle = titleCellStyle;
      var titleCell7 = sheetObject.cell(CellIndex.indexByString('P3'));
      titleCell7.value = titleListAdmin[7];
      titleCell7.cellStyle = titleCellStyle;
      for (int i = 0; i < guests.length; i++) {
        List<String> dataList =[];
        dataList.add(guests[i].name);
        if(guests[i].type==0){
          dataList.add('Chưa sắp xếp ');
        }else if(guests[i].type==1){
          dataList.add('Khách nhà trai');
        }else if(guests[i].type==2) {
          dataList.add('Khách nhà gái');
        }
        dataList.add(guests[i].phone);
        if(guests[i].companion==0){
          dataList.add('0');
        }else{
          dataList.add(guests[i].companion.toString());
        }
        dataList.add(guests[i].congrat);
        dataList.add(guests[i].description);
        if(guests[i].status==0){
          dataList.add('Chưa trả lời');
        }else if((guests[i].status==1)){
          dataList.add('Khách sẽ tới');
        }else if(guests[i].status==2){
          dataList.add('Khách sẽ không tới');
        }
        if(guests[i].money==0){
          dataList.add('Khách chưa mừng');
        }else{
          dataList.add(guests[i].money.toString());
        }
        sheetObject.merge(CellIndex.indexByString("A"+(4+i).toString()), CellIndex.indexByString("B"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("C"+(4+i).toString()), CellIndex.indexByString("E"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("F"+(4+i).toString()), CellIndex.indexByString("G"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("H"+(4+i).toString()), CellIndex.indexByString("I"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("J"+(4+i).toString()), CellIndex.indexByString("K"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("L"+(4+i).toString()), CellIndex.indexByString("M"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("N"+(4+i).toString()), CellIndex.indexByString("O"+(4+i).toString()));
        sheetObject.merge(CellIndex.indexByString("P"+(4+i).toString()), CellIndex.indexByString("Q"+(4+i).toString()));
        var dataCell0 = sheetObject.cell(CellIndex.indexByString("A"+(4+i).toString()));
        dataCell0.value = dataList[0];
        var dataCell1 = sheetObject.cell(CellIndex.indexByString("C"+(4+i).toString()));
        dataCell1.value = dataList[1];
        var dataCell2 = sheetObject.cell(CellIndex.indexByString("F"+(4+i).toString()));
        dataCell2.value = dataList[2];
        var dataCell3 = sheetObject.cell(CellIndex.indexByString("H"+(4+i).toString()));
        dataCell3.value = dataList[3];
        var dataCell4 = sheetObject.cell(CellIndex.indexByString("J"+(4+i).toString()));
        dataCell4.value = dataList[4];
        var dataCell5 = sheetObject.cell(CellIndex.indexByString("L"+(4+i).toString()));
        dataCell5.value = dataList[5];
        var dataCell6 = sheetObject.cell(CellIndex.indexByString("N"+(4+i).toString()));
        dataCell6.value = dataList[6];
        var dataCell7 = sheetObject.cell(CellIndex.indexByString("P"+(4+i).toString()));
        dataCell7.value = dataList[7];
      }
    }


    bool downloaded = await savefile(
        excel, 'Guest_${DateTime.now().microsecondsSinceEpoch}.xlsx');
    if (downloaded) {
      print("File Downloaded");
      showCompleteDialog(context);
    } else {
      print("Problem Downloading File");
      showErrorUnAuthorDialog(context);
    }
  }
}

Future<bool> savefile(Excel excel, String fileName, ) async {
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
      await excel.encode().then((onValue) {
        File(join(saveFile.path))
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
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
  return false;
}
showCompleteDialog(BuildContext context) {
  // Create AlertDialog
  GlobalKey _containerKey = GlobalKey();
  AlertDialog dialog = AlertDialog(
    key: _containerKey,
    title: Text("Lưu lại"),
    content: Text("File của bạn đã được lưu lại!"),
    actions: [
      TextButton(
          style: TextButton.styleFrom(backgroundColor: hexToColor("#d86a77")),
          child: Text("Hoàn thành",style: TextStyle(color: Colors.white),),
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
showErrorEmtyDialog(BuildContext context) {
  // Create AlertDialog
  GlobalKey _containerKey = GlobalKey();
  AlertDialog dialog = AlertDialog(
    key: _containerKey,
    title: Text("Chưa lưu"),
    content: Text("Bạn chưa có khách nào trong đám cưới này"),
    actions: [
      TextButton(
          style: TextButton.styleFrom(backgroundColor: hexToColor("#d86a77")),
          child: Text("Đóng",style: TextStyle(color: Colors.white),),
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

showErrorUnAuthorDialog(BuildContext context) {
  // Create AlertDialog
  GlobalKey _containerKey = GlobalKey();
  AlertDialog dialog = AlertDialog(
    key: _containerKey,
    title: Text("Ứng dụng chưa được cấp quyền"),
    content:
    Text("Bạn cần cấp quyền cho ứng dụng để thực hiện chức năng này!"),
    actions: [
      TextButton(
          style: TextButton.styleFrom(backgroundColor: hexToColor("#d86a77")),
          child: Text("Đóng",style: TextStyle(color: Colors.white),),
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