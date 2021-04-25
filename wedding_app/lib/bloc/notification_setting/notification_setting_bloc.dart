import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/repository/notification_repository.dart';
import 'package:wedding_app/utils/get_share_preferences.dart';
import 'bloc.dart';

class NotificationSettingBloc
    extends Bloc<NotificationSettingEvent, NotificationSettingState> {

  NotificationSettingBloc() : super(NotificationSettingLoading());

  @override
  Stream<NotificationSettingState> mapEventToState(
    NotificationSettingEvent event,
  ) async* {
    if(event is LoadNotificationSettings){
      yield* _mapLoadNotificationSettingToStates();
    }else if(event is ChangeNotification){
      yield* _mapChangeNotificationToState(event);
    }
  }

  Stream<NotificationSettingState>
      _mapLoadNotificationSettingToStates() async* {
    try {
      Map notificationSettings = await getNotificationSettings();
      yield NotificationSettingLoaded(
          notificationSettings: notificationSettings);
    } catch (e) {
      print("[ERROR]: " + e.toString());
      yield NotificationSettingNotLoaded(message: MessageConst.commonError);
    }
  }

  Stream<NotificationSettingState> _mapChangeNotificationToState(ChangeNotification event) async*{
    if(state is NotificationSettingLoaded){
      await changeNotification(event.key);
      final notificationSettings = await getNotificationSettings();
      yield NotificationSettingLoaded(notificationSettings: notificationSettings);
    }
  }
}
