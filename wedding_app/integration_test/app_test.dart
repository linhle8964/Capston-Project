
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:wedding_app/bloc/invitation_card/bloc.dart';
import 'package:wedding_app/firebase_repository/category_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/inviattion_card_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/template_card_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/main.dart';
import 'package:wedding_app/screens/choose_template_invitation/chooseTemplate_page.dart';

import 'package:wedding_app/bloc/budget/bloc.dart';
import 'package:wedding_app/bloc/reset_password/bloc.dart';
import 'package:wedding_app/firebase_repository/budget_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/invite_email_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/wedding_firebase_repository.dart';
import 'package:wedding_app/screens/create_wedding/create_wedding_argument.dart';

import 'package:wedding_app/screens/create_wedding/create_wedding_page.dart';
import 'package:wedding_app/screens/invite_collaborator/invite_collaborator.dart';
import 'package:wedding_app/screens/login/login_page.dart';
import 'package:wedding_app/screens/navigator/navigator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding_app/screens/pick_wedding/pick_wedding_screen.dart';
import 'package:wedding_app/screens/pick_wedding/wedding_code.dart';
import 'package:wedding_app/screens/register/register_page.dart';
import 'package:wedding_app/screens/reset_password/reset_password.dart';
import 'package:wedding_app/screens/splash_page.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/category/category_bloc.dart';
import 'package:wedding_app/bloc/login/bloc.dart';
import 'package:wedding_app/bloc/register/bloc.dart';
import 'package:wedding_app/bloc/template_card/template_card_bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/bloc/invite_email/bloc.dart';
import 'package:wedding_app/bloc/validate_wedding/bloc.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/bloc/simple_bloc_observer.dart';
void main() {
  const loginButtonKey = Key("login_button");
  const emailTextFieldKey = Key("email_text_field");
  const passwordTextFieldKey = Key("password_text_field");
  const loadingSnackbarkey = Key("loading_snackbar");
  const successSnackbarKey = Key("success_snackbar");
  const alertDialogKey = Key("alert_dialog");
  const alertOkButton = Key("alert_ok_button");
  const String emailNotFoundMessage = "Tài khoản không tồn tại";
  const String wrongPasswordMessage = "Sai mật khẩu";
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets("log in", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(emailTextFieldKey));
    await tester.enterText(find.byKey(emailTextFieldKey), "");
    await tester.pump(Duration(seconds: 2));
    expect(find.text("Email không hợp lệ "), findsOneWidget);
    await tester.tap(find.byKey(passwordTextFieldKey));
    await tester.enterText(find.byKey(passwordTextFieldKey), "");
    await tester.pump(Duration(seconds: 2));
    expect(find.text("Mật khẩu không hợp lệ"), findsOneWidget);

    await tester.tap(find.byKey(emailTextFieldKey));
    await tester.enterText(
        find.byKey(emailTextFieldKey), "linhle8963@gmail.com");
    await tester.pump(Duration(seconds: 2));
    await tester.tap(find.byKey(passwordTextFieldKey));
    await tester.enterText(find.byKey(passwordTextFieldKey), "linhle8964");
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(loginButtonKey));
    await tester.pump(Duration(seconds: 5));
    expect(find.byKey(loadingSnackbarkey), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 2));
    expect(find.byKey(alertDialogKey), findsOneWidget);
    AlertDialog alertDialog = tester.widget(find.byKey(alertDialogKey));
   // expect(alertDialog.content.toString().compareTo(emailNotFoundMessage), 1);
    await tester.tap(find.byKey(alertOkButton));

    await tester.tap(find.byKey(emailTextFieldKey));
    await tester.enterText(
        find.byKey(emailTextFieldKey), "linhle8964@gmail.com");
    await tester.pump(Duration(seconds: 2));
    await tester.tap(find.byKey(passwordTextFieldKey));
    await tester.enterText(find.byKey(passwordTextFieldKey), "linhle8963");
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(loginButtonKey));
    await tester.pump(Duration(seconds: 5));
    expect(find.byKey(loadingSnackbarkey), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(alertDialogKey), findsOneWidget);
    print(alertDialog.content.toString());
    //expect(alertDialog.content.toString().compareTo(wrongPasswordMessage), 1);
    await tester.tap(find.byKey(alertOkButton));

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(emailTextFieldKey));
    await tester.enterText(find.byKey(emailTextFieldKey), "linhle8964@gmail.com");
    await tester.pump(Duration(seconds: 2));
    await tester.tap(find.byKey(passwordTextFieldKey));
    await tester.enterText(find.byKey(passwordTextFieldKey), "linhle8964");
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(loginButtonKey));
    await tester.pump(Duration(seconds: 5));
    expect(find.byKey(loadingSnackbarkey), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(successSnackbarKey), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(PickWeddingPage), findsOneWidget);
  });
}