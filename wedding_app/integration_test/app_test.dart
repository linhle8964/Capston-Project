import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wedding_app/bloc/login/bloc.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:wedding_app/screens/login/login_page.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements FirebaseUserWeddingRepository {
}

class MockLoginBloc extends MockBloc<LoginState> implements LoginBloc {}

void main() {
  const loginButtonKey = Key("login_button");
  const emailTextFieldKey = Key("email_text_field");
  const passwordTextFieldKey = Key("password_text_field");
  const loadingSnackbarkey = Key("loading_snackbar");
  const successSnackbarKey = Key("success_snackbar");
  const alertDialogKey = Key("alert_dialog");
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  LoginBloc loginBloc;
  MockUserRepository mockUserRepository;
  setUpAll(() {
    Firebase.initializeApp();
    loginBloc = MockLoginBloc();
    mockUserRepository = MockUserRepository();
    when(loginBloc.state).thenReturn(LoginState.empty());
  });

  testWidgets("invalid email error text when email is invalid",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BlocProvider.value(
          value: loginBloc,
          child: LoginPage(),
        ),
      ),
    ));

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(emailTextFieldKey));
    await tester.enterText(find.byKey(emailTextFieldKey), "");
    await tester.pump();
    expect(find.text("Email không hợp lệ "), findsOneWidget);
  });

  testWidgets("invalid password error text when password is invalid",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BlocProvider.value(
          value: loginBloc,
          child: LoginPage(),
        ),
      ),
    ));

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(passwordTextFieldKey));
    await tester.enterText(find.byKey(passwordTextFieldKey), "");
    await tester.pump();
    expect(find.text("Mật khẩu không hợp lệ"), findsOneWidget);
  });

  // testWidgets("login bloc call login when login button is pressed",
  //     (WidgetTester tester) async {
  //   when(loginBloc.state).thenReturn(LoginState.loading());
  //   await tester.pumpWidget(MaterialApp(
  //     home: Scaffold(
  //       body: BlocProvider.value(
  //         value: loginBloc,
  //         child: LoginPage(),
  //       ),
  //     ),
  //   ));

  //   await tester.tap(find.byKey(loginButtonKey));
  //   loginBloc.Em
  //   //verify(mockUserRepository.)
  // });

  testWidgets("AuthenticationFailure dialog when submission fails",
      (WidgetTester tester) async {
    String message = "Có lỗi xảy ra";
    whenListen(
      loginBloc,
      Stream.fromIterable(<LoginState>[
        LoginState.loading(),
        LoginState.failure(message: message),
      ]),
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BlocProvider.value(
          value: loginBloc,
          child: LoginPage(),
        ),
      ),
    ));

    await tester.pump();
    expect(find.byKey(loadingSnackbarkey), findsOneWidget);
    expect(find.byKey(alertDialogKey), findsOneWidget);

    AlertDialog alertDialog = tester.widget(find.byKey(alertDialogKey));
    expect(alertDialog.content.toString().compareTo(message), 1);
  });
}
