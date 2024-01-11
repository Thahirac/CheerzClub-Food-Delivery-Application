part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccessFull extends NotificationState {
  final int? notificationCount;
  NotificationSuccessFull(this.notificationCount);
}

class NotificationFail extends NotificationState {
  final String message;

  NotificationFail(this.message);
}
class NotificationlistLoading extends NotificationState {}

class NotificationlistSuccessFull extends NotificationState {

  final List<MyNotification>? notifications;
  NotificationlistSuccessFull(this.notifications);
}

class NotificationlistFail extends NotificationState {
  final String message;

  NotificationlistFail(this.message);
}
class ViewnotifLoading extends NotificationState {}

class ViewnotifSuccess extends NotificationState {


  final SingleNotification? notification;

  ViewnotifSuccess(this.notification);
}

class ViewnotifFail extends NotificationState {

  final String msg;

  ViewnotifFail(this.msg);

}