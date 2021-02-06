import 'package:flutter/material.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/screens/create_wedding/create_wedding_page.dart';
import 'package:wedding_app/screens/login/login_page.dart';
import 'package:wedding_app/screens/navigator/navigator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding_app/screens/register/register_page.dart';
import 'package:wedding_app/screens/splash_page.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';

import 'bloc/authentication/bloc.dart';
import 'bloc/login/bloc.dart';
import 'bloc/register/bloc.dart';
import 'bloc/simple_bloc_observer.dart';
import 'firebase_repository/user_firebase_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp().whenComplete(() => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(create: (context) {
            return AuthenticationBloc(
              userRepository: FirebaseUserRepository(),
              userWeddingRepository: FirebaseUserWeddingRepository(),
            )..add(AppStarted());
          }),
        ],
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/register': (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    RegisterBloc(userRepository: FirebaseUserRepository()),
                child: RegisterPage(),
              );
            },
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) {
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                if (state is Authenticated) {
                  return NavigatorPage();
                } else if (state is Unauthenticated) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<LoginBloc>(
                        create: (context) => LoginBloc(
                          userRepository: FirebaseUserRepository(),
                        ),
                      ),
                    ],
                    child: LoginPage(),
                  );
                } else if (state is Uninitialized) {
                  return SplashPage();
                } else if (state is WeddingNull) {
                  return CreateWeddingPage();
                }

                return LoadingIndicator();
              });
            },
            "/createWedding": (context) {
              return CreateWeddingPage();
            }
          },
          title: 'Wedding App',
          theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        ));
  }
}
