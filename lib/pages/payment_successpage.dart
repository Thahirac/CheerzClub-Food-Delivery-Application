// import 'package:eradealz/Screen/Cart/Cartpage.dart';
// import 'package:eradealz/Screen/Order%20History/order_history.dart';
// import 'package:eradealz/Widgets/custom_page_route.dart';
// import 'package:eradealz/constant.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/pages/dashbord.dart';
import 'package:cheersclub/pages/kartpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class PaymentSuccessPage extends StatefulWidget {
  Color? color;
  IconData? icon;
  String? message;
  int? resId;
  PaymentSuccessPage({
    this.color,
    this.icon,
    this.message,
    this.resId
  });
  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("1A1B1D"),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () {


                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => Restourentcart(restorent_id: widget.resId,),
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
                    //       duration: Duration(milliseconds: 500),
                    //       type: PageTransitionType.rightToLeft,
                    //       child: Restourentcart(restorent_id: widget.resId,),
                    //       inheritTheme: true,
                    //       ctx: context),
                    // );

                  },
                ),
              ],
            ),
            SizedBox(height: size.height * 0.18),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      // Icons.check,
                      widget.icon,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Text(
                    // "Payment Successful",
                    widget.message.toString(),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.9,
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  // Container(
                  //   child: Text(
                  //     // "Your Order was placed successfully.\nFor more details, check My Orders\nunder Profile tab",
                  //     widget.description,
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       color: eraTextColor,
                  //       height: 1.4,
                  //       letterSpacing: 0.8,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: size.height * 0.035),
                  // Text(
                  //   "Payment ID: ${widget.id}",
                  //   style: TextStyle(
                  //     color: eraTextColor,
                  //     fontWeight: FontWeight.w500,
                  //     letterSpacing: 0.9,
                  //   ),
                  // ),
                  // SizedBox(height: size.height * 0.04),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {

                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) =>  dash_bord(),
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


                      // Navigator.pushReplacement(context,
                      //   PageTransition(
                      //       duration: Duration(milliseconds: 1000),
                      //       type: PageTransitionType.rightToLeft,
                      //       child: dash_bord(),
                      //       inheritTheme: true,
                      //       ctx: context),
                      // );

                    },
                    child: Text(
                      AppLocalizations.of(context).translate('vos'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           actionsIconTheme: IconThemeData(
//             color: Colors.black,
//             size: 26,
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(
//                 Icons.cancel,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//         body: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 height: 80,
//                 width: 80,
//                 decoration: BoxDecoration(
//                   color: widget.color,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   widget.icon,
//                   color: Colors.white,
//                   size: 40,
//                 ),
//               ),
//               Text(
//                 widget.message,
//                 textAlign: TextAlign.justify,
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: eraMainTextColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 widget.description,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: eraMainTextColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 "Payment ID: ${widget.id}",
//                 style: TextStyle(
//                   // fontSize: 14,
//                   color: eraMainTextColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.green,
//                 ),
//                 onPressed: widget.onTap,
//                 child: Text(
//                   "View order status",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );