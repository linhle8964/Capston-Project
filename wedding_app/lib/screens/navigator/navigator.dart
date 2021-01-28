import 'package:flutter/material.dart';
import 'package:wedding_app/demo_page.dart';
import 'package:wedding_app/screens/Budget/budget_page.dart';
import 'package:wedding_app/screens/create_wedding/create_wedding_page.dart';
import 'package:wedding_app/screens/login/login.dart';
import 'package:wedding_app/screens/personal_info/personal_info.dart';
import 'package:wedding_app/screens/setting/setting.dart';
import 'package:wedding_app/screens/wedding_date/wedding_date.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    DemoPage(string: "1",),
    SettingPage(),
    PersonalInfoPage(),
    WeddingDatePage(),
  ];
  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: "CheckList"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: "Budget"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Guest"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped
      ),
    );
  }
}
