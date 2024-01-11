import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/notification/notification_cubit.dart';
import 'package:cheersclub/cubit/repository/notificationRepo.dart';
import 'package:cheersclub/pages/notification_list_page.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

class Notification_Icon extends StatefulWidget {

  const Notification_Icon({Key? key}) : super(key: key);

  @override
  _Notification_IconState createState() => _Notification_IconState();
}

class _Notification_IconState extends State<Notification_Icon> {


  late NotificationCubit notificationCubit;
  int? notificationCount;
  void notificationLoading() {
    notificationCubit.notificationcount();
  }

  Widget notification(){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            PageTransition(
            duration: Duration(milliseconds: 1000),
        type: PageTransitionType.rightToLeft,
        child: Notification_page(),
        inheritTheme: true,
        ctx: context),);
      },
      child: Container(
        width: 30,
        height: 30,
        child: Stack(
          children: [
            const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 28,
            ),
            Container(
              width: 27,
              height: 30,
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 0),
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor("FFC853"),
                    border: Border.all(color: Colors.white, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Center(
                    child: Text(
                      "${notificationCount}",
                      style: TextStyle(fontSize: 8, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    notificationCubit = NotificationCubit(NotificatioNRepository());
    // TODO: implement initState
    notificationLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return  Container(
       child: BlocProvider(
         create: (context) =>  notificationCubit,
         child: BlocListener<NotificationCubit, NotificationState>(
           bloc:  notificationCubit,
           listener: (context, state) {
            if(state is NotificationLoading){}
            else if(state is NotificationSuccessFull){
               notificationCount=state.notificationCount;
             }
             else if (state is NotificationFail) {
               Utils.showDialouge(context, AlertType.error,
                   "No data", state.message);
             }
           },
           child: BlocBuilder<NotificationCubit, NotificationState>(
               builder: (context, state) {
                 if(state is NotificationSuccessFull){
                   return  notification();
                 }else if(state is NotificationFail) {
                   return  notification();
                 }
                 else {
                   return Container(
                     //                             color: Colors.white,
                   );
                 }
               }),
         ),
       ),
     );
  }
}
