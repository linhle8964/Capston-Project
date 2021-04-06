import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_diary/bloc/authentication/bloc.dart';
import 'package:flutter_web_diary/bloc/login/bloc.dart';
import 'package:flutter_web_diary/firebase_repository/user_firebase_repository.dart';
import 'package:flutter_web_diary/screen/views/allvendor/all_vendor_page.dart';

import 'package:flutter_web_diary/screen/views/error/error_page.dart';
import 'package:flutter_web_diary/screen/views/login/login_page_desktop.dart';
import 'package:flutter_web_diary/screen/views/login/login_page_mobile.dart';
import 'package:flutter_web_diary/screen/widgets/centered_view/centered_view.dart';
import 'package:flutter_web_diary/util/alert_dialog.dart';
import 'package:flutter_web_diary/util/globle_variable.dart';
import 'package:flutter_web_diary/util/show_snackbar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(
              userRepository: FirebaseUserRepository(),
            )),
      ],
      child:BlocListener(
        cubit:  BlocProvider.of<LoginBloc>(context),
        listener: (context, state) {
          if (state.isSubmitting) {
            FocusScope.of(context).unfocus();
            showProcessingSnackbar(context, state.message);
          }
          if (state.isSuccess) {
            FocusScope.of(context).unfocus();
            showSuccessSnackbar(context, state.message);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllVendorPage()),
            );
          }
          if (state.isFailure) {
            FocusScope.of(context).unfocus();
            showSuccessAlertDialog(context, "Có lỗi", state.message, () {
              Navigator.pop(context);
            });
          }
        },
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: CenteredView(
              child: ScreenTypeLayout(
                mobile: LoginPageMobile(),
                tablet: LoginPageMobile(),
                desktop: LoginPageDesktop(),
              ),
            ),
          ),
        ),
      )
    );
  }
}
