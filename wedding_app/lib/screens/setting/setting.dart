import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/screens/setting/custom_button.dart';
import 'package:wedding_app/screens/setting/setting_item.dart';
import 'package:wedding_app/utils/alert_dialog.dart';
import 'package:wedding_app/utils/get_role.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:wedding_app/widgets/notification.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  void dispose() {
    // TODO: implement dispose
    NotificationManagement.cancelAlarm();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#d86a77"),
        title: Text(
          "CÀI ĐẶT",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserWeddingBloc, UserWeddingState>(
            listener: (context, state) {
              if (state is UserWeddingProcessing) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UserWeddingFailed) {
                showFailedSnackbar(context, state.message);
              } else if (state is UserWeddingSuccess) {
                showSuccessAlertDialog(context, "Rời đám cưới", state.message,
                    () {
                  Navigator.pop(context);
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                });
              }
            },
          ),
          BlocListener<WeddingBloc, WeddingState>(
            listener: (context, state) {
              if (state is Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is Failed) {
                showFailedSnackbar(context, state.message);
              } else if (state is Success) {
                showSuccessAlertDialog(context, "Xóa đám cưới", state.message,
                    () {
                  Navigator.pop(context);
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                });
              }
            },
          )
        ],
        child: FutureBuilder(
          future: getRole(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final String role = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      SettingItem(null, "Thông tin cá nhân"),
                      SettingItem(null, "Thông tin mặc định"),
                      SettingItem(null, "Chi phí dự trù"),
                      SettingItem("/create_wedding", "Thông tin ngày cưới"),
                      isAdmin(role)
                          ? SettingItem(
                              "/invite_collaborator", "Kết nối với người ấy")
                          : Container(),
                      SettingItem(null, "Ngôn ngữ"),
                      SettingItem(null, "Chính sách bảo mật"),
                      SettingItem(null, "Điều khoản"),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Text('App version 1.0.25'),
                      ),
                      CustomButtom("Đăng xuất", () async {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedOut());
                        NotificationManagement.ClearAllNotifications();
                         var cancel= await AndroidAlarmManager.cancel(0);
                      }, Colors.blue),
                      isAdmin(role)
                          ? CustomButtom("Xoá đám cưới",
                              () => _onDeleteWeddingClick(context), Colors.grey)
                          : CustomButtom("Rời đám cưới",
                              () => _onLeftWeddingClick(context), Colors.grey),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  void _onLeftWeddingClick(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    BlocProvider.of<UserWeddingBloc>(context)
        .add(RemoveUserFromUserWedding(user));
  }

  void _onDeleteWeddingClick(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String weddingId = preferences.getString("wedding_id");
    BlocProvider.of<WeddingBloc>(context).add(DeleteWedding(weddingId));
  }
}
