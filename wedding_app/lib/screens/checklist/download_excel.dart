import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/utils/hex_color.dart';
downloadFile(List<Task> tasks, BuildContext context) async {
  if(tasks.length==0){
    showErrorEmtyDialog(context);
  }else{
    
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Công việc'];
    excel.delete('Sheet1');
    CellStyle cellStyle = CellStyle(backgroundColorHex: "#d86a77", fontFamily : getFontFamily(FontFamily.Arial),fontSize: 19,fontColorHex: 'ffffff',bold: true);
    sheetObject.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("F1"));
    var cell = sheetObject.cell(CellIndex.indexByString('A1'));
    cell.value = 'Công việc trong đám cưới của bạn'; // dynamic values support provided;
    cell.cellStyle = cellStyle;

    CellStyle titleCellStyle = CellStyle(backgroundColorHex: "#d86a77", fontFamily : getFontFamily(FontFamily.Arial),fontSize: 12,fontColorHex: 'ffffff');
    List<String> titleList = ["Tên công viẹc", "Mục công việc", "Ngày hạn cuối", 'Quá hạn',"Ghi chú", "Trạng thái"];
    sheetObject.merge(CellIndex.indexByString("A3"), CellIndex.indexByString("B3"));
    sheetObject.merge(CellIndex.indexByString("C3"), CellIndex.indexByString("D3"));
    sheetObject.merge(CellIndex.indexByString("E3"), CellIndex.indexByString("G3"));
    sheetObject.merge(CellIndex.indexByString("H3"), CellIndex.indexByString("I3"));
    sheetObject.merge(CellIndex.indexByString("J3"), CellIndex.indexByString("K3"));
    sheetObject.merge(CellIndex.indexByString("L3"), CellIndex.indexByString("M3"));
    var titleCell0 = sheetObject.cell(CellIndex.indexByString('A3'));
    titleCell0.value = titleList[0];
    titleCell0.cellStyle = titleCellStyle;
    var titleCell1 = sheetObject.cell(CellIndex.indexByString('C3'));
    titleCell1.value = titleList[1];
    titleCell1.cellStyle = titleCellStyle;
    var titleCell2 = sheetObject.cell(CellIndex.indexByString('E3'));
    titleCell2.value = titleList[2];
    titleCell2.cellStyle = titleCellStyle;
    var titleCell3 = sheetObject.cell(CellIndex.indexByString('H3'));
    titleCell3.value = titleList[3];
    titleCell3.cellStyle = titleCellStyle;
    var titleCell4 = sheetObject.cell(CellIndex.indexByString('J3'));
    titleCell4.value = titleList[4];
    titleCell4.cellStyle = titleCellStyle;
    var titleCell5 = sheetObject.cell(CellIndex.indexByString('L3'));
    titleCell5.value = titleList[5];
    titleCell5.cellStyle = titleCellStyle;
    for (int i = 0; i < tasks.length; i++) {
      List<String> dataList =[];
      dataList.add(tasks[i].name);
      dataList.add(tasks[i].category);
      dataList.add(tasks[i].dueDate.toString().substring(0,10));
      if(tasks[i].dueDate.isAfter(DateTime.now())){
        dataList.add('Đang thực hiện ');
      }else{
        dataList.add('Đã quá hạn');
      }
      dataList.add(tasks[i].note);
      if(tasks[i].status){
        dataList.add('Đã hoàn thành');
      }else{
        dataList.add('Chưa hoàn thành');
      }
      sheetObject.merge(CellIndex.indexByString("A"+(4+i).toString()), CellIndex.indexByString("B"+(4+i).toString()));
      sheetObject.merge(CellIndex.indexByString("C"+(4+i).toString()), CellIndex.indexByString("D"+(4+i).toString()));
      sheetObject.merge(CellIndex.indexByString("E"+(4+i).toString()), CellIndex.indexByString("G"+(4+i).toString()));
      sheetObject.merge(CellIndex.indexByString("H"+(4+i).toString()), CellIndex.indexByString("I"+(4+i).toString()));
      sheetObject.merge(CellIndex.indexByString("J"+(4+i).toString()), CellIndex.indexByString("K"+(4+i).toString()));
      sheetObject.merge(CellIndex.indexByString("L"+(4+i).toString()), CellIndex.indexByString("M"+(4+i).toString()));
      var dataCell0 = sheetObject.cell(CellIndex.indexByString("A"+(4+i).toString()));
      dataCell0.value = dataList[0];
      var dataCell1 = sheetObject.cell(CellIndex.indexByString("C"+(4+i).toString()));
      dataCell1.value = dataList[1];
      var dataCell2 = sheetObject.cell(CellIndex.indexByString("E"+(4+i).toString()));
      dataCell2.value = dataList[2];
      var dataCell3 = sheetObject.cell(CellIndex.indexByString("H"+(4+i).toString()));
      dataCell3.value = dataList[3];
      var dataCell4 = sheetObject.cell(CellIndex.indexByString("J"+(4+i).toString()));
      dataCell4.value = dataList[4];
      var dataCell5 = sheetObject.cell(CellIndex.indexByString("L"+(4+i).toString()));
      dataCell5.value = dataList[5];
    }

    bool downloaded = await savefile(
        excel, 'Task_${DateTime.now().microsecondsSinceEpoch}.xlsx');
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
showErrorEmtyDialog(BuildContext context) {
  // Create AlertDialog
  GlobalKey _containerKey = GlobalKey();
  AlertDialog dialog = AlertDialog(
    key: _containerKey,
    title: Text("Chưa lưu"),
    content: Text("Bạn chưa có công việc nào cho đám cưới này"),
    actions: [
      TextButton(
          style: TextButton.styleFrom(primary: hexToColor("#d86a77")),
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

showErrorUnAuthorDialog(BuildContext context) {
  // Create AlertDialog
  GlobalKey _containerKey = GlobalKey();
  AlertDialog dialog = AlertDialog(
    key: _containerKey,
    title: Text("Ứng dụng chưa được cấp quyền"),
    content:
    Text("Bạn cần cấp quyền cho ứng dụng để thực hiện chức năng này!"),
    actions: [
      FlatButton(
          color: hexToColor("#d86a77"),
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