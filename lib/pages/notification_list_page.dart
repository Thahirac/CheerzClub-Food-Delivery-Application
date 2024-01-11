import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/notification/notification_cubit.dart';
import 'package:cheersclub/cubit/repository/notificationRepo.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/models/Restourent/Notification.dart';
import 'package:cheersclub/pages/dashbord.dart';
import 'package:cheersclub/pages/view_notification.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import 'LoginScreen.dart';

class Notification_page extends StatefulWidget {

  const Notification_page({Key? key}) : super(key: key);

  @override
  _Notification_pageState createState() => _Notification_pageState();
}

class _Notification_pageState extends State<Notification_page> {


  late NotificationCubit viewNotifCubit;
  List<MyNotification>? notifications=[];
  void notificationLoading() {
    viewNotifCubit.notificationList();
  }



  Widget notificationlist(){
    if(notifications?.length==0){
      return CartEmpty(context);
    }
    else{
      return  ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: notifications?.length,
          itemBuilder: (context, count) {
            return Padding(
              padding: EdgeInsets.only(left: 7, right: 7, top: 5),
              child: Column(
                children: [
                  ListTile(
                    onTap: (){
                      Navigator.push(context, PageTransition(
                          duration: Duration(milliseconds: 1000),
                          type: PageTransitionType.rightToLeft,
                          child:  View_notification_page(id: notifications?[count].id,),
                          inheritTheme: true,
                          ctx: context),);

                    },
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheersClubText(
                          text: "${notifications?[count].title}",fontColor: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),

                        SizedBox(height: 5,),

                        CheersClubText(
                          text: "${notifications?[count].description}",fontColor: Colors.white,
                          fontSize: 8,
                        ),

                      ],
                    ),
                    trailing:  CheersClubText(
                      text: "${notifications?[count].time}",fontColor: Colors.amber,
                      fontSize: 10,
                      over: TextOverflow.ellipsis,
                    ),
                  ),

                  Divider(
                    color: Colors.grey.shade700,
                    height: 13,
                    thickness: 0.3,
                  ),

                ],
              ),
            );
          });
    }


  }


  @override
  void initState() {
    viewNotifCubit = NotificationCubit(NotificatioNRepository());
    // TODO: implement initState
    notificationLoading();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("131313"),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () =>
              // Navigator.pushReplacement(context, PageTransition(
              // duration: Duration(milliseconds: 1000),
              // type: PageTransitionType.leftToRight,
              // child: dash_bord(),
              // inheritTheme: true,
              // ctx: context),),

            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => dash_bord(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 500),
              ),
            ),



          child:  Padding(
            padding: const EdgeInsets.only(left: 7,top: 30),
            child: CheersClubText(
              text:  AppLocalizations.of(context).translate('cl'),fontColor: Colors.amber,
              fontSize: 10,
              //over: TextOverflow.ellipsis,
            ),
          ),
        ),
        title: Container(
          child: CheersClubText(
            text: AppLocalizations.of(context).translate('notif'),fontColor: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) =>  viewNotifCubit,
        child: BlocListener<NotificationCubit, NotificationState>(
          bloc:  viewNotifCubit,
          listener: (context, state) {
            if (state is NotificationInitial) {}
           else if (state is NotificationlistLoading) {}

            else if(state is NotificationlistSuccessFull){
              notifications=state.notifications;
            }
            else if (state is NotificationlistFail) {


              if(state.message.toString()=="Your Login Session Expired") {


                Fluttertoast.showToast(
                    msg:  AppLocalizations.of(context).translate("Please login"),
                    backgroundColor: Colors.amber,
                    textColor: Colors.black,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    fontSize: 16.0
                );

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => LoginScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var tween = Tween(begin: begin, end: end);
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    transitionDuration: Duration(milliseconds: 500),
                  ),
                );
              }else {

                Utils.showDialouge(
                    context, AlertType.error, "Oops!", state.message);
              }

            }
          },
          child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationInitial) {
                  return Column(
                    children: const [
                      SizedBox(height: 390,),
                      Center(child: CupertinoActivityIndicator(radius: 10,),),
                    ],
                  );
                }
                else if (state is NotificationlistLoading) {
                  return Column(
                    children: const [
                      SizedBox(height: 390,),
                      Center(child: CupertinoActivityIndicator(radius: 10,),),
                    ],
                  );
                }
               else if(state is NotificationlistSuccessFull){
                  return notificationlist();
                }else if(state is NotificationlistFail) {
                  return notificationlist();
                }
                else {
                  return Container(color: Colors.white54,);
                }
              }
              ),
        ),
      ),
    );
  }


  Widget CartEmpty(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off,size: 130,color: Colors.amber,),
            const SizedBox(height: 20),
            const CheersClubText(
              text: "No Notification Here",
              fontColor: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
            const SizedBox(height: 30),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                  primary: Colors.amber,
                ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: const CheersClubText(
                    text: "Return to Dashboard Page",
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {


                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => dash_bord(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        var begin = Offset(1.0, 0.0);
                        var end = Offset.zero;
                        var tween = Tween(begin: begin, end: end);
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                    ),
                  );


                  // Navigator.pushReplacement(
                  //   context,
                  //   PageTransition(
                  //       duration: Duration(milliseconds: 400),
                  //       type: PageTransitionType.leftToRight,
                  //       child: dash_bord(),
                  //       inheritTheme: true,
                  //       ctx: context),
                  // );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
