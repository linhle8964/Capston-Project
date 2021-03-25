import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/authentication/authentication_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/login/bloc.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding_app/screens/login/login_page.dart';
import 'package:mockito/mockito.dart';

import '../../mock.dart';
import '../../mock_user.dart' as mock_user;

class MockUserRepository extends Mock implements FirebaseUserRepository {}

class MocKUserWeddingRepository extends Mock
    implements FirebaseUserWeddingRepository {}

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

class MockLoginBloc extends MockBloc<LoginState> implements LoginBloc {}

class MockUser extends Mock implements User {}

void main() {
  const loginButtonKey = Key("login_button");
  const registerButton = Key("go_to_register_button");
  const loadingSnackbarkey = Key("loading_snackbar");
  const successSnackbarKey = Key("success_snackbar");
  const alertDialogKey = Key("alert_dialog");
  final user = mock_user.MockUser(
    email: "linhle8964@gmail.com",
    emailVerified: true,
  );
  setupFirebaseAuthMocks();
  group("Login Page", () {
    LoginBloc loginBloc;
    AuthenticationBloc authenticationBloc;
    MockUserRepository mockUserRepository;
    MocKUserWeddingRepository mocKUserWeddingRepository;
    setUpAll(() async {
      await Firebase.initializeApp();
      loginBloc = MockLoginBloc();
      authenticationBloc = MockAuthenticationBloc();
      mockUserRepository = MockUserRepository();
      mocKUserWeddingRepository = MocKUserWeddingRepository();
      when(loginBloc.state).thenReturn(LoginState.empty());
    });

    testWidgets("invalid email error text when email is invalid",
        (WidgetTester tester) async {
      when(loginBloc.state).thenReturn(LoginState(
          isEmailValid: false,
          isPasswordValid: true,
          isSubmitting: false,
          isSuccess: false,
          isFailure: false,
          message: ""));
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: loginBloc,
            child: LoginPage(),
          ),
        ),
      ));

      expect(find.text("Email không hợp lệ "), findsOneWidget);
    });

    testWidgets("invalid password error text when password is invalid",
        (WidgetTester tester) async {
      when(loginBloc.state).thenReturn(LoginState(
          isEmailValid: true,
          isPasswordValid: false,
          isSubmitting: false,
          isSuccess: false,
          isFailure: false,
          message: ""));
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: loginBloc,
            child: LoginPage(),
          ),
        ),
      ));

      expect(find.text("Mật khẩu không hợp lệ"), findsOneWidget);
    });

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

    testWidgets("AuthenticationSuccess dialog when submission success",
        (WidgetTester tester) async {
      whenListen(
        loginBloc,
        Stream.fromIterable(<LoginState>[
          LoginState.loading(),
          LoginState.success(),
        ]),
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: loginBloc),
              BlocProvider.value(value: authenticationBloc),
            ],
            child: LoginPage(),
          ),
        ),
      ));

      await tester.pump();
      expect(find.byKey(successSnackbarKey), findsOneWidget);
    });
  });
}
