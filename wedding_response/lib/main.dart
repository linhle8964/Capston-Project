import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_diary/bloc/authentication/authentication_event.dart';
import 'package:flutter_web_diary/entity/wedding_entity.dart';
import 'package:flutter_web_diary/firebase_repository/user_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:flutter_web_diary/model/wedding.dart';
import 'package:flutter_web_diary/util/admin_vendor_router_delegate.dart';
import 'package:flutter_web_diary/util/admin_vendor_route_information_parser.dart';
import 'bloc/wedding/bloc.dart';
import 'bloc/wedding/wedding_bloc.dart';
import 'bloc/wedding/wedding_event.dart';
import 'firebase_repository/wedding_firebase_repository.dart';
import 'package:flutter_web_diary/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_web_diary/repository/user_repository.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:universal_platform/universal_platform.dart';
import 'package:desktop_window/desktop_window.dart';
void main() async {
  setPathUrlStrategy();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _routerDelegate = AdminVendorRouterDelegate();
  final _routeInformationParser = AdminVendorRouteInformationParser();
  

  @override
  void initState() {
    // TODO: implement initState
    //testWindowFunctions();
    super.initState();
  }
  Future testWindowFunctions() async {
    Size size = await DesktopWindow.getWindowSize();
    print(size);
    await DesktopWindow.setWindowSize(Size(500,500));

    await DesktopWindow.setMinWindowSize(Size(400,400));
    await DesktopWindow.setMaxWindowSize(Size(800,800));

    await DesktopWindow.resetMaxWindowSize();
    await DesktopWindow.toggleFullScreen();
    bool isFullScreen = await DesktopWindow.getFullScreen();
    await DesktopWindow.setFullScreen(true);
    await DesktopWindow.setFullScreen(false);
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wedding Invitation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans'),
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}
