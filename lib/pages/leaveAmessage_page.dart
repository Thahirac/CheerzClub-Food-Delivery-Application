// ignore_for_file: file_names

import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/contactUs/leaveamsg_cubit.dart';
import 'package:cheersclub/cubit/repository/leaveamessaRepo.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaveAmessage extends StatefulWidget {
  const LeaveAmessage({Key? key}) : super(key: key);

  @override
  _LeaveAmessageState createState() => _LeaveAmessageState();
}

class _LeaveAmessageState extends State<LeaveAmessage> {
  bool _isloading=false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  var name_Controller = TextEditingController();
  var email_Controller = TextEditingController();
  var phone_Controller = TextEditingController();
  var msg_Controller = TextEditingController();

  late LeaveaMsgCubit leaveaMsgcubit;

  @override
  void initState() {
    leaveaMsgcubit = LeaveaMsgCubit(PostleaveaMsg());
    // TODO: implement initStat
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name_Controller.dispose();
    email_Controller.dispose();
    phone_Controller.dispose();
    msg_Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: drowerAfterlogin(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocProvider(
            create: (context) => leaveaMsgcubit,
            child: BlocListener<LeaveaMsgCubit, LeaveaMsgState>(
              bloc: leaveaMsgcubit,
              listener: (context, state) {
                if (state is LeaveamessageInitial) {}
                if (state is LeaveamessageLoading) {

                } else if (state is LeaveamessageSuccess) {

                  Fluttertoast.showToast(
                    msg: AppLocalizations.of(context).translate('Leave a message successfully'),
                      backgroundColor: Colors.green,
                      textColor: Colors.white);

                  setState(() {
                    _isloading=false;
                  });

                  name_Controller.clear();
                  email_Controller.clear();
                  phone_Controller.clear();
                  msg_Controller.clear();

                } else if (state is LeaveamessageFail) {
                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.error);

                  setState(() {
                    _isloading=false;
                  });
                }
              },
              child: BlocBuilder<LeaveaMsgCubit, LeaveaMsgState>(
                  builder: (context, state) {
                    if (state is LeaveamessageInitial) {
                      return leaveamsgform();
                    }
                    if (state is LeaveamessageLoading) {
                      return leaveamsgform();
                    }  else if (state is LeaveamessageSuccess) {
                      return  leaveamsgform();
                    } else if (state is LeaveamessageFail) {
                      return  leaveamsgform();
                    } else {
                      return  leaveamsgform();
                    }
                  }),
            )),
      ),

    );
  }
  Widget leaveamsgform(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 1.2,
      color: HexColor("1A1B1D"),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
              margin: EdgeInsets.only(left: 20, top: 25,bottom: 10),
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
                  child: const Center(
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
                  text: AppLocalizations.of(context).translate('leaveamessage'),
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ],
            ),

            //Full name
            Container(
              margin: EdgeInsets.only(left: 20, right: 220, top: 30),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate('fname'),
                fontColor: Colors.white,
                fontSize: 11.5,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller:  name_Controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).translate('eyn'),
                  hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
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

            //Email
            Container(
              margin: EdgeInsets.only(left: 20, right: 220, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate('eml'),
                fontColor: Colors.white,
                fontSize: 11.5,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextField(
                keyboardType:
                TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                controller: email_Controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).translate('eym'),
                  hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
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

            //Phone
            Container(
              margin: EdgeInsets.only(left: 20, right: 220, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate('pno'),
                fontColor: Colors.white,
                fontSize: 11.5,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                controller:  phone_Controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).translate('eyp'),
                  hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
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

            //Message

            Container(
              margin: EdgeInsets.only(left: 20, right: 220, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate('m'),
                fontColor: Colors.white,
                fontSize: 11.5,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 4),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: msg_Controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).translate('lymh'),
                  hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
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






            //Send Button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 220, top: 20, bottom: 30),
              child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0)),
                    primary: HexColor("FEC753"), // background
                    onPrimary: Colors.black, // foreground
                  ),
                  child: Container(
                    height: 45,
                    width: 130,
                    child:  Center(
                      child: _isloading ?  const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),) :  CheersClubText(
                        text:  AppLocalizations.of(context).translate('send'),
                        fontColor: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  onPressed: () {

                    if (name_Controller.text.isEmpty) {

                      Utils.showDialouge(
                          context, AlertType.error, "Oops!", AppLocalizations.of(context).translate('Please enter your name'),);


                    } else if (email_Controller.text.isEmpty) {


                      Utils.showDialouge(
                        context, AlertType.error, "Oops!", AppLocalizations.of(context).translate('Please enter your mail id'),);

                    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email_Controller.text)) {


                      Utils.showDialouge(
                        context, AlertType.error, "Oops!", AppLocalizations.of(context).translate('Please enter valid mail id'));
                    } else if (phone_Controller.text.isEmpty) {

                      Utils.showDialouge(
                        context, AlertType.error, "Oops!", AppLocalizations.of(context).translate('Please enter your phone number'),);

                    } else if (msg_Controller.text.isEmpty) {

                      Utils.showDialouge(
                        context, AlertType.error, "Oops!", AppLocalizations.of(context).translate('Please enter your message'),);

                    } else if (msg_Controller.text.length < 6) {

                      Utils.showDialouge(
                        context, AlertType.error, "Oops!", AppLocalizations.of(context).translate('Please explain your message'));

                    }
                    else{

                      setState(() {
                        _isloading = true;
                      });

                      leaveaMsgcubit.leaveamessage(name_Controller.text, email_Controller.text, phone_Controller.text, msg_Controller.text);

                    }


                  }

              ),
            ),





            Container(
              // color: HexColor("5D5D5E"),
              height: MediaQuery.of(context).size.height * 0.3,
              padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(top: 0, bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Row(
                    children: const [
                      CheersClubText(
                        text: "Oerkapkade 1b,",
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      CheersClubText(
                        text: "2031 EN Haarlem",
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ],
                  ),

                  Row(
                    children: const [
                      CheersClubText(
                        text: "Netherlands",
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ],
                  ),

                  SizedBox(height: 15,),

                  Row(
                    children: const [
                      CheersClubText(
                        text: "P: +31-654900233 | E: info@cheerzclub.com",
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ],
                  ),

                  Row(
                    children: const [
                      CheersClubText(
                        text: "WWW.cheerzclub.com",
                        fontColor: Colors.amber,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),


                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}
