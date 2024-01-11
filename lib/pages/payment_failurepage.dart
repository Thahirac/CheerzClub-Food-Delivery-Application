// import 'package:eradealz/Screen/Cart/Cartpage.dart';
// import 'package:eradealz/Widgets/custom_page_route.dart';
// import 'package:eradealz/constant.dart';

import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/pages/kartpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class PaymentFailurePage extends StatefulWidget {
  Color? color;
  IconData? icon;
  //String description;
  String? message;
  int? rest_id;
  PaymentFailurePage({Key? key,this.icon,this.message,this.color,this.rest_id});
  @override
  _PaymentFailurePageState createState() => _PaymentFailurePageState();
}

class _PaymentFailurePageState extends State<PaymentFailurePage> {
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
                        pageBuilder: (c, a1, a2) => Restourentcart(restorent_id: widget.rest_id,),
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
                    //       child: Restourentcart(restorent_id: widget.rest_id,),
                    //       inheritTheme: true,
                    //       ctx: context),
                    // );
                  },
                ),
              ],
            ),
            SizedBox(height: size.height * 0.15),
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
                      widget.icon,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Text(
                    widget.message.toString(),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.9,
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  // Container(
                  //   child: Text(
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
                  //   "show failed message here",
                  //   style: TextStyle(
                  //     // fontSize: 14,
                  //     color: eraTextColor,
                  //     fontWeight: FontWeight.w500,
                  //     letterSpacing: 0.9,
                  //   ),
                  // ),
                  // SizedBox(height: size.height * 0.04),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            duration: Duration(milliseconds: 500),
                            type: PageTransitionType.rightToLeft,
                            child: Restourentcart(restorent_id: widget.rest_id,),
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('gtoc'),
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
