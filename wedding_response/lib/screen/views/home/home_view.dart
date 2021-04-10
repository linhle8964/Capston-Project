import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_diary/bloc/guests/bloc.dart';
import 'package:flutter_web_diary/bloc/wedding/bloc.dart';
import 'package:flutter_web_diary/firebase_repository/guest_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/wedding_firebase_repository.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/model/vendor.dart';
import 'package:flutter_web_diary/model/wedding.dart';
import 'package:flutter_web_diary/screen/views/error/error_page.dart';
import 'package:flutter_web_diary/screen/views/home/home_view_desktop.dart';
import 'package:flutter_web_diary/screen/views/home/home_view_tablet_mobile.dart';
import 'package:flutter_web_diary/screen/widgets/centered_view/centered_view.dart';
import 'package:flutter_web_diary/util/globle_variable.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
 final ValueChanged<Vendor> onTapped;
  final ValueChanged<bool> onAdd;
   final ValueChanged<bool> onHome;
   HomeView({Key key, this.onTapped, this.onAdd,this.onHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
                    onWillPop: () async => false,
                    child: Scaffold(
                      backgroundColor: Colors.grey[100],
                      body:  ScreenTypeLayout(
                          mobile: HomeViewDesktop(onTapped: onTapped,onAdd: onAdd,onHome: onHome,),
                          tablet: HomeViewDesktop(onTapped: onTapped,onAdd: onAdd,onHome: onHome,),
                          desktop: HomeViewDesktop(onTapped: onTapped,onAdd: onAdd,onHome: onHome,),
                        ),
                      
                    ),
                  );
  }
}
