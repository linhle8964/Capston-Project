import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/invite_email_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/notification_firebase_repository.dart';
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
import 'file:///C:/Users/ADMIN/Documents/Git/Capston-Project/wedding_app/lib/const/widget_key.dart';

class NavigatorPage extends StatefulWidget {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeddingBloc>(
          create: (BuildContext context) => WeddingBloc(
              userWeddingRepository: FirebaseUserWeddingRepository(),
              weddingRepository: FirebaseWeddingRepository(),
              inviteEmailRepository: FirebaseInviteEmailRepository()),
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
            List<Widget> _children = [
              HomePage(),
              ChecklistPage(
                userWedding: userWedding,
              ),
              BudgetList(),
              ViewGuestPage(
                userWedding: userWedding,
              ),
              SettingPage(userWedding: userWedding),
            ];
            return Scaffold(
              body: _children[_selectedIndex],
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
                  selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                  type: BottomNavigationBarType.fixed,
                  onTap: onTabTapped),
            );
          } else {
            return SplashPage();
          }
        },
      ),
    );
  }
}
