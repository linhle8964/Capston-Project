import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:wedding_app/widgets/widget_key.dart';

void main() {
  group('Wedding App', () {
    const loginButtonKey = WidgetKey.loginButtonKey;
    const emailTextFieldKey = WidgetKey.loginEmailTextFieldKey;
    const passwordTextFieldKey = WidgetKey.loginPasswordTextFieldKey;
    const showPasswordButtonKey = WidgetKey.loginShowPasswordButtonKey;
    const navigateTaskButtonKey = WidgetKey.navigateTaskButtonKey;
    const navigateBudgetButtonKey = WidgetKey.navigateBudgetButtonKey;
    const navigateGuestButtonKey = WidgetKey.navigateGuestButtonKey;
    const navigateSettingButtonKey = WidgetKey.navigateSettingButtonKey;

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('log in', () async {
      // login with user who invalid email
      await driver.tap(find.byValueKey(emailTextFieldKey));
      await driver.enterText("linhlche13097@fpt.edu.vn");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(find.byValueKey(passwordTextFieldKey));
      await driver.enterText("linhle8964");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(find.byValueKey(showPasswordButtonKey));
      await Future.delayed(Duration(seconds: 2));

      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey(loginButtonKey));
        expect(await isPresent(find.byValueKey(WidgetKey.loadingSnackbarKey), driver), isTrue);
        expect(await isPresent(find.byValueKey(WidgetKey.alertDialogKey), driver), isTrue);
      });
      await driver.tap(find.byValueKey(WidgetKey.alertDialogOkButtonKey));

      // login with user who invalid password
      await driver.tap(find.byValueKey(emailTextFieldKey));
      await driver.enterText("linhlche130970@fpt.edu.vn");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(find.byValueKey(passwordTextFieldKey));
      await driver.enterText("linhle8963");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(find.byValueKey(showPasswordButtonKey));
      await Future.delayed(Duration(seconds: 2));

      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey(loginButtonKey));
        expect(await isPresent(find.byValueKey(WidgetKey.loadingSnackbarKey), driver), isTrue);
        expect(await isPresent(find.byValueKey(WidgetKey.alertDialogKey), driver), isTrue);
      });
      await driver.tap(find.byValueKey(WidgetKey.alertDialogOkButtonKey));

    });

    test('demo', () async {
      // login with user who have wedding
      await driver.tap(find.byValueKey(emailTextFieldKey));
      await driver.enterText("linhlche130970@fpt.edu.vn");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(find.byValueKey(passwordTextFieldKey));
      await driver.enterText("linhle8964");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(find.byValueKey(showPasswordButtonKey));
      await Future.delayed(Duration(seconds: 2));

      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey(loginButtonKey));
        expect(await isPresent(find.byValueKey(WidgetKey.loadingSnackbarKey), driver), isTrue);
        expect(await isPresent(find.byValueKey(WidgetKey.successSnackbarKey), driver), isTrue);
      });
      await driver.tap(find.byValueKey(navigateTaskButtonKey));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey(navigateBudgetButtonKey));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey(navigateGuestButtonKey));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey(navigateSettingButtonKey));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey(WidgetKey.navigateHomeButtonKey));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey(WidgetKey.invitationCardButtonKey));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey(WidgetKey.createInvitationCardTabKey));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.byValueKey(WidgetKey.uploadInvitationCardTabkey));
    });
  },);
}

Future<bool> isPresent(
    SerializableFinder byValueKey, FlutterDriver driver) async {
  try {
    await driver.waitFor(byValueKey);
    return true;
  } catch (exception) {
    print(exception.toString());
    return false;
  }
}
