import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/notification/notification_cubit.dart';
import 'package:cheersclub/cubit/repository/notificationRepo.dart';
import 'package:cheersclub/models/Restourent/Notification.dart';
import 'package:cheersclub/pages/notification_list_page.dart';
import 'package:cheersclub/pages/orderdetails_page.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

class View_notification_page extends StatefulWidget {
  final String? id;



  const View_notification_page({Key? key,this.id,}) : super(key: key);

  @override
  _View_notification_pageState createState() => _View_notification_pageState();
}

class _View_notification_pageState extends State<View_notification_page> {


  GlobalKey<ScaffoldState> _key = GlobalKey();

  SingleNotification? notification;

  late NotificationCubit viewNotifCubit;


  @override
  void initState() {
    viewNotifCubit = NotificationCubit(NotificatioNRepository());
    // TODO: implement initStat
    viewNotifCubit.GetoneNotif(widget.id!);
    //personal_message_Controller = TextEditingController(text: message);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("1A1B1D"),
      key: _key,
      endDrawer: drowerAfterlogin(),
      resizeToAvoidBottomInset: false,

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: BlocProvider(
            create: (context) => viewNotifCubit,
            child: BlocListener<NotificationCubit, NotificationState>(
              bloc:  viewNotifCubit,
              listener: (context, state) {
                if (state is ViewnotifLoading) {}
                else if (state is ViewnotifSuccess) {
                  notification=state.notification;
                } else if (state is ViewnotifFail) {
                  Utils.showDialouge(context, AlertType.error, "Oops!", state.msg);
                }
              },
              child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    if (state is ViewnotifLoading) {
                      return Column(
                        children: const [
                          SizedBox(height: 410,),
                          Center(child: CupertinoActivityIndicator(radius: 10,),),
                        ],
                      );
                    } else if (state is ViewnotifSuccess) {
                      return  notificationdetailform();
                    } else if (state is  ViewnotifFail) {
                      return  notificationdetailform();
                    }
                    else {
                      return  notificationdetailform();
                    }
                  }),
            )),
      ),

    );
  }

  Widget notificationdetailform(){
    return Container(
      //color: HexColor("1A1B1D"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //Logo
          //Drawer
          Container(
            height: 100,
            child: Container(
              color: HexColor("131313"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 13, top: 25),
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      "assets/images/cheerzlogonew.png",
                      fit: BoxFit.fitHeight,
                      height: 55,
                      //width: 220,
                    ),
                  ),
                  Expanded(child: SizedBox()),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _key.currentState!.openEndDrawer();
                          //Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20, top: 40),
                          child: Image.asset(
                            "assets/images/nav.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),


          //Back Button
          Container(
              margin: EdgeInsets.only(left: 20, top: 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {

                      // Navigator.pushReplacement(context, PageTransition(
                      //     duration: Duration(milliseconds: 1000),
                      //     type: PageTransitionType.leftToRight,
                      //     child:  Notification_page(),
                      //     inheritTheme: true,
                      //     ctx: context),);


                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => Notification_page(),
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


                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 6),
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24),
                          border:
                          Border.all(color: Colors.white, width: 2)),
                      margin: EdgeInsets.only(right: 0, top: 0),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),



                ],
              )),

         SizedBox(height: 25,),

          InkWell(
            onTap: (){

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => OrderDetails(
                    id: notification?.orderId.toString(),
                    status: notification?.status,
                    pstatus: notification?.paymentStatus,
                  ),
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

            },
            child: Container(
              height: 30,
              padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(top: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "#000${notification?.orderId}",
                    style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white,fontFamily: "Raleway" ),
                  ),
                  Expanded(child: SizedBox()),

                ],
              ),
            ),
          ),

          Container(
            height: 30,
            padding: EdgeInsets.only(left: 20, right: 20),
            margin: EdgeInsets.only(top: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CheersClubText(
                    text: "${notification?.title}",
                    fontColor: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
                Expanded(child: SizedBox()),
                CheersClubText(
                  text: "${notification?.time}",
                  fontColor: Colors.amber,
                  fontSize: 10,),

              ],
            ),
          ),
          Container(
            height: 30,
            padding: EdgeInsets.only(left: 20, right: 20),
            margin: EdgeInsets.only(top: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CheersClubText(
                    text: "${notification?.description}",
                    fontColor: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w500),
                Expanded(child: SizedBox()),
              ],
            ),
          ),




          SizedBox(height: 30,),
        ],
      ),
    );
  }



}
