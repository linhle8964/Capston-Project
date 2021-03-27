import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/notification_firebase_repository.dart';
import 'package:wedding_app/screens/budget/budget_page.dart';
import 'package:wedding_app/screens/checklist/checklist_page.dart';
import 'package:wedding_app/screens/guest/view_guest_page.dart';
import 'package:wedding_app/screens/home/home_page.dart';
import 'package:wedding_app/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/wedding_firebase_repository.dart';
import 'package:wedding_app/screens/notification/notification.dart';
import 'package:wedding_app/screens/setting/setting.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ChecklistPage(),
    BudgetList(),
    ViewGuestPage(),
    SettingPage(),
  ];
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
          ),
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
      child: Scaffold(
        body: _children[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Trang chủ"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_box), label: "Công việc"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: "Kinh phí"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: "Khách mời"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Cài đặt"),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            type: BottomNavigationBarType.fixed,
            onTap: onTabTapped),
      ),
    );
  }
}
