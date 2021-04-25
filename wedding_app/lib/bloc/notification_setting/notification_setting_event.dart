import 'package:wedding_app/model/notification.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationSettingEvent extends Equatable{

}

class LoadNotificationSettings extends NotificationSettingEvent {
  LoadNotificationSettings();

  @override
  List<Object> get props => [];
}

class ChangeNotification extends NotificationSettingEvent{
  final String key;

  ChangeNotification(this.key);
  @override
  List<Object> get props => [key];
}


