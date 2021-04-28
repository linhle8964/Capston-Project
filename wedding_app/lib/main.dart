import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/change_password/bloc.dart';

import 'package:wedding_app/bloc/invitation_card/bloc.dart';
import 'package:wedding_app/bloc/notification_setting/bloc.dart';
import 'package:wedding_app/bloc/vendor/bloc.dart';
import 'package:wedding_app/const/route_name.dart';
import 'package:wedding_app/firebase_repository/invitation_card_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/vendor_firebase_repository.dart';
import 'package:wedding_app/screens/budget/budget_page.dart';
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
import 'package:wedding_app/screens/list_collaborator/list_collaborator.dart';
import 'package:wedding_app/screens/login/login_page.dart';
import 'package:wedding_app/screens/navigator/navigator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding_app/screens/notification_setting/notification_setting.dart';
import 'package:wedding_app/screens/pick_wedding/pick_wedding_screen.dart';
import 'package:wedding_app/screens/pick_wedding/wedding_code.dart';
import 'package:wedding_app/screens/privacy_term/pdfview_page.dart';
import 'package:wedding_app/screens/register/register_page.dart';
import 'package:wedding_app/screens/reset_password/change_password.dart';
import 'package:wedding_app/screens/reset_password/reset_password.dart';
import 'package:wedding_app/screens/splash_page.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'bloc/authentication/bloc.dart';
import 'bloc/category/category_bloc.dart';
import 'bloc/login/bloc.dart';
import 'bloc/register/bloc.dart';
import 'bloc/template_card/template_card_bloc.dart';
import 'bloc/wedding/bloc.dart';
import 'bloc/invite_email/bloc.dart';
import 'bloc/validate_wedding/bloc.dart';
import 'bloc/user_wedding/bloc.dart';
import 'bloc/simple_bloc_observer.dart';
import 'firebase_repository/template_card_firebase_repository.dart';
import 'firebase_repository/category_firebase_repository.dart';
import 'firebase_repository/user_firebase_repository.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp().whenComplete(() => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(create: (context) {
            return AuthenticationBloc(
                userRepository: FirebaseUserRepository(),
                userWeddingRepository: FirebaseUserWeddingRepository(),
                weddingRepository: FirebaseWeddingRepository())
              ..add(AppStarted());
          }),
          BlocProvider<TemplateCardBloc>(create: (context) {
            return TemplateCardBloc(
                templateCardRepository: FirebaseTemplateCardRepository());
          }),
          BlocProvider<InvitationCardBloc>(create: (context) {
            return InvitationCardBloc(
                invitationCardRepository: FirebaseInvitationCardRepository());
          }),
          BlocProvider<WeddingBloc>(create: (context) {
            return WeddingBloc(
              userWeddingRepository: FirebaseUserWeddingRepository(),
              weddingRepository: FirebaseWeddingRepository(),
              inviteEmailRepository: FirebaseInviteEmailRepository(),
              userRepository: FirebaseUserRepository(),
            );
          }),
          BlocProvider<BudgetBloc>(
            create: (BuildContext context) => BudgetBloc(
              budgetRepository: FirebaseBudgetRepository(),
            ),
          ),
          BlocProvider<VendorBloc>(
            create: (BuildContext context) =>
                VendorBloc(todosRepository: FirebaseVendorRepository()),
          ),
          BlocProvider<CateBloc>(
            create: (BuildContext context) => CateBloc(
              todosRepository: FirebaseCategoryRepository(),
            ),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == RouteName.createWedding) {
              final CreateWeddingArguments args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<WeddingBloc>(
                        create: (context) => WeddingBloc(
                            weddingRepository: FirebaseWeddingRepository(),
                            userWeddingRepository:
                                FirebaseUserWeddingRepository(),
                            inviteEmailRepository:
                                FirebaseInviteEmailRepository(),
                        userRepository: FirebaseUserRepository()),
                      ),
                      BlocProvider<ValidateWeddingBloc>(
                        create: (context) => ValidateWeddingBloc(),
                      ),
                    ],
                    child: CreateWeddingPage(
                      isEditing: args.isEditing,
                      wedding: args.wedding,
                    ),
                  );
                },
              );
            }
          },
          routes: {
            RouteName.register: (context) {
              return BlocProvider(
                create: (BuildContext context) => RegisterBloc(
                    userRepository: FirebaseUserRepository(),
                    userWeddingRepository: FirebaseUserWeddingRepository()),
                child: RegisterPage(),
              );
            },
            RouteName.templateCard: (context) {
              return BlocProvider(
                create: (BuildContext context) => TemplateCardBloc(
                    templateCardRepository: FirebaseTemplateCardRepository()),
                child: ChooseTemplatePage(),
              );
            },
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) {
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                if (state is Authenticated) {
                  ScaffoldMessenger.of(context)..hideCurrentSnackBar();
                  return NavigatorPage(user: state.user,);
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
                  return PickWeddingPage();
                }
                return LoadingIndicator();
              });
            },
            RouteName.inviteCollaborator: (context) {
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
                      userWeddingRepository: FirebaseUserWeddingRepository(),
                      userRepository: FirebaseUserRepository(),
                    );
                  }),
                ],
                child: InviteCollaboratorPage(),
              );
            },
            RouteName.listCollaborator: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<UserWeddingBloc>(create: (context) {
                    return UserWeddingBloc(
                      userWeddingRepository: FirebaseUserWeddingRepository(),
                    )..add(LoadUserWeddingByWedding());
                  }),
                ],
                child: ListCollaborator(),
              );
            },
            RouteName.weddingCode: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<UserWeddingBloc>(
                    create: (context) => UserWeddingBloc(
                      userWeddingRepository: FirebaseUserWeddingRepository(),
                    ),
                  ),
                  BlocProvider<InviteEmailBloc>(
                    create: (context) => InviteEmailBloc(
                        inviteEmailRepository: FirebaseInviteEmailRepository(),
                        userWeddingRepository: FirebaseUserWeddingRepository(),
                        userRepository: FirebaseUserRepository()),
                  ),
                ],
                child: WeddingCodePage(),
              );
            },
            RouteName.resetPassword: (context) {
              return BlocProvider(
                create: (BuildContext context) =>
                    ResetPasswordBloc(userRepository: FirebaseUserRepository()),
                child: ResetPasswordPage(),
              );
            },
            RouteName.budgetList: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<BudgetBloc>(
                    create: (BuildContext context) => BudgetBloc(
                      budgetRepository: FirebaseBudgetRepository(),
                    ),
                  ),
                  BlocProvider<VendorBloc>(
                    create: (BuildContext context) =>
                        VendorBloc(todosRepository: FirebaseVendorRepository()),
                  ),
                  BlocProvider<CateBloc>(
                    create: (BuildContext context) => CateBloc(
                      todosRepository: FirebaseCategoryRepository(),
                    ),
                  ),
                ],
                child: BudgetList(),
              );
            },
            RouteName.privacy: (context) {
              return PDFViewPage(name: "privacy");
            },
            RouteName.term: (context) {
              return PDFViewPage(name: "term");
            },
            RouteName.changePassword: (context) {
              return BlocProvider(
                create: (BuildContext context) => ChangePasswordBloc(
                    userRepository: FirebaseUserRepository()),
                child: ChangePasswordScreen(),
              );
            },
            RouteName.notificationSetting: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<NotificationSettingBloc>(create: (context) {
                    return NotificationSettingBloc(
                    )..add(LoadNotificationSettings());
                  }),
                ],
                child: NotificationSettingScreen(),
              );
            },
          },
          title: 'VWED',
          theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        ));
  }
}
