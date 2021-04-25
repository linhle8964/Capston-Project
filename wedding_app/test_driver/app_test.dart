import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/const/widget_key.dart';

void main() {
  group(
    'Wedding App',
    () {
      const loginButtonKey = WidgetKey.loginButtonKey;
      const emailTextFieldKey = WidgetKey.loginEmailTextFieldKey;
      const passwordTextFieldKey = WidgetKey.loginPasswordTextFieldKey;
      const showPasswordButtonKey = WidgetKey.loginShowPasswordButtonKey;
      const navigateTaskButtonKey = WidgetKey.navigateTaskButtonKey;

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
        // email invalid
        await driver.runUnsynchronized(() async {
          await driver.tap(find.byValueKey(emailTextFieldKey));
          await driver.enterText("linhlche13097");
          expect(await isPresent(find.text(MessageConst.invalidEmail), driver),
              isTrue);
        });

        // invalid password length < 6
        await driver.runUnsynchronized(() async {
          await driver.tap(find.byValueKey(passwordTextFieldKey));
          await driver.enterText("4");
          expect(
              await isPresent(find.text(MessageConst.passwordLengthMin), driver),
              isTrue);
        });

        // invalid password length > 20
        await driver.runUnsynchronized(() async {
          await driver.tap(find.byValueKey(passwordTextFieldKey));
          await driver.enterText("1234567891011121314151617181920");
          expect(
              await isPresent(find.text(MessageConst.passwordLengthMax), driver),
              isTrue);
        });

        // invalid password only character
        await driver.runUnsynchronized(() async {
          await driver.tap(find.byValueKey(passwordTextFieldKey));
          await driver.enterText("abcdefghi");
          expect(
              await isPresent(find.text(MessageConst.passwordAtLeastOneNumber), driver),
              isTrue);
        });

        // invalid password only number
        await driver.runUnsynchronized(() async {
          await driver.tap(find.byValueKey(passwordTextFieldKey));
          await driver.enterText("12345678");
          expect(
              await isPresent(find.text(MessageConst.passwordAtLeastOneCharacter), driver),
              isTrue);
        });

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
          expect(
              await isPresent(
                  find.byValueKey(WidgetKey.loadingSnackbarKey), driver),
              isTrue);
          expect(
              await isPresent(
                  find.byValueKey(WidgetKey.alertDialogKey), driver),
              isTrue);
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
          expect(
              await isPresent(
                  find.text(MessageConst.invalidEmail), driver),
              isFalse);
          expect(
              await isPresent(
                  find.text(MessageConst.invalidPassword), driver),
              isFalse);
          await driver.tap(find.byValueKey(loginButtonKey));
          expect(
              await isPresent(
                  find.byValueKey(WidgetKey.loadingSnackbarKey), driver),
              isTrue);
          expect(
              await isPresent(
                  find.byValueKey(WidgetKey.alertDialogKey), driver),
              isTrue);
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
          expect(
              await isPresent(
                  find.byValueKey(WidgetKey.loadingSnackbarKey), driver),
              isTrue);
          expect(
              await isPresent(
                  find.byValueKey(WidgetKey.successSnackbarKey), driver),
              isTrue);
        });
        await driver.tap(find.byValueKey(navigateTaskButtonKey));
        await Future.delayed(Duration(seconds: 1));

        // add task success
        await driver.tap(find.byValueKey(WidgetKey.addTaskKey));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.byValueKey(WidgetKey.addTaskOpenDateTimePicker));
        await driver.tap(find.text('30'));
        await driver.tap(find.text('OK'));
        await driver.tap(find.byValueKey(WidgetKey.addTaskDropDownButton));
        await driver.tap(find.text('Ảnh cưới'));
        await driver.runUnsynchronized(() async {
          await driver.tap(find.byValueKey(WidgetKey.addTaskSubmit));
          await driver.tap(find.byValueKey(WidgetKey.yesConfirmButtonKey));
          expect(
              await isPresent(
                  find.byValueKey(WidgetKey.failedSnackbarKey), driver),
              isTrue);
        });
        await driver.tap(find.byValueKey(WidgetKey.addTaskNameKey));
        await driver.enterText("Demo 5");
        await driver.tap(find.byValueKey(WidgetKey.addTaskSubmit));
        await driver.tap(find.byValueKey(WidgetKey.noConfirmButtonKey));
        await driver.tap(find.byValueKey(WidgetKey.addTaskSubmit));
        await driver.tap(find.byValueKey(WidgetKey.yesConfirmButtonKey));
        await driver.tap(find.byValueKey(WidgetKey.taskItemKey + "0"));
        //     await driver.tap(find.byValueKey(WidgetKey.taskItemKey + "0"));
        /*await driver.tap(find.byValueKey(navigateBudgetButtonKey));
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
        await driver.tap(find.byValueKey(WidgetKey.uploadInvitationCardTabkey));*/
      });
    },
  );
}

Future<bool> isPresent(SerializableFinder byValueKey, FlutterDriver driver,
    {Duration timeout = const Duration(seconds: 3)}) async {
  try {
    await driver.waitFor(byValueKey, timeout: timeout);
    return true;
  } catch (exception) {
    print(exception.toString());
    return false;
  }
}
