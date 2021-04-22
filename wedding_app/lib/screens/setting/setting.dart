import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';
import 'package:wedding_app/bloc/user_wedding/bloc.dart';
import 'package:wedding_app/bloc/wedding/bloc.dart';
import 'package:wedding_app/const/route_name.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/screens/create_wedding/create_wedding_argument.dart';
import 'package:wedding_app/screens/setting/custom_button.dart';
import 'package:wedding_app/screens/setting/setting_item.dart';
import 'package:wedding_app/utils/alert_dialog.dart';
import 'package:wedding_app/utils/get_share_preferences.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:wedding_app/widgets/receive_notification.dart';
import 'package:wedding_app/const/widget_key.dart';

class SettingPage extends StatefulWidget {
  final UserWedding userWedding;
  final Wedding wedding;

  SettingPage({Key key, @required this.userWedding, @required this.wedding}) : super(key: key);
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
    UserWedding userWedding = widget.userWedding;
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
          CustomButtom(Key(WidgetKey.logoutButtonKey), "Đăng xuất", () async {
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
          CustomButtom(Key(WidgetKey.leaveWeddingButton), "Rời đám cưới",
              () => _onLeftWeddingClick(context), Colors.grey),
          isAdmin(userWedding.role)
              ? CustomButtom(Key(WidgetKey.deleteWeddingButton), "Xoá đám cưới",
                  () => _onDeleteWeddingClick(context), Colors.black54)
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
                showSuccessAlertDialog(context, "Rời đám cưới", state.message,
                    () {
                  Navigator.pop(context);
                  _logOut();
                });
              } else if (state is UserWeddingEmpty) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => PersonDetailsDialog(
                          message:
                              "Bạn là Admin còn lại duy nhất trong đám cưới. Nếu bạn rời thì đám cưới sẽ bị xóa. Bạn có muốn rời?",
                          onPressedFunction: () async {
                            BlocProvider.of<WeddingBloc>(context)
                                .add(DeleteWedding(widget.wedding.id));
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
                showSuccessAlertDialog(context, "Xóa đám cưới", state.message,
                    () {
                  Navigator.pop(context);
                  _logOut();
                });
              }
            },
          )
        ],
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: Column(
                  children: <Widget>[
                    SettingItem(() {
                      Navigator.pushNamed(context, RouteName.changePassword);
                    }, "Thay đổi mật khẩu"),
                    SettingItem(
                        () => Navigator.pushNamed(
                            context, RouteName.createWedding,
                            arguments: CreateWeddingArguments(
                                isEditing: true,
                                wedding: widget.wedding)),
                        "Thông tin đám cưới"),
                    SettingItem(() {
                      Navigator.pushNamed(context, RouteName.listCollaborator);
                    }, "Danh sách cộng tác viên"),
                    isAdmin(userWedding.role)
                        ? SettingItem(() {
                            Navigator.pushNamed(
                                context, RouteName.inviteCollaborator);
                          }, "Chia sẻ quyền quản lý")
                        : Container(),
                    SettingItem(
                        () => Navigator.pushNamed(context, RouteName.privacy),
                        "Chính sách bảo mật"),
                    SettingItem(
                        () => Navigator.pushNamed(context, RouteName.term),
                        "Điều khoản"),
                  ],

              ),
            ),
          );
        }),
      ),
    );
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
                BlocProvider.of<WeddingBloc>(context)
                    .add(DeleteWedding(widget.wedding.id));
              },
            ));
  }

  void _logOut() async {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
    NotificationManagement.ClearAllNotifications();
    var cancel = await AndroidAlarmManager.cancel(0);
  }
}
