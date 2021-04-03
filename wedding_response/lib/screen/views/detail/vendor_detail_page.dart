import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_diary/bloc/authentication/bloc.dart';
import 'package:flutter_web_diary/bloc/login/bloc.dart';
import 'package:flutter_web_diary/bloc/vendor/bloc.dart';
import 'package:flutter_web_diary/firebase_repository/vendor_firebase_repository.dart';
import 'package:flutter_web_diary/model/vendor.dart';
import 'package:flutter_web_diary/repository/vendor_repository.dart';
import 'package:flutter_web_diary/screen/views/allvendor/all_vendor_desktop.dart';
import 'package:flutter_web_diary/screen/views/allvendor/all_vendor_mobile.dart';
import 'package:flutter_web_diary/screen/views/detail/vendor_detail_desktop.dart';
import 'package:flutter_web_diary/screen/views/detail/vendor_detail_mobile.dart';
import 'package:flutter_web_diary/screen/views/error/error_page.dart';
import 'package:flutter_web_diary/screen/widgets/centered_view/centered_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VendorDetailPage extends StatelessWidget {
  final bool isEditing;
  final Vendor vendor;
  const VendorDetailPage({Key key, @required this.isEditing, this.vendor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VendorBloc>(
          create: (BuildContext context) =>
              VendorBloc(todosRepository: FirebaseVendorRepository())
                ..add(LoadVendor()),
        ),
      ],
      child: Builder(
        builder: (context) => BlocBuilder(
            cubit: BlocProvider.of<VendorBloc>(context),
            builder: (context, state) {
              if (state is VendorLoaded) {
                if (vendor.label == "") {
                  Vendor _vendor;
                  for (int i = 0; i < state.vendors.length; i++) {
                    String id = state.vendors[i].id;
                    String vendorid = vendor.id.trim();
                    if (id == vendorid) {
                      _vendor = state.vendors[i];
                    }
                  }
                  if (_vendor != null) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: Scaffold(
                        backgroundColor: Colors.grey[100],
                        body: ScreenTypeLayout(
                          mobile: VendorDetailMobilePage(
                            vendor: _vendor,
                            isEditing: true,
                          ),
                          tablet: VendorDetailMobilePage(
                            vendor: _vendor,
                            isEditing: true,
                          ),
                          desktop: VendorDetailDesktopPage(
                            vendor: _vendor,
                            isEditing: true,
                          ),
                        ),
                      ),
                    );
                  } else
                    return UnknownScreen();
                }
                return WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  backgroundColor: Colors.grey[100],
                  body: CenteredView(
                    child: ScreenTypeLayout(
                      mobile: VendorDetailMobilePage(
                            vendor: vendor,
                            isEditing: true,
                          ),
                      tablet: VendorDetailMobilePage(
                            vendor: vendor,
                            isEditing: true,
                          ),
                      desktop: VendorDetailDesktopPage(
                            vendor: vendor,
                            isEditing: true,
                          ),
                    ),
                  ),
                ),
              );
              }
              return Container(
                color:  Colors.grey[100],
                child: Center(child: Image.asset(
                  "/favicon-32x32.png",
                ),),
              );
            }),
      ),
    );
  }
}
