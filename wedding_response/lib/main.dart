import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_diary/entity/wedding_entity.dart';
import 'package:flutter_web_diary/model/wedding.dart';
import 'package:flutter_web_diary/util/wedding_guest_router_delegate.dart';
import 'package:flutter_web_diary/util/wedding_route_information_parser.dart';
import 'bloc/wedding/bloc.dart';
import 'bloc/wedding/wedding_bloc.dart';
import 'bloc/wedding/wedding_event.dart';
import 'firebase_repository/wedding_firebase_repository.dart';

void main() async {
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _routerDelegate = WeddingGuestRouterDelegate();
  final _routeInformationParser = WeddingGuestRouteInformationParser();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
