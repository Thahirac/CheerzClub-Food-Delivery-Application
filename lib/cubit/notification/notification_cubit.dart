import 'package:bloc/bloc.dart';
import 'package:cheersclub/cubit/repository/dashbordRepository.dart';
import 'package:cheersclub/cubit/repository/notificationRepo.dart';
import 'package:cheersclub/models/Restourent/MyGreetings.dart';
import 'package:cheersclub/models/Restourent/Notification.dart';
import 'package:cheersclub/models/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {

  int? notificationCount;
  List<MyNotification>? notifications;
  SingleNotification? notification;


  NotificationCubit(this.notificatioNRepository) : super(NotificationInitial());
  final NotificatioNRepository notificatioNRepository;

  Future<void> notificationcount() async {
    emit(NotificationLoading());
    Result? result = await notificatioNRepository.notificationcount();
    if (result.isSuccess) {

      notificationCount =result.success['notification_count'];
      print("*************FEE**********************"+notificationCount.toString());


      emit(NotificationSuccessFull(notificationCount));
    } else {
      emit(NotificationFail(result.failure));
    }
  }


  Future<void> notificationList() async {
    emit(NotificationlistLoading());
    Result? result = await notificatioNRepository.notificationList();
    if (result.isSuccess) {

      dynamic kartItems = result.success['notifications'];
      notifications = NotificationsList(kartItems);


      emit(NotificationlistSuccessFull(notifications));
    } else {
      emit(NotificationlistFail(result.failure));
    }
  }

  Future<void> GetoneNotif(String id) async {
    emit(ViewnotifLoading());
    Result? result = await notificatioNRepository.GetoneNotif(id);
    if (result.isSuccess) {

      dynamic notif = result.success['notification'];

      notification = SingleNotification(
        id:  notif['id'],
        time:  notif["time"],
        title:  notif["title"],
        description: notif["description"],
        url:  notif["url"],
        orderId: notif['order_id'],
        status: notif['status'],
        paymentStatus: notif['payment_status']
      );

      emit(ViewnotifSuccess(notification));
    } else {
      emit(ViewnotifFail(result.failure));
    }
  }



}

List<MyNotification> NotificationsList(List data) {
  List<MyNotification> notificationlist = [];
  var length = data.length;
  print("**********notification***LENGTH**********"+length.toString());

  for (int i = 0; i < length; i++) {
    MyNotification products = MyNotification(
        id: data[i]?['id'],
        time: data[i]?["time"],
        title: data[i]?["title"],
        description: data[i]?["description"],
        url: data[i]?["url"],
    );
    notificationlist.add(products);
  }
  return notificationlist;
}

