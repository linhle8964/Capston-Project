import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/notification_setting/bloc.dart';
import 'package:wedding_app/const/share_prefs_key.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationSettingScreen extends StatefulWidget {
  @override
  _NotificationSettingScreenState createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#d86a77"),
        title: Text(
          "CÀI ĐẶT THÔNG BÁO",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder(
        cubit: BlocProvider.of<NotificationSettingBloc>(context),
        builder: (context, state) {
          if (state is NotificationSettingLoaded) {
            Map notificationSettings = state.notificationSettings;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(
                        "Thông báo task",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      trailing: Switch(
                        value: notificationSettings[SharedPreferenceKey.taskNotification],
                        onChanged: (value) {
                          BlocProvider.of<NotificationSettingBloc>(context).add(ChangeNotification(SharedPreferenceKey.taskNotification));
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        "Khách mời phản hồi",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      trailing: Switch(
                        value: notificationSettings[SharedPreferenceKey.guestResponseNotification],
                        onChanged: (value) async{
                          BlocProvider.of<NotificationSettingBloc>(context).add(ChangeNotification(SharedPreferenceKey.guestResponseNotification));
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if(state is NotificationSettingNotLoaded){
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
