import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wedding_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding_app/screens/pick_wedding/pick_wedding_screen.dart';
import 'package:wedding_app/widgets/widget_key.dart';

void main() {
  const loginButtonKey = Key(WidgetKey.loginButtonKey);
  const emailTextFieldKey = Key(WidgetKey.loginEmailTextFieldKey);
  const passwordTextFieldKey = Key(WidgetKey.loginPasswordTextFieldKey);
  const loadingSnackbarkey = Key(WidgetKey.loadingSnackbarKey);
  const successSnackbarKey = Key(WidgetKey.successSnackbarKey);
  const alertDialogKey = Key(WidgetKey.alertDialogKey);
  const alertOkButton = Key(WidgetKey.alertDialogOkButtonKey);
  const showPasswordButtonKey = Key(WidgetKey.loginShowPasswordButtonKey);
  const String emailNotFoundMessage = "Tài khoản không tồn tại";
  const String wrongPasswordMessage = "Sai mật khẩu";
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets("log in", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // enter empty input
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(emailTextFieldKey));
    await tester.enterText(find.byKey(emailTextFieldKey), "");
    await tester.pump(Duration(seconds: 2));
    expect(find.text("Email không hợp lệ "), findsOneWidget);
    await tester.tap(find.byKey(passwordTextFieldKey));
    await tester.enterText(find.byKey(passwordTextFieldKey), "");
    await tester.pump(Duration(seconds: 2));
    expect(find.text("Mật khẩu không hợp lệ"), findsOneWidget);

    // login account not found
    await tester.tap(find.byKey(showPasswordButtonKey));
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

    // login wrong password
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

    // login with no wedding user
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(emailTextFieldKey));
    await tester.enterText(
        find.byKey(emailTextFieldKey), "linhle8964@gmail.com");
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

  testWidgets("log in", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    // login with user who have wedding
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(emailTextFieldKey));
    await tester.enterText(
        find.byKey(emailTextFieldKey), "linhlche130970@fpt.edu.vn");
    await tester.pump(Duration(seconds: 2));
    await tester.tap(find.byKey(passwordTextFieldKey));
    await tester.enterText(find.byKey(passwordTextFieldKey), "linhle8964");
    await tester.tap(find.byKey(showPasswordButtonKey));
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
