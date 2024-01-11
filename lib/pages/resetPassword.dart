// ignore_for_file: file_names

import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/auth/forgetPassword/forget_pass_word_cubit.dart';
import 'package:cheersclub/cubit/repository/forgotPassRepo.dart';
import 'package:cheersclub/pages/LoginScreen.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

class ResetPassword extends StatefulWidget {
  final String? email;
  const ResetPassword({Key? key,this.email}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<ScaffoldState>? _key = GlobalKey();

  var token_Controller = TextEditingController();
  var Password_Controller = TextEditingController();
  var confirm_password_Controller = TextEditingController();

  bool _isObscure = true;
  bool _isObscure1 = true;
  bool _isloading=false;

  String? _email;
  late ForgetPassWordCubit loginCubit;

  void initState() {
    // TODO: implement initState
    loginCubit = ForgetPassWordCubit(ForgetPassRe());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      Container(
        // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
            color: HexColor("1A1B1D"),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30))),
        child: Expanded(
          child: ListView(
            children: [
              Container(
                height: 120,
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
                          "assets/images/logo.png",
                          fit: BoxFit.fitHeight,
                          height: 45,
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
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 6),
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: Colors.amber, width: 2)),
                              margin: EdgeInsets.only(right: 20, top: 40),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.amber,
                                  size: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    CheersClubText(
                      text: "HOME",
                      fontColor: Colors.white,
                      fontSize: 18,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 70,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 70,
                        color: HexColor("FEC753"),
                        margin: EdgeInsets.only(
                            left: 30, top: 15, bottom: 15, right: 30),
                        child: Center(
                          child: const CheersClubText(
                            text: "Login",
                            fontColor: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    CheersClubText(
                      text: "NEW USER",
                      fontColor: Colors.white,
                      fontSize: 18,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    CheersClubText(
                      text: "PLACE AN ORDER",
                      fontColor: Colors.white,
                      fontSize: 18,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    CheersClubText(
                      text: "TERMS AND CONDITIONS",
                      fontColor: Colors.white,
                      fontSize: 18,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    CheersClubText(
                      text: "PRIVACY STATEMENTS",
                      fontColor: Colors.white,
                      fontSize: 18,
                    )
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      CheersClubText(
                        text: "SETTINGS",
                        fontColor: Colors.white,
                        fontSize: 18,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 1000),
                        type: PageTransitionType.rightToLeft,
                        child: settings(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    CheersClubText(
                      text: "FAQ",
                      fontColor: Colors.white,
                      fontSize: 18,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    CheersClubText(
                      text: "CONATACT US",
                      fontColor: Colors.white,
                      fontSize: 18,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
      */

      key: _key,
      // endDrawer: drowerBeforlogin(),
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
          create: (context) => loginCubit,
          child: BlocListener<ForgetPassWordCubit, ForgetPassWordState>(
            bloc: loginCubit,
            listener: (context, state) {
              if (state is ResetPasswordLoading) {}
              if (state is ResetPasswordSuccessFull) {



                Fluttertoast.showToast(
                    msg: "Password change successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);


                setState(() {
                  _isloading=false;
                });

                // Navigator.pushReplacement(
                //   context,
                //   PageTransition(
                //       duration: Duration(milliseconds: 1000),
                //       type: PageTransitionType.leftToRight,
                //       child: LoginScreen(),
                //       inheritTheme: true,
                //       ctx: context),
                // );

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


              } else if (state is ResetPasswordFailed) {

                Utils.showDialouge(
                    context, AlertType.error, "Oops!", state.msg);

                setState(() {
                  _isloading=false;
                });
              }
            },
            child: BlocBuilder<ForgetPassWordCubit, ForgetPassWordState>(
                builder: (context, state) {
                  return resetform();
                }),
          )),
    );
  }

  Widget resetform() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: HexColor("1A1B1D"),
      child: SingleChildScrollView(
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
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         _key!.currentState!.openEndDrawer();
                      //         //Scaffold.of(context).openDrawer();
                      //       },
                      //       child: Container(
                      //         margin: EdgeInsets.only(right: 20, top: 40),
                      //         child: Image.asset(
                      //           "assets/images/nav.png",
                      //           height: 20,
                      //           width: 20,
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 30),
                child: const CheersClubText(
                  text: "Reset Password",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: TextFormField(
                 initialValue: widget.email.toString(),
                  onChanged: (val) {
                    _email = val;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'E-mail',
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
              ),

              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: TextField(
                  controller: token_Controller,
                  // onChanged: (val) {
                  //   _username = val;
                  // },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Token',
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
              ),

              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: TextField(
                  controller: Password_Controller,
                  obscureText: _isObscure,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                    border: InputBorder.none,
                    hintText: 'Password',
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
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: TextField(
                  controller: confirm_password_Controller,
                  obscureText: _isObscure1,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure1 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure1 = !_isObscure1;
                          });
                        }),
                    border: InputBorder.none,
                    hintText: 'Confirm password',
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
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30,top: 20),
                child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: HexColor("FEC753"), // background
                      onPrimary: Colors.black, // foreground
                    ),
                    child: Container(
                      height: 40,
                      child: Center(
                        child:  _isloading? const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),): const CheersClubText(
                          text: "Continue",
                          fontColor: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onPressed: () {

                      setState(() {
                        _isloading=true;
                      });

                      reset();
                    }

                ),
              ),



              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.53,
              // ),
              //
              // InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.only(left: 6),
              //     height: 24,
              //     width: 24,
              //     decoration: BoxDecoration(
              //         color: Colors.black,
              //         borderRadius: BorderRadius.circular(24),
              //         border: Border.all(color: Colors.amber, width: 2)),
              //     margin: EdgeInsets.only(left: 30, right: 30,top: 20),
              //     child: Center(
              //       child: Icon(
              //         Icons.arrow_back_ios,
              //         color: Colors.amber,
              //         size: 12,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 30,
              // ),




            ],
          ),
        ),
      ),
    );
  }

  void reset() {
    loginCubit.ResetPass(_email==null?widget.email:_email.toString(),token_Controller.text,Password_Controller.text,confirm_password_Controller .text);
  }
}
