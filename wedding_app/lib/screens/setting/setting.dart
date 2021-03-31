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
import 'package:wedding_app/widgets/confirm_dialog.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:wedding_app/widgets/receive_notification.dart';
import 'package:wedding_app/widgets/widget_key.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void dispose() {
    NotificationManagement.cancelAlarm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserWedding(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final UserWedding userWedding = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: hexToColor("#d86a77"),
                title: Text(
                  "CÀI ĐẶT",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
              bottomSheet: Wrap(
                children: [
                  Center(
                    child: Text('App version 1.0.00'),
                  ),
                  CustomButtom(Key(WidgetKey.logoutButtonKey), "Đăng xuất",
                      () async {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) => PersonDetailsDialog(
                              message: "Bạn có muốn đăng xuất?",
                              onPressedFunction: () async {
                                NotificationManagement.ClearAllNotifications();
                                var cancel = await AndroidAlarmManager.cancel(0);
                                _logOut();
                              },
                            ));
                  }, Colors.blue),
                  CustomButtom(
                      Key(WidgetKey.leaveWeddingButton),
                      "Rời đám cưới",
                      () => _onLeftWeddingClick(context),
                      Colors.grey),
                  isAdmin(userWedding.role)
                      ? CustomButtom(
                          Key(WidgetKey.deleteWeddingButton),
                          "Xoá đám cưới",
                          () => _onDeleteWeddingClick(context),
                          Colors.black54)
                      : Container(),
                ],
              ),
              body: MultiBlocListener(
                listeners: [
                  BlocListener<UserWeddingBloc, UserWeddingState>(
                    listener: (context, state) {
                      if (state is UserWeddingProcessing) {
                      } else if (state is UserWeddingFailed) {
                        showFailedSnackbar(context, state.message);
                      } else if (state is UserWeddingSuccess) {
                        showSuccessAlertDialog(
                            context, "Rời đám cưới", state.message, () {
                          Navigator.pop(context);
                          _logOut();
                        });
                      } else if (state is UserWeddingEmpty) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => PersonDetailsDialog(
                                  message:
                                      "Bạn là người dùng còn lại duy nhất trong đám cưới. Nếu bạn rời thì đám cưới sẽ bị xóa. Bạn có muốn rời?",
                                  onPressedFunction: () async {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    String weddingId =
                                        preferences.getString("wedding_id");
                                    BlocProvider.of<WeddingBloc>(context)
                                        .add(DeleteWedding(weddingId));
                                  },
                                ));
                      }
                    },
                  ),
                  BlocListener<WeddingBloc, WeddingState>(
                    listener: (context, state) {
                      if (state is Loading) {
                      } else if (state is Failed) {
                        showFailedSnackbar(context, state.message);
                      } else if (state is Success) {
                        showSuccessAlertDialog(
                            context, "Xóa đám cưới", state.message, () {
                          Navigator.pop(context);
                          _logOut();
                        });
                      }
                    },
                  )
                ],
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: constraints.copyWith(
                        minHeight: constraints.maxHeight,
                        maxHeight: double.infinity,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: <Widget>[
                            SettingItem(
                                () async => Navigator.pushNamed(
                                    context, "/create_wedding",
                                    arguments: CreateWeddingArguments(
                                        isEditing: true,
                                        wedding:
                                            await getWeddingFromSharePreferences())),
                                "Thông tin đám cưới"),
                            SettingItem(() {
                              Navigator.pushNamed(
                                  context, "/list_collaborator");
                            }, "Danh sách cộng tác viên"),
                            isAdmin(userWedding.role)
                                ? SettingItem(() {
                                    Navigator.pushNamed(
                                        context, "/invite_collaborator");
                                  }, "Chia sẻ quyền quản lý")
                                : Container(),
                            SettingItem(null, "Chính sách bảo mật"),
                            SettingItem(null, "Điều khoản"),
                            SettingItem(null, "Hỗ trợ"),
                            SettingItem(null, "Đánh giá ứng dụng"),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void _onLeftWeddingClick(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) => PersonDetailsDialog(
              message: "Bạn có muốn rời đám cưới?",
              onPressedFunction: () async {
                final User user = FirebaseAuth.instance.currentUser;
                BlocProvider.of<UserWeddingBloc>(context)
                    .add(RemoveUserFromUserWedding(user));
              },
            ));
  }

  void _onDeleteWeddingClick(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PersonDetailsDialog(
              message: "Bạn có muốn xóa đám cưới?",
              onPressedFunction: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                String weddingId = preferences.getString("wedding_id");
                BlocProvider.of<WeddingBloc>(context)
                    .add(DeleteWedding(weddingId));
              },
            ));
  }

  void _logOut() async {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
    NotificationManagement.ClearAllNotifications();
    var cancel = await AndroidAlarmManager.cancel(0);
  }
}
