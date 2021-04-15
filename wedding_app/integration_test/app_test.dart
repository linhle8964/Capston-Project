import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wedding_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding_app/screens/navigator/navigator.dart';
import 'package:wedding_app/const/widget_key.dart';

void main() {
  const loginButtonKey = Key(WidgetKey.loginButtonKey);
  const emailTextFieldKey = Key(WidgetKey.loginEmailTextFieldKey);
  const passwordTextFieldKey = Key(WidgetKey.loginPasswordTextFieldKey);
  const loadingSnackbarkey = Key(WidgetKey.loadingSnackbarKey);
  const successSnackbarKey = Key(WidgetKey.successSnackbarKey);
  const alertDialogKey = Key(WidgetKey.alertDialogKey);
  const alertOkButton = Key(WidgetKey.alertDialogOkButtonKey);
  const showPasswordButtonKey = Key(WidgetKey.loginShowPasswordButtonKey);
  const bottomNavigationBarKey = Key(WidgetKey.bottomNavigationBarKey);
  const navigateHomeButtomKey = Key(WidgetKey.navigateHomeButtonKey);
  const navigateTaskButtonKey = Key(WidgetKey.navigateTaskButtonKey);
  const navigateBudgetButtonKey = Key(WidgetKey.navigateBudgetButtonKey);
  const navigateGuestButtonKey = Key(WidgetKey.navigateGuestButtonKey);
  const navigateSettingButtonKey = Key(WidgetKey.navigateSettingButtonKey);

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets("log in and test function", (WidgetTester tester) async {
    await tester.runAsync(() async {
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
      expect(find.byKey(successSnackbarKey), findsWidgets);
      await tester.pumpAndSettle();
      expect(find.byType(NavigatorPage), findsOneWidget);

      await tester.tap(find.byKey(navigateTaskButtonKey));
      await tester.pump(Duration(seconds: 1));
      //await tester.tap(find.byKey(navigateBudgetButtonKey));
      // expect(tester.takeException(), isInstanceOf<AssertionError>());
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.byKey(navigateGuestButtonKey));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(navigateSettingButtonKey));
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.byKey(navigateHomeButtomKey));
      await tester.pump(Duration(seconds: 1));
    });
  });
}
