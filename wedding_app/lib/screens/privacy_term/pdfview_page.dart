import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';

class PDFViewPage extends StatefulWidget {
  final String name;

  const PDFViewPage({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  String _title;
  String _localPath;
  String _fileName;
  String _localFile;

  @override
  void initState() {
    super.initState();
    switch(widget.name){
      case "privacy":
        _title = "Chính sách bảo mật";
        _localPath = "assets/pdf/privacy_policy.pdf";
        _fileName = "privacypolicy.pdf";
        break;
      case "term":
        _title = "Điều khoản sử dụng";
        _localPath = "assets/pdf/term_of_use.pdf";
        _fileName = "termofuse.pdf";
        break;
    }

    fromAsset(_localPath, _fileName).then((f) {
      setState(() {
        _localFile = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#d86a77"),
        title: Text(_title),
      ),
      body: _localFile!=null? Container(
        child: PDFView(
          filePath: _localFile,
          autoSpacing: false,
        ),
      ):Center(child: LoadingIndicator()),
    );
  }
}