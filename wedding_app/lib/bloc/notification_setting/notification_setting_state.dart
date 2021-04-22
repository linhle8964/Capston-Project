import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NotificationSettingState extends Equatable {
}

class NotificationSettingLoading extends NotificationSettingState{
  @override
  List<Object> get props => [];
}

class NotificationSettingLoaded extends NotificationSettingState{
  final Map notificationSettings;

  NotificationSettingLoaded({@required this.notificationSettings});
  @override
  List<Object> get props => [notificationSettings];
}

class NotificationSettingNotLoaded extends NotificationSettingState{
  final String message;

  NotificationSettingNotLoaded({@required this.message});
  @override
  List<Object> get props => [message];
}
