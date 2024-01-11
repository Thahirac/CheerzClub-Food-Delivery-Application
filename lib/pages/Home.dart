// ignore_for_file: file_names

import 'dart:ui';

import 'package:cheersclub/Utils/managers/location_manager.dart';
import 'package:cheersclub/pages/Restourents_list.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  // String? _selectedLocation = "";
  //
  // void getCurrentAddress() async {
  //   LocationDetails? locationDetails = await LocationManager.instance.getCurrentAddressDetails();
  //   setState(() {
  //     _selectedLocation = locationDetails!.lat.toString();
  //
  //     print("************MY**LOCATION********"+_selectedLocation.toString());
  //   });
  // }

  @override
  void initState() {
    // getCurrentAddress();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: drowerAfterlogin(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //padding: EdgeInsets.only(top: 100),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backshome.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                      Row(
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
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CheersClubText(
                            text: "IN JUST",
                            fontColor: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CheersClubText(
                            text: "3",
                            fontColor: Colors.amber,
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CheersClubText(
                            text: "STEPS",
                            fontColor: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: CheersClubText(
                  text:
                      "Suprice Your family or frinds with a drink\n offering in their favorite restaurants",
                  fontColor: Colors.white,
                  fontSize: 16,
                ),
              ),
              Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 1000),
                        type: PageTransitionType.rightToLeft,
                        child: RestourentList(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                        color: Colors.black54.withOpacity(0.5),
                        height: 120,
                        width: 160,
                        padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheersClubText(
                              text: "1".toUpperCase(),
                              alignment: TextAlign.start,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.amber,
                            ),
                            CheersClubText(
                              text: "Select a \nRestaurant".toUpperCase(),
                              alignment: TextAlign.start,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 1000),
                        type: PageTransitionType.rightToLeft,
                        child: RestourentList(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                        color: Colors.black54.withOpacity(0.5),
                        height: 120,
                        width: 160,
                        padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheersClubText(
                              text: "2".toUpperCase(),
                              alignment: TextAlign.start,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.amber,
                            ),
                            CheersClubText(
                              text: "Select Gift Or\nyour choice".toUpperCase(),
                              alignment: TextAlign.start,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 1000),
                        type: PageTransitionType.rightToLeft,
                        child: RestourentList(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                        color: Colors.black54.withOpacity(0.5),
                        height: 120,
                        width: 160,
                        padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheersClubText(
                              text: "3".toUpperCase(),
                              alignment: TextAlign.start,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.amber,
                            ),
                            CheersClubText(
                              text: "PAY & LEAVE \nMESSAGE".toUpperCase(),
                              alignment: TextAlign.start,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}



