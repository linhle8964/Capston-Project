import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/category.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:wedding_app/utils/hex_color.dart';

downloadFile(List<Budget> budgets, List<Category> categorys,
    BuildContext context) async {
  if (budgets.length == 0) {
    showErrorEmtyDialog(context);
  } else {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Kinh phí'];
    excel.delete('Sheet1');
    CellStyle cellStyle = CellStyle(
        backgroundColorHex: "#d86a77",
        fontFamily: getFontFamily(FontFamily.Arial),
        fontSize: 19,
        fontColorHex: 'ffffff',
        bold: true);
    sheetObject.merge(
        CellIndex.indexByString("A1"), CellIndex.indexByString("F1"));
    var cell = sheetObject.cell(CellIndex.indexByString('A1'));
    cell.value =
        'Chi phí cho đám cưới của bạn'; // dynamic values support provided;
    cell.cellStyle = cellStyle;

    CellStyle titleCellStyle = CellStyle(
        backgroundColorHex: "#d86a77",
        fontFamily: getFontFamily(FontFamily.Arial),
        fontSize: 12,
        fontColorHex: 'ffffff');
    List<String> titleList = [
      "Tên chi phí",
      "Mục chi phí",
      "Số tiền cần chi",
      "Số tiền đã chi",
      "Trạng thái"
    ];
    sheetObject.merge(
        CellIndex.indexByString("A3"), CellIndex.indexByString("B3"));
    sheetObject.merge(
        CellIndex.indexByString("C3"), CellIndex.indexByString("D3"));
    sheetObject.merge(
        CellIndex.indexByString("E3"), CellIndex.indexByString("F3"));
    sheetObject.merge(
        CellIndex.indexByString("G3"), CellIndex.indexByString("H3"));
    sheetObject.merge(
        CellIndex.indexByString("I3"), CellIndex.indexByString("J3"));
    var titleCell0 = sheetObject.cell(CellIndex.indexByString('A3'));
    titleCell0.value = titleList[0];
    titleCell0.cellStyle = titleCellStyle;
    var titleCell1 = sheetObject.cell(CellIndex.indexByString('C3'));
    titleCell1.value = titleList[1];
    titleCell1.cellStyle = titleCellStyle;
    var titleCell2 = sheetObject.cell(CellIndex.indexByString('E3'));
    titleCell2.value = titleList[2];
    titleCell2.cellStyle = titleCellStyle;
    var titleCell3 = sheetObject.cell(CellIndex.indexByString('G3'));
    titleCell3.value = titleList[3];
    titleCell3.cellStyle = titleCellStyle;
    var titleCell4 = sheetObject.cell(CellIndex.indexByString('I3'));
    titleCell4.value = titleList[4];
    titleCell4.cellStyle = titleCellStyle;

    for (int i = 0; i < budgets.length; i++) {
      List<String> dataList = [];
      dataList.add(budgets[i].budgetName);
      for (int j = 0; j < categorys.length; j++) {
        if (budgets[i].cateID == categorys[j].id) {
          dataList.add(categorys[j].cateName);
          break;
        }
      }
      dataList.add(budgets[i].money.toString());
      dataList.add(budgets[i].payMoney.toString());
      if (budgets[i].isComplete) {
        dataList.add('Hoàn thành');
      } else {
        dataList.add('Chưa hoàn thành');
      }
      sheetObject.merge(CellIndex.indexByString("A" + (4 + i).toString()),
          CellIndex.indexByString("B" + (4 + i).toString()));
      sheetObject.merge(CellIndex.indexByString("C" + (4 + i).toString()),
          CellIndex.indexByString("D" + (4 + i).toString()));
      sheetObject.merge(CellIndex.indexByString("E" + (4 + i).toString()),
          CellIndex.indexByString("F" + (4 + i).toString()));
      sheetObject.merge(CellIndex.indexByString("G" + (4 + i).toString()),
          CellIndex.indexByString("H" + (4 + i).toString()));
      sheetObject.merge(CellIndex.indexByString("I" + (4 + i).toString()),
          CellIndex.indexByString("J" + (4 + i).toString()));
      var dataCell0 =
          sheetObject.cell(CellIndex.indexByString("A" + (4 + i).toString()));
      dataCell0.value = dataList[0];
      var dataCell1 =
          sheetObject.cell(CellIndex.indexByString("C" + (4 + i).toString()));
      dataCell1.value = dataList[1];
      var dataCell2 =
          sheetObject.cell(CellIndex.indexByString("E" + (4 + i).toString()));
      dataCell2.value = dataList[2];
      var dataCell3 =
          sheetObject.cell(CellIndex.indexByString("G" + (4 + i).toString()));
      dataCell3.value = dataList[3];
      var dataCell4 =
          sheetObject.cell(CellIndex.indexByString("I" + (4 + i).toString()));
      dataCell4.value = dataList[4];
    }

    bool downloaded = await savefile(
        excel, 'Budget_${DateTime.now().microsecondsSinceEpoch}.xlsx');
    if (downloaded) {
      print("File Downloaded");
      showCompleteDialog(context);
    } else {
      print("Problem Downloading File");
      showErrorUnAuthorDialog(context);
    }
  }
}

Future<bool> savefile(
  Excel excel,
  String fileName,
) async {
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
          child: Text(
            "Hoàn thành",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(_containerKey.currentContext).pop();
          }),
    ],
  );

  // Call showDialog function to show dialog.
  // Future<String> futureValue = showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return dialog;
  //     });
}

showErrorEmtyDialog(BuildContext context) {
  // Create AlertDialog
  GlobalKey _containerKey = GlobalKey();
  AlertDialog dialog = AlertDialog(
    key: _containerKey,
    title: Text("Chưa lưu"),
    content: Text("Bạn chưa có khoản chi tiêu nào cho đám cưới này"),
    actions: [
      TextButton(
          style: TextButton.styleFrom(backgroundColor: hexToColor("#d86a77")),
          child: Text(
            "Đóng",
            style: TextStyle(color: Colors.white),
          ),
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
    content: Text("Bạn cần cấp quyền cho ứng dụng để thực hiện chức năng này!"),
    actions: [
      TextButton(
          style: TextButton.styleFrom(backgroundColor: hexToColor("#d86a77")),
          child: Text(
            "Đóng",
            style: TextStyle(color: Colors.white),
          ),
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
