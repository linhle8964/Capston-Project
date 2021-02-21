import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;

class CompleteInvitationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CompleteInvitationPage',
      home: CompleteInvitation(),
    );
  }
}

class CompleteInvitation extends StatefulWidget {
  @override
  _CompleteInvitationState createState() => _CompleteInvitationState();
}
class _CompleteInvitationState extends State<CompleteInvitation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: null,
      ),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(60, 0, 30, 0),
        child: Text(
          "THIỆP MỜI",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    ),
      body: Text('agahh'),
    );
  }
}
