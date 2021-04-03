import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_diary/bloc/authentication/bloc.dart';
import 'package:flutter_web_diary/bloc/login/bloc.dart';
import 'package:flutter_web_diary/bloc/vendor/bloc.dart';
import 'package:flutter_web_diary/firebase_repository/vendor_firebase_repository.dart';
import 'package:flutter_web_diary/screen/views/allvendor/all_vendor_desktop.dart';
import 'package:flutter_web_diary/screen/views/allvendor/all_vendor_mobile.dart';
import 'package:flutter_web_diary/screen/widgets/centered_view/centered_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllVendorPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<VendorBloc>(
              create: (BuildContext context) => VendorBloc(
                todosRepository: FirebaseVendorRepository(),
              )),
        ],
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Colors.grey[100],
              body:  ScreenTypeLayout(
                  mobile: AllVendorPageMobile(),
                  tablet: AllVendorPageMobile(),
                  desktop: CenteredView(child:AllVendorPageDesktop(),)
                  
                ),
              
            ),
          ),
    );
  }
}
