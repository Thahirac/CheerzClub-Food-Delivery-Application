// ignore_for_file: file_names

import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

class PrivacyStatements extends StatefulWidget {
  const PrivacyStatements({Key? key}) : super(key: key);

  @override
  _PrivacyStatementsState createState() => _PrivacyStatementsState();
}

class _PrivacyStatementsState extends State<PrivacyStatements> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: drowerAfterlogin(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * 16.1,
          color: HexColor("1A1B1D"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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


              Container(
                margin: EdgeInsets.only(left: 20, top: 25,bottom: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 6),
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white, width: 2)),
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
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CheersClubText(
                    text:  AppLocalizations.of(context)
                        .translate('PRIVACY STATEMENTS'),
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ],
              ),



              SizedBox(
                height: 40,
              ),

              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheersClubText( fontSize: 11, alignment:TextAlign.justify,
                      text: AppLocalizations.of(context).translate('ps'),

                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),

              //Reach us
              // Container(
              //   // color: HexColor("5D5D5E"),
              //   height: 40,
              //   padding: EdgeInsets.only(left: 20, right: 20),
              //   margin: EdgeInsets.only(top: 0, bottom: 0),
              //   decoration: BoxDecoration(
              //       border: Border(
              //           bottom: BorderSide(
              //     color: Colors.white,
              //     width: 0.5,
              //   ))),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       CheersClubText(
              //         text:   AppLocalizations.of(context).translate("reachus"),
              //         fontColor: Colors.amber,
              //         fontWeight: FontWeight.w600,
              //         fontSize: 18,
              //       ),
              //       Expanded(child: SizedBox()),
              //     ],
              //   ),
              // ),
              //
              // Container(
              //   // color: HexColor("5D5D5E"),
              //   height: MediaQuery.of(context).size.height * 0.3,
              //   padding: EdgeInsets.only(left: 20, right: 20),
              //   margin: EdgeInsets.only(top: 0, bottom: 0),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       SizedBox(
              //         height: 15,
              //       ),
              //       Row(
              //         children: [
              //           CheersClubText(
              //             text: "Gooimeer 1",
              //             fontColor: Colors.white,
              //             fontWeight: FontWeight.w600,
              //             fontSize: 15,
              //           ),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           CheersClubText(
              //             text: "1411 DC Naarden",
              //             fontColor: Colors.white,
              //             fontWeight: FontWeight.w600,
              //             fontSize: 15,
              //           ),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           CheersClubText(
              //             text: "Netherlands",
              //             fontColor: Colors.white,
              //             fontWeight: FontWeight.w600,
              //             fontSize: 15,
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 15,
              //       ),
              //       Row(
              //         children: [
              //           CheersClubText(
              //             text: "P:020 4745457 | E:s.kasri@planet.com",
              //             fontColor: Colors.white,
              //             fontWeight: FontWeight.w600,
              //             fontSize: 15,
              //           ),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           CheersClubText(
              //             text: "WWW.cheerzclub.com",
              //             fontColor: Colors.amber,
              //             fontWeight: FontWeight.w600,
              //             fontSize: 15,
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 20,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
