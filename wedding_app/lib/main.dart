import 'package:flutter/material.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/firebase_repository/invite_email_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/wedding_firebase_repository.dart';
import 'package:wedding_app/screens/create_wedding/create_wedding_page.dart';
import 'package:wedding_app/screens/invite_collaborator/invite_collaborator.dart';
import 'package:wedding_app/screens/login/login_page.dart';
import 'package:wedding_app/screens/navigator/navigator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding_app/screens/register/register_page.dart';
import 'package:wedding_app/screens/splash_page.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:wedding_app/widgets/notification.dart';
import 'bloc/authentication/bloc.dart';
import 'bloc/category/category_bloc.dart';
import 'bloc/checklist/bloc.dart';
import 'bloc/login/bloc.dart';
import 'bloc/register/bloc.dart';
import 'bloc/wedding/bloc.dart';
import 'bloc/invite_email/bloc.dart';
import 'bloc/create_wedding/bloc.dart';
import 'bloc/user_wedding/bloc.dart';
import 'bloc/simple_bloc_observer.dart';
import 'firebase_repository/category_firebase_repository.dart';
import 'firebase_repository/user_firebase_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp().whenComplete(() => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  DateTime _alarmTime;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(create: (context) {
            return AuthenticationBloc(
              userRepository: FirebaseUserRepository(),
              userWeddingRepository: FirebaseUserWeddingRepository(),
            )..add(AppStarted());
          },),
        ],
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/register': (context) {
              return BlocProvider(
                create: (BuildContext context) => RegisterBloc(
                    userRepository: FirebaseUserRepository(),
                    userWeddingRepository: FirebaseUserWeddingRepository()),
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
                  return BlocProvider<LoginBloc>(
                    create: (context) => LoginBloc(
                      userRepository: FirebaseUserRepository(),
                    ),
                    child: LoginPage(),
                  );
                } else if (state is Uninitialized) {
                  return SplashPage();
                } else if (state is WeddingNull) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<WeddingBloc>(
                        create: (context) => WeddingBloc(
                          weddingRepository: FirebaseWeddingRepository(),
                          userWeddingRepository:
                              FirebaseUserWeddingRepository(),
                        ),
                      ),
                      BlocProvider<CreateWeddingBloc>(
                        create: (context) => CreateWeddingBloc(),
                      ),
                    ],
                    child: CreateWeddingPage(user: state.user),
                  );
                }
                return LoadingIndicator();
              });
            },
            '/invite_collaborator': (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<UserWeddingBloc>(create: (context) {
                    return UserWeddingBloc(
                      userWeddingRepository: FirebaseUserWeddingRepository(),
                    )..add(LoadUserWeddingByWedding());
                  }),
                  BlocProvider<InviteEmailBloc>(create: (context) {
                    return InviteEmailBloc(
                      inviteEmailRepository: FirebaseInviteEmailRepository(),
                    );
                  }),
                ],
                child: InviteCollaboratorPage(),
              );
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
