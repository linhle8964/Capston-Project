import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/screens/create_wedding/create_wedding_argument.dart';
import 'package:wedding_app/screens/setting/custom_button.dart';
import 'package:wedding_app/screens/setting/setting_item.dart';
import 'package:wedding_app/utils/alert_dialog.dart';
import 'package:wedding_app/utils/get_share_preferences.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding_app/widgets/add_notification.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:wedding_app/widgets/receive_notification.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    NotificationManagement.cancelAlarm();
    AddTaskNotification.cancel();
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
          future: getUserWedding(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final UserWedding userWedding = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      SettingItem(null, "Thông tin cá nhân"),
                      SettingItem(
                          () async => Navigator.pushNamed(
                              context, "/create_wedding",
                              arguments: CreateWeddingArguments(
                                  isEditing: true,
                                  wedding:
                                      await getWeddingFromSharePreferences())),
                          "Thông tin đám cưới"),
                      SettingItem(null, "Chi phí dự trù"),
                      SettingItem(null, "Thông tin ngày cưới"),
                      isAdmin(userWedding.role)
                          ? SettingItem(() {
                              Navigator.pushNamed(
                                  context, "/invite_collaborator");
                            }, "Chia sẻ quyền quản lý")
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
                        var cancel = await AndroidAlarmManager.cancel(0);
                      }, Colors.blue),
                      isAdmin(userWedding.role)
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

  void _onLeftWeddingClick(BuildContext ctx) {
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext context) => PersonDetailsDialog(
              message: "Bạn có muốn rời đám cưới?",
              onPressedFunction: () async {
                final User user = FirebaseAuth.instance.currentUser;
                BlocProvider.of<UserWeddingBloc>(ctx)
                    .add(RemoveUserFromUserWedding(user));
              },
            ));
  }

  void _onDeleteWeddingClick(BuildContext ctx) async {
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (context) => PersonDetailsDialog(
              message: "Bạn có muốn xóa đám cưới?",
              onPressedFunction: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                String weddingId = preferences.getString("wedding_id");
                BlocProvider.of<WeddingBloc>(ctx).add(DeleteWedding(weddingId));
              },
            ));
  }
}
