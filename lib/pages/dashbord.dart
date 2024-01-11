import 'dart:ui';

import 'package:cheersclub/Utils/managers/location_manager.dart';
import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/auth/Dashboard/dashbord_cubit.dart';
import 'package:cheersclub/cubit/repository/dashbordRepository.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/models/Restourent/MyGreetings.dart';
import 'package:cheersclub/models/Restourent/Notification.dart';
import 'package:cheersclub/models/auth/user.dart';
import 'package:cheersclub/pages/LoginScreen.dart';
import 'package:cheersclub/pages/Restourents_list.dart';
import 'package:cheersclub/pages/orderdetails_page.dart';
import 'package:cheersclub/pages/greetingdetails_page.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:cheersclub/widgets/notification_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'leaveAmessage_page.dart';


class LocationDetails {
  final double? lat;
  final double? long;
  final String? state;
  final String? district;
  final String? address;
  final String? street;
  final String? pin;

  const LocationDetails(
      this.lat,
      this.long,
      this.state,
      this.district,
      this.address,
      this.street,
      this.pin,
      );
}


class dash_bord extends StatefulWidget {
  final String? accountType;
  final String? iscomplted;
  const dash_bord({Key? key, this.accountType, this.iscomplted})
      : super(key: key);
  @override
  _dash_bordState createState() => _dash_bordState();
}

class _dash_bordState extends State<dash_bord> {

  static final TextInputFormatter digitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  bool _isloading=false;
  bool _isloading2=false;
  DateTime pre_backpress = DateTime.now();

  String? _status;
  Color? clor;
  // 1 - Paid,      2- Refunded,   0-Failed
  void statuschecking(item, item1) async {
    if (item == 0 && item1 == 0) {
      _status = AppLocalizations.of(context).translate("cncl");
      clor = Colors.red;
    } else if (item == 0 && item1 == 1) {
      _status = AppLocalizations.of(context).translate("p");
      clor = Colors.amber;
    } else if (item == 0 && item1 == 2) {
      _status = AppLocalizations.of(context).translate("p");
      clor = Colors.amber;
    } else if (item == 1 && item1 == 1) {
      _status = AppLocalizations.of(context).translate("c");
      clor = Colors.green;
    } else if (item == 2 && item1 == 0) {
      _status = AppLocalizations.of(context).translate("cncl");
      clor = Colors.red;
    } else if (item == 2 && item1 == 1) {
      _status = AppLocalizations.of(context).translate("cncl");
      clor = Colors.red;
    } else if (item == 2 && item1 == 2) {
      _status = AppLocalizations.of(context).translate("cncl");
      clor = Colors.red;
    } else {
      _status = AppLocalizations.of(context).translate("p");
      clor = Colors.yellow;
    }
  }

  late DashbordCubit dashbordCubit;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool my_oders = true;
  bool my_greetings = false;
  bool my_profile = false;
  bool _isAlwaysShown = true;
  var CurrentPassword_Controller = TextEditingController();
  var NewPassword_Controller = TextEditingController();
  var ConfirmPassword_Controller = TextEditingController();

  String? txt_fullname_Controller;
  String? address_controller;
  String? txt_Phoneno_Controller;
  String? date_controller;
  String? txt_zip_Controller;
  String? txt_Country_Controller;
  String? txt_city_Controller;

  dynamic contactperson_controller;
  String? Chamberofcommerce_controller;
  String? vatnumber_controller;

  bool _showTrackOnHover = false;
  late ScrollController scrollcontroller;

  String? _selectedLatLocation = "";
  String? _selectedLongLocation = "";



