import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/authentication/authentication_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/invite_email_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/notification_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/user_firebase_repository.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/screens/budget/budget_page.dart';
import 'package:wedding_app/screens/checklist/checklist_page.dart';
import 'package:wedding_app/screens/guest/view_guest_page.dart';
import 'package:wedding_app/screens/home/home_page.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/wedding_firebase_repository.dart';
import 'package:wedding_app/screens/setting/setting.dart';
import 'package:wedding_app/screens/splash_page.dart';
import 'package:wedding_app/utils/get_share_preferences.dart';
import 'package:wedding_app/const/widget_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';
import 'package:wedding_app/widgets/receive_notification.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

class NavigatorPage extends StatefulWidget {
  final User user;

  NavigatorPage({Key key, @required this.user}) : super(key: key);
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _selectedIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _logOut() async {
      BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
      NotificationManagement.ClearAllNotifications();
      var cancel = await AndroidAlarmManager.cancel(0);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<WeddingBloc>(
          create: (BuildContext context) => WeddingBloc(
              userWeddingRepository: FirebaseUserWeddingRepository(),
              weddingRepository: FirebaseWeddingRepository(),
              inviteEmailRepository: FirebaseInviteEmailRepository(),
              userRepository: FirebaseUserRepository())
            ..add(LoadWeddingByUser(widget.user)),
        ),
        BlocProvider<UserWeddingBloc>(
          create: (BuildContext context) => UserWeddingBloc(
            userWeddingRepository: FirebaseUserWeddingRepository(),
          ),
        ),
        BlocProvider<ChecklistBloc>(
          create: (BuildContext context) => ChecklistBloc(
            taskRepository: FirebaseTaskRepository(),
            notificationRepository: NotificationFirebaseRepository(),
          ),
        ),
        BlocProvider<GuestsBloc>(
          create: (BuildContext context) => GuestsBloc(
            guestsRepository: FirebaseGuestRepository(),
          ),
        )
      ],
      child: FutureBuilder(
        future: getUserWedding(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserWedding userWedding = snapshot.data;
            return Container(
              color: Colors.white,
              child: BlocBuilder(
                cubit: BlocProvider.of<WeddingBloc>(context),
                builder: (context, state) {
                  if (state is WeddingLoaded) {
                    List<Widget> _children = [
                      HomePage(
                        userWedding: userWedding,
                        wedding: state.wedding,
                      ),
                      ChecklistPage(
                        userWedding: userWedding,
                      ),
                      BudgetList(
                        userWedding: userWedding,
                      ),
                      ViewGuestPage(
                        userWedding: userWedding,
                      ),
                      SettingPage(
                        userWedding: userWedding,
                        wedding: state.wedding,
                      ),
                    ];
                    return Scaffold(
                      body: Container(
                        child: _children[_selectedIndex],
                      ),
                      bottomNavigationBar: BottomNavigationBar(
                          key: Key(WidgetKey.bottomNavigationBarKey),
                          items: [
                            BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.home,
                                  key: Key(WidgetKey.navigateHomeButtonKey),
                                ),
                                label: "Trang chủ"),
                            BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.check_box,
                                  key: Key(WidgetKey.navigateTaskButtonKey),
                                ),
                                label: "Công việc"),
                            BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.account_balance_wallet_outlined,
                                  key: Key(WidgetKey.navigateBudgetButtonKey),
                                ),
                                label: "Kinh phí"),
                            BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.people,
                                  key: Key(WidgetKey.navigateGuestButtonKey),
                                ),
                                label: "Khách mời"),
                            BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.settings,
                                  key: Key(WidgetKey.navigateSettingButtonKey),
                                ),
                                label: "Cài đặt"),
                          ],
                          currentIndex: _selectedIndex,
                          selectedItemColor: Colors.red,
                          unselectedItemColor: Colors.grey.shade600,
                          selectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.w600),
                          unselectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.w600),
                          type: BottomNavigationBarType.fixed,
                          onTap: onTabTapped),
                    );
                  } else if (state is WeddingLoading) {
                    return LoadingIndicator();
                  } else if (state is DeleteSuccess) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _logOut();
                  } else if (state is Failed) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return SplashPage();
                },
              ),
            );
          } else {
            return SplashPage();
          }
        },
      ),
    );
  }
}