  Widget myoders() {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: OrderListdata.length,
        itemBuilder: (context, count) {
          var tempDate = OrderListdata[count].deliveryDate.toString();
          var correct = DateUtil().formattedDate(DateTime.parse(tempDate));
          statuschecking(OrderListdata[count].status, OrderListdata[count].paymentStatus);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 500),
                    type: PageTransitionType.rightToLeft,
                    child: OrderDetails(
                      id: OrderListdata[count].id.toString(),
                      date: correct,
                      status: OrderListdata[count].status,
                      pstatus: OrderListdata[count].paymentStatus,
                    ),
                    inheritTheme: true,
                    ctx: context),
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 57,
                    color: HexColor("464749"),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CheersClubText(
                              text: OrderListdata[count].name??"",
                              fontColor: Colors.amber,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            CheersClubText(
                              text: "" + OrderListdata[count].id.toString(),
                              fontColor: Colors.white,
                            ),
                          ],
                        ),
                        Expanded(child: SizedBox()),
                        Expanded(child: SizedBox()),
                        Container(
                          height: 20,
                          width:95,
                          color: clor,
                          child: Padding(
                            padding: const EdgeInsets.all(2.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CheersClubText(
                                  text: _status.toString(),
                                  fontColor: Colors.black,
                                  fontSize: 9.5,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.all(10),
                    color: HexColor("2C2D2F"),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CheersClubText(
                              text: AppLocalizations.of(context)
                                  .translate("skey"),
                              fontColor: Colors.amber,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              OrderListdata[count].userSecret.toString(),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Expanded(child: SizedBox()),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CheersClubText(
                              text: correct,
                              fontColor: Colors.amber,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/euro.png",
                                  height: 8,
                                  width: 8,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                CheersClubText(
                                    text:  OrderListdata[count].price!.toStringAsFixed(2).toString(),
                                    fontColor: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget mygreetings() {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: greetingListdata.length,
        itemBuilder: (context, count) {
          var tempDate = greetingListdata[count].deliveryDate.toString();
          var correct = DateUtil().formattedDate(DateTime.parse(tempDate));
          return Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 57,
                  color: HexColor("464749"),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CheersClubText(
                            text:
                                AppLocalizations.of(context).translate("rcpnt"),
                            fontColor: Colors.amber,
                            fontSize: 10,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          CheersClubText(
                            text: greetingListdata[count].name??"",
                            fontColor: Colors.white,
                            fontSize: 14,
                          )
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CheersClubText(
                            text: AppLocalizations.of(context).translate("dd"),
                            fontColor: Colors.amber,
                            fontSize: 10,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          CheersClubText(
                            text: correct,
                            fontColor: Colors.white,
                          )
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      greetingListdata[count].status == 1
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 500),
                                      type: PageTransitionType.rightToLeft,
                                      child: Updategreeting(
                                        id: greetingListdata[count].id,
                                      ),
                                      inheritTheme: true,
                                      ctx: context),
                                );
                              },
                              child: Container(
                                height: 24,
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CheersClubText(
                                        text: AppLocalizations.of(context)
                                            .translate("edit"),
                                        fontColor: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 2),
                                        height: 12,
                                        width: 12,
                                        child: Image.asset(
                                            "assets/images/editicon.png"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget myprofile() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: EdgeInsets.all(10),
              height: 58,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          pd = 0;
                        });

                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.amber,
                            content: Container(
                              color: Colors.amber,
                              height: 270,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: SizedBox()),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              color: Colors.black),
                                          child: Icon(
                                            Icons.clear_outlined,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 0, right: 0, top: 10),
                                    child: TextField(
                                      style: TextStyle(color: Colors.white),
                                      controller: CurrentPassword_Controller,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)
                                            .translate("currentpass"),
                                        hintStyle: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                        filled: true,
                                        fillColor: HexColor("28292C"),
                                        contentPadding: const EdgeInsets.only(
                                            left: 14.0, bottom: 6.0, top: 8.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: HexColor("28292C")),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: HexColor("28292C")),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 0, right: 0, top: 10),
                                    child: TextField(
                                      style: TextStyle(color: Colors.white),
                                      controller: NewPassword_Controller,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)
                                            .translate("newpass"),
                                        hintStyle: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                        filled: true,
                                        fillColor: HexColor("28292C"),
                                        contentPadding: const EdgeInsets.only(
                                            left: 14.0, bottom: 6.0, top: 8.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: HexColor("28292C")),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: HexColor("28292C")),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 0, right: 0, top: 10),
                                    child: TextField(
                                      style: TextStyle(color: Colors.white),
                                      controller: ConfirmPassword_Controller,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)
                                            .translate("confirmpass"),
                                        hintStyle: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                        filled: true,
                                        fillColor: HexColor("28292C"),
                                        contentPadding: const EdgeInsets.only(
                                            left: 14.0, bottom: 6.0, top: 8.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: HexColor("28292C")),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: HexColor("28292C")),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {

                                          setState(() {
                                            _isloading2=true;
                                          });

                                          dashbordCubit.PasswordChange(
                                              CurrentPassword_Controller.text,
                                              NewPassword_Controller.text,
                                              ConfirmPassword_Controller.text);

                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 140,
                                          height: 50,
                                          color: HexColor("28292C"),
                                          child: Center(
                                              child: _isloading? Padding(padding: const EdgeInsets.all(10.0), child: const SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),):Text(
                                            AppLocalizations.of(context)
                                                .translate('Changepassword'),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          )),
                                        ),
                                      ),
                                      Expanded(child: SizedBox())
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.grey,
                        child: Center(
                          child: CheersClubText(
                            text: AppLocalizations.of(context)
                                .translate('Changepassword'),
                            fontColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print("hello");
                        setState(() {
                          pd = 1;
                        });
                      },
                      child: Container(
                        color: Colors.red,
                        child: Center(
                          child: CheersClubText(
                            text: AppLocalizations.of(context)
                                .translate('Editprofile'),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20,top: 10),
              padding: EdgeInsets.all(10),
              height: 50,
              child: Row(
                children: [
                  CheersClubText(
                    text: widget.accountType == "1"
                        ? AppLocalizations.of(context)
                            .translate('Companydetails')
                        : AppLocalizations.of(context)
                            .translate('Personaldetails'),
                    fontColor: Colors.white,
                    fontSize: 20,
                  )
                ],
              ),
            ),


            // Container(
            //   margin: EdgeInsets.only(left: 30, right: 30),
            //   child: Divider(
            //     height: 1,
            //     thickness: 1,
            //     color: Colors.white54,
            //   ),
            // ),


            screensPd(pd)
          ],
        ),
      ),
    );
  }

  Widget personal() {
    var tempDate = user?.dob.toString();
    print(tempDate);
    var correct = DateUtil1().formattedDate(DateTime.parse(tempDate!));
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.all(10),
            height: 50,
            child: Row(
              children: [
                CheersClubText(
                  text: user?.name != null && user?.name != "null"
                      ? user?.name!
                      : "",
                  fontColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.all(10),
            height: 50,
            child: Row(
              children: [
                CheersClubText(
                  text: "" + "${user?.email!}",
                  fontColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.all(10),
            height: 50,
            child: Row(
              children: [
                CheersClubText(
                  text: user?.phone != null && user?.phone != "null"
                      ? "" + "${user?.phone}"
                      : "",
                  fontColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ),
          widget.accountType == "1"
              ? Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Row(
                    children: [
                      CheersClubText(
                        text: user?.contactPerson != null &&
                                user?.contactPerson != "null"
                            ? "${(user?.contactPerson)}"
                            : "",
                        fontColor: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Row(
                    children: [
                      CheersClubText(
                        text: tempDate == "-0001-11-30 00:00:00.000"
                            ? ""
                            : user?.dob != null
                                ? correct
                                : "",
                        fontColor: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.all(10),
            height: 50,
            child: Row(
              children: [
                CheersClubText(
                  text: user?.address != null && user?.address != "null"
                      ? "${(user?.address)}"
                      : "",
                  fontColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.all(10),
            height: 50,
            child: Row(
              children: [
                CheersClubText(
                  text: user?.zip != null &&
                          user?.zip != "null" &&
                          user?.city != "null"
                      ? "${(user?.zip)},${(user?.city)}"
                      : "",
                  fontColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.all(10),
            height: 50,
            child: Row(
              children: [
                CheersClubText(
                  text: user?.country != null && user?.country != "null"
                      ? "" + "${user?.country}"
                      : "",
                  fontColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ),
          widget.accountType == "1"
              ? Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Row(
                    children: [
                      CheersClubText(
                        text: user?.coc != null && user?.coc != "null"
                            ? "${(user?.coc)}"
                            : "",
                        fontColor: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                )
              : Container(),
          widget.accountType == "1"
              ? Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Row(
                    children: [
                      CheersClubText(
                        text:
                            user?.vatNumber != null && user?.vatNumber != "null"
                                ? "${(user?.vatNumber)}"
                                : "",
                        fontColor: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget Editprofile() {
    var tempDate = user?.dob.toString();
    print(tempDate);
    var correct = DateUtil1().formattedDate(DateTime.parse(tempDate!));
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Company&full name
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: CheersClubText(
                text: widget.accountType == "1"
                    ? AppLocalizations.of(context).translate("cname")
                    : AppLocalizations.of(context).translate("fname"),
                fontColor: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 4),
              child: TextFormField(
                autofocus: true,
                enableInteractiveSelection:  true,
                ///Using this :
                //onEditingComplete: () => FocusScope.of(context).nextFocus(),
                initialValue: user?.name != null && user?.name != "null"
                    ? user?.name
                    : "",
                style: const TextStyle(color: Colors.white),
                onChanged: (val) {
                  txt_fullname_Controller = val;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),

            ///Phone number
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("pno"),
                fontColor: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 4),
              child: TextFormField(
                inputFormatters:  [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                autofocus: true,
                enableInteractiveSelection:  true,
                ///Using this :
                //onEditingComplete: () => FocusScope.of(context).nextFocus(),
                initialValue: user?.phone != null && user?.phone != "null"
                    ? user?.phone
                    : "",
                style: const TextStyle(color: Colors.white),
                onChanged: (val) {
                  txt_Phoneno_Controller = val;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),

            ///Contact person & Date of Birth
            widget.accountType == "1"
                ? Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: CheersClubText(
                      text: AppLocalizations.of(context).translate("cpsn"),
                      fontColor: Colors.white,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: CheersClubText(
                      text: AppLocalizations.of(context).translate("dob"),
                      fontColor: Colors.white,
                    ),
                  ),
            widget.accountType == "1"
                ? Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 4),
                    child: TextFormField(
                      autofocus: true,
                      enableInteractiveSelection:  true,
                      ///Using this :
                      //onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      style: const TextStyle(color: Colors.white),
                      initialValue: user?.contactPerson != null &&
                              user?.contactPerson != "null"
                          ? user?.contactPerson
                          : "",
                      onChanged: (val) {
                        contactperson_controller = val;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                        filled: true,
                        fillColor: HexColor("28292C"),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("28292C")),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("28292C")),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 4),
                    child: TextFormField(
                      autofocus: true,
                      enableInteractiveSelection:  true,
                      ///Using this :
                      //onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      style: const TextStyle(color: Colors.white),
                      initialValue:
                          tempDate == "-0001-11-30 00:00:00.000" ? "" : correct,
                      onChanged: (val) {
                        date_controller = val;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'yyyy-mm-dd',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        filled: true,
                        fillColor: HexColor("28292C"),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("28292C")),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("28292C")),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                  ),

            ///Invoice Address
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("adrs"),
                fontColor: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 4),
              child: TextFormField(
                autofocus: true,
                enableInteractiveSelection:  true,
                ///Using this :
               // onEditingComplete: () => FocusScope.of(context).nextFocus(),
                initialValue: user?.address != null && user?.address != "null"
                    ? user?.address
                    : "",
                style: const TextStyle(color: Colors.white),
                onChanged: (val) {
                  address_controller = val;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),

            ///Zipcode
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("zc"),
                fontColor: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 4),
              child: TextFormField(
                inputFormatters:  [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                autofocus: true,
                enableInteractiveSelection:  true,
                ///Using this :
                //onEditingComplete: () => FocusScope.of(context).nextFocus(),
                style: const TextStyle(color: Colors.white),
                initialValue:
                    user?.zip != null && user?.zip != "null" ? user?.zip : "",
                onChanged: (val) {
                  txt_zip_Controller = val;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),

            ///City
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("cty"),
                fontColor: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 4),
              child: TextFormField(
                autofocus: true,
                enableInteractiveSelection:  true,
                ///Using this :
                //onEditingComplete: () => FocusScope.of(context).nextFocus(),
                style: const TextStyle(color: Colors.white),
                initialValue: user?.city != null && user?.city != "null"
                    ? user?.city
                    : "",
                onChanged: (val) {
                  txt_city_Controller = val;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),

            ///Country
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("cntry"),
                fontColor: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 4),
              child: TextFormField(
                autofocus: true,
                enableInteractiveSelection:  true,
                ///Using this :
                //onEditingComplete: () => FocusScope.of(context).nextFocus(),
                style: const TextStyle(color: Colors.white),
                initialValue: user?.country != null && user?.country != "null"
                    ? user?.country
                    : "",
                onChanged: (val) {
                  txt_Country_Controller = val;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("28292C")),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),

            ///Chamber of Commerce
            widget.accountType == "1"
                ? Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: CheersClubText(
                      text: AppLocalizations.of(context).translate("coc"),
                      fontColor: Colors.white,
                    ),
                  )
                : Container(),
            widget.accountType == "1"
                ? Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 4),
                    child: TextFormField(
                      autofocus: true,
                      enableInteractiveSelection:  true,
                      ///Using this :
                      //onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      style: const TextStyle(color: Colors.white),
                      initialValue: user?.coc != null && user?.coc != "null"
                          ? user?.coc
                          : "",
                      onChanged: (val) {
                        Chamberofcommerce_controller = val;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                        filled: true,
                        fillColor: HexColor("28292C"),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("28292C")),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("28292C")),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                  )
                : Container(),

            ///VAT Number
            widget.accountType == "1"
                ? Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: CheersClubText(
                      text: AppLocalizations.of(context).translate("vatn"),
                      fontColor: Colors.white,
                    ),
                  )
                : Container(),
            widget.accountType == "1"
                ? Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 4),
                    child: TextFormField(
                      autofocus: true,
                      enableInteractiveSelection:  true,
                      ///Using this :
                      // onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      initialValue:
                          user?.vatNumber != null && user?.vatNumber != "null"
                              ? user?.vatNumber
                              : "",
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (val) {
                        vatnumber_controller = val;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                        filled: true,
                        fillColor: HexColor("28292C"),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("28292C")),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("28292C")),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                  )
                : Container(),

            GestureDetector(
              onTap: () async{


                setState(() {
                  _isloading = true;
                });

                dashbordCubit.UserProfileupdate(
                  txt_fullname_Controller != null ? txt_fullname_Controller.toString() : user!.name.toString(),
                  //widget.iscomplted == "false" ? txt_Phoneno_Controller != null ? txt_Phoneno_Controller.toString() : "" :
                    txt_Phoneno_Controller != null ? txt_Phoneno_Controller.toString() : user!.phone.toString(),
                  address_controller != null ? address_controller.toString() : user!.address.toString(),
                  txt_zip_Controller != null ? txt_zip_Controller.toString() : user!.zip.toString(),
                  txt_city_Controller != null ? txt_city_Controller.toString() : user!.city.toString(),
                  txt_Country_Controller != null ? txt_Country_Controller.toString() : user!.country.toString(),
                  date_controller != null ? date_controller.toString() : user!.dob.toString(),
                  contactperson_controller != null ? contactperson_controller.toString() : user!.contactPerson.toString(),
                  Chamberofcommerce_controller != null ? Chamberofcommerce_controller.toString() : user!.coc.toString(),
                  vatnumber_controller != null ? vatnumber_controller.toString() : user!.vatNumber.toString(),
                );

                // String?  userphone = widget.iscomplted == "false"?txt_Phoneno_Controller != null
                //     ? txt_Phoneno_Controller.toString()
                //     : "" :txt_Phoneno_Controller != null
                //     ? txt_Phoneno_Controller.toString()
                //     : user!.phone.toString();
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // prefs.setString('userphone', userphone);


                print("************************PHONE NUMBER API**********  " +  user!.phone.toString());
                print("************************PHONE NUMBER CONTROLLER***  " +  txt_Phoneno_Controller.toString());

                print("************************PHONE DOB API**********  " +  user!.dob.toString());
                print("************************PHONE DOB CONTROLLER***  " +  date_controller.toString());


              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                padding: EdgeInsets.all(10),
                height: 58,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.amber,
                      child: Center(
                        child:  _isloading? Padding(padding: EdgeInsets.all(10.0), child: const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),):CheersClubText(
                          text: AppLocalizations.of(context)
                              .translate('saveprofile'),
                          fontColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 249)
          ],
        ),
      ),
    );
  }

  int pd = 0;
  screensPd(int no) {
    switch (no) {
      case 0:
        return personal();
      case 1:
        return Editprofile();
    }
  }
  var no = 0;
  screens(int no) {
    switch (no) {
      case 0:
        return myoders();
      case 1:
        return mygreetings();
      case 2:
        profileLoding();
        return myprofile();
        break;
    }
  }

  void profileLoding() {
    dashbordCubit.UserProfileloading();
  }

  User? user;

  List<MyGreetings> greetingListdata = [];
  void GreetingsLoading() {
    dashbordCubit.getGreetings();
  }

  List<MyGreetings> OrderListdata = [];
  void OrdersLoading() {
    dashbordCubit.getOrders();
  }

  @override
  void initState() {
    dashbordCubit = DashbordCubit(DashBordRepository());
    // TODO: implement initState
    Notification_Icon();
    OrdersLoading();
    super.initState();
  }

  @override
  void dispose() {
    CurrentPassword_Controller.dispose();
    NewPassword_Controller.dispose();
    ConfirmPassword_Controller.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final timegap = DateTime.now().difference(pre_backpress);

        final cantExit = timegap >= Duration(seconds: 2);

        pre_backpress = DateTime.now();

        if(cantExit){

          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)
                .translate("Press again to exit"),
              backgroundColor: Colors.amber,
              textColor: Colors.black,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 2,
              fontSize: 16.0
          );
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        endDrawer: drowerAfterlogin(),
        resizeToAvoidBottomInset: true,
        key: _key,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                            Container(
                                margin: EdgeInsets.only(right: 10, top: 40),
                                child: Notification_Icon()),
                          ],
                        ),
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

                ///Place an order
                Container(
                  child: Row(
                    children: [
                      Expanded(child: SizedBox()),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 500),
                                type: PageTransitionType.rightToLeft,
                                child: RestourentList(),
                                inheritTheme: true,
                                ctx: context),
                          );
                        },
                        child: Container(
                          height: 40,
                          color: HexColor("FEC753"),
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.only(left: 30, top: 20, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.add_sharp,
                              //   color: Colors.black,
                              //   size: 16,
                              // ),
                              CheersClubText(
                                text: AppLocalizations.of(context)
                                    .translate("BUY A DRINK"),
                                fontColor: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (my_oders) {
                        no = 0;
                        my_greetings = false;
//                      my_oders = false;
                        my_profile = false;
                      } else {
                        no = 0;
                        my_oders = true;
                        my_profile = false;
                        my_greetings = false;
                      }
                    });
                    OrdersLoading();
                    /*
                    Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 1000),
                          type: PageTransitionType.rightToLeft,
                          child: Home(),
                          inheritTheme: true,
                          ctx: context),
                    );
                  */
                  },
                  child: Container(
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          height: 50,
                          color: my_oders ? HexColor("FEC753") : Colors.black,
                          margin: EdgeInsets.only(left: 30, top: 20),
                          child: Center(
                            child: CheersClubText(
                              text: widget.accountType == "1"
                                  ? AppLocalizations.of(context)
                                      .translate("COMPANY ORDERS")
                                  : AppLocalizations.of(context)
                                      .translate('MY ORDERS'),
                              fontColor: my_oders ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (my_greetings) {
                        no = 1;
                        //  my_greetings = false;
                        my_oders = false;
                        my_profile = false;
                      } else {
                        no = 1;
                        my_greetings = true;

                        my_profile = false;
                        my_oders = false;
                      }
                    });
                    GreetingsLoading();
                    /*
                    Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 1000),
                          type: PageTransitionType.rightToLeft,
                          child: Home(),
                          inheritTheme: true,
                          ctx: context),
                    );
                  */
                  },
                  child: Container(
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          height: 50,
                          color: my_greetings
                              ? HexColor("FEC753")
                              : Colors.black,
                          margin: EdgeInsets.only(left: 30, top: 20),
                          child: Center(
                            child: CheersClubText(
                              text: widget.accountType == "1"
                                  ? AppLocalizations.of(context)
                                      .translate("COMPANY GREETINGS")
                                  : AppLocalizations.of(context)
                                      .translate("MY GREETINGS"),
                              fontColor: my_greetings? Colors.black : Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (my_profile) {
                        my_greetings = false;
                        my_oders = false;
                        no = 2;
//                      my_profile = false;

                      } else {
                        no = 2;
                        my_profile = true;
                        my_greetings = false;
                        my_oders = false;
//
                      }
                    });
                    profileLoding();
                    /*
                    Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 1000),
                          type: PageTransitionType.rightToLeft,
                          child: Home(),
                          inheritTheme: true,
                          ctx: context),
                    );
                  */
                  },
                  child: Container(
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          height: 50,
                          color: my_profile
                              ? HexColor("FEC753")
                              : Colors.black,
                          margin: EdgeInsets.only(left: 30, top: 20),
                          child: Center(
                            child: CheersClubText(
                              text: widget.accountType == "1"
                                  ? AppLocalizations.of(context)
                                      .translate("COMPANY PROFILE")
                                  : AppLocalizations.of(context)
                                      .translate("MY PROFILE"),
                              fontColor: my_profile? Colors.black : Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  //            height: 500,
                  child: Expanded(
                    child: BlocProvider(
                      create: (context) => dashbordCubit,
                      child: BlocListener<DashbordCubit, DashbordState>(
                        bloc: dashbordCubit,
                        listener: (context, state) {
                          if (state is DashbordLoading) {
                          } else if (state is DashbordLoadingMyorders) {
                          } else if (state is DashbordMyordersSucssellfull) {
                            OrderListdata = state.ordersListdata;
                          }
                          else if(state is DashbordLoadingMyordersFail){

                            if(state.error.toString()=="Your Login Session Expired") {


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
                                  context, AlertType.error, "Oops!", state.error);
                            }
                          }
                          else if (state is DashbordMyGreetingsLoading) {
                          } else if (state is DashbordMyGreetingsSuccessFull) {
                            greetingListdata = state.ordersListdata;
                          } else if (state is DashbordMyGreetingsFail) {
                            if(state.error.toString()=="Your Login Session Expired") {


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
                                  context, AlertType.error, "Oops!", state.error);
                            }
                          }
                          else if (state is DashbordMyProfileLoading) {
                          } else if (state is DashbordMyProfileSuccessFull) {
                            widget.iscomplted == "false" ? pd = 1 : pd = 0;
                            user = state.user;
                            print("user loadded");
                          }
                           else if (state is DashbordMyProfileFail) {
                            if(state.error.toString()=="Your Login Session Expired") {


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
                                  context, AlertType.error, "Oops!", state.error);
                            }
                          }
                          else if (state is ProfileupdateLoading) {
                          } else if (state is ProfileupdateSuccessFull) {
                            pd = 0;
                            user = state.user;
                            Fluttertoast.showToast(
                              msg:AppLocalizations.of(context)
                                  .translate("Profile update Successfully!"),
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 15.0);

                            setState(() {
                              _isloading=false;

                            });

                          } else if (state is ProfileupdateFail) {
                            Utils.showDialouge(context, AlertType.error,
                                "No data", state.message);

                            setState(() {
                              _isloading=false;

                            });

                          }
                          else if (state is DashbordchangePasswordLoading) {
                          } else if (state is DashbordchangePasswordSuccessFull) {
                            Fluttertoast.showToast(
                                msg:AppLocalizations.of(context)
                                    .translate("Password change successfully!"),
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            setState(() {
                              _isloading2=false;
                            });

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

                            // Navigator.pushReplacement(
                            //   context,
                            //   PageTransition(
                            //       duration: Duration(milliseconds: 1000),
                            //       type: PageTransitionType.rightToLeft,
                            //       child: LoginScreen(),
                            //       inheritTheme: true,
                            //       ctx: context),
                            // );

                          } else if (state is DashbordchangePasswordFail) {
                            Utils.showDialouge(context, AlertType.error,
                                "No data", state.message);

                            setState(() {
                              _isloading2=false;
                            });

                          }
                        },
                        child: BlocBuilder<DashbordCubit, DashbordState>(
                            builder: (context, state) {
                          if (state is DashbordLoadingMyorders) {
                            return Column(
                              children:  [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *0.25,
                                ),
                                const Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 10,
                                  ),
                                ),
                              ],
                            );
                          } else if (state is DashbordMyordersSucssellfull) {
                            return myoders();
                          }
                          else if(state is DashbordLoadingMyordersFail ){
                            return Container();
                          }
                          else if (state is DashbordMyGreetingsLoading) {
                            return Column(
                              children:  [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *0.25,
                                ),
                                const Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 10,
                                  ),
                                ),
                              ],
                            );
                          } else if (state is DashbordMyGreetingsSuccessFull) {
                            return mygreetings();
                          }
                          else if(state is  DashbordMyGreetingsFail){
                            return Container();
                          }
                          else if (state is DashbordMyProfileLoading) {
                            return Column(
                              children:  [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *0.25,
                                ),
                                const Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 10,
                                  ),
                                ),
                              ],
                            );
                          } else if (state is DashbordMyProfileSuccessFull) {
                            return myprofile();
                          }
                           else if (state is DashbordMyProfileFail) {
                            return Container();
                          }
                          else if (state is ProfileupdateLoading) {
                            return Column(
                              children:  [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *0.25,
                                ),
                                const Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 10,
                                  ),
                                ),
                              ],
                            );
                          }
                          else if (state is ProfileupdateSuccessFull) {
                            return myprofile();
                          }
                          else if (state is ProfileupdateFail) {
                            return myprofile();
                          }
                          else if (state is DashbordchangePasswordLoading) {
                            return Column(
                              children:  [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *0.25,
                                ),
                                const Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 10,
                                  ),
                                ),
                              ],
                            );
                          }
                          else if (state is DashbordchangePasswordSuccessFull) {
                            return myprofile();
                          } else if (state is DashbordchangePasswordFail) {
                            return myprofile();
                          }
                          else {
                            return Container(
                            // color: Colors.white,
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class DateUtil {
  String formattedDate(DateTime dateTime) {
    return DateFormat.yMMMEd().format(dateTime);
  }
}

class DateUtil1 {
  String formattedDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
}
