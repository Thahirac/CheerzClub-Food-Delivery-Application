import 'dart:developer';

import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/auth_controller/facebook_login_controller.dart';
import 'package:cheersclub/auth_controller/google_login_controller.dart';
import 'package:cheersclub/auth_controller/instagram_login/instagram_view.dart';
import 'package:cheersclub/cubit/auth/registration/register_cubit.dart';
import 'package:cheersclub/cubit/repository/RegistrationRepository.dart';
import 'package:cheersclub/pages/Home.dart';
import 'package:cheersclub/pages/LoginScreen.dart';
import 'package:cheersclub/pages/dashbord.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'package:cheersclub/networking/app_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart';

import '../localization/app_localization.dart';


class Registration_screen extends StatefulWidget {
  const Registration_screen({Key? key}) : super(key: key);
  @override
  _Registration_screenState createState() => _Registration_screenState();
}

class _Registration_screenState extends State<Registration_screen> {
  var Username_Controller = TextEditingController();
  var Email_Controller = TextEditingController();
  var Password_Controller = TextEditingController();
  var confirm_password_Controller = TextEditingController();
  bool _isloading=false;
  bool _isloading2=false;
  bool _isloading3=false;
  bool _isloading4=false;

  bool _isObscure = true;
  bool _isObscure1 = true;

  int? isCompany;
  bool? isCompleted;


  int? _radioSelected=1;
  int? _radioVal=0;

  GlobalKey<ScaffoldState> __key = GlobalKey();
  GlobalKey<ScaffoldState> _key = GlobalKey();
  late RegisterCubit registerCubit;

  var googleSignIn =  GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  //Map? userDatastoring;

  /// function to implement the google signin
  Future<void> glogin() async{
    try{

      // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
      // final client = await _googleSignIn.signIn();
      //final tokenNew = await client?.authentication;
      //final tokenNew2 = tokenNew?.accessToken;
      //log("***TOKEN******$tokenNew");


      googleAccount = await googleSignIn.signIn();
      final result = await googleAccount?.authentication;
      final accesstokenresult = result?.accessToken;

      if(accesstokenresult != null){
        log("Google login completed!! credentials:");
        log("*ACCESS**TOKEN**GOOGLE***$accesstokenresult");
        SharedPreferences preferences= await SharedPreferences.getInstance();
        preferences.setString('GoogleToken', accesstokenresult.toString());

      }
      else{
        setState(() {
          _isloading2=false;
        });
      }

    } on SocketException {

      Fluttertoast.showToast(
          msg: 'No Internet connection',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);

      setState(() {
        _isloading2=false;
      });

      throw FetchDataException('No Internet connection');
    }catch (e) {

      setState(() {
        _isloading2=false;
      });

      log("********google login login page*********"+e.toString());

    }
  }


  Future<void> flogin(BuildContext context)async {

    try {
      var result = await FacebookAuth.i.login(permissions: ["email","public_profile"]);

      if(result != null){
        if (result.status == LoginStatus.success) {
          //final userData = await FacebookAuth.i.getUserData(fields: "email,name",);
          //userDatastoring = userData;
          log("facebook login completed!! credentials:");
          log("****ACCESS***TOKEN****FACEBOOK***${result.accessToken!.token}");
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('FacebookToken', result.accessToken!.token.toString());
        }

      }else{

        setState(() {
          _isloading3=false;
        });

      }


    }on SocketException {

      setState(() {
        _isloading3=false;
      });

      Fluttertoast.showToast(
          msg: 'No Internet connection',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);


      throw FetchDataException('No Internet connection');
    }catch (e){

      setState(() {
        _isloading3=false;
      });

      log("***********FACEBOOK LOGIN CATCH BUGG **********"+ e.toString());

    }


  }




  @override
  void initState() {
    registerCubit = RegisterCubit(UserRegRepository());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    Username_Controller.dispose();
    Email_Controller.dispose();
    Password_Controller.dispose();
    confirm_password_Controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: __key,
       // endDrawer: drowerBeforlogin(),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocProvider(
              create: (context) => registerCubit,
              child: BlocListener<RegisterCubit, RegisterState>(
                bloc: registerCubit,
                listener: (context, state) {
                  if (state is RegistrationLoading) {}
                  if (state is RegistrationLoginSuccessFull) {

                    // isCompany=state.isCompany;
                    // isCompleted=state.isCompleted;

                    // Fluttertoast.showToast(
                    //     msg: "Registration Successfully!",
                    //     backgroundColor: Colors.green,
                    //     textColor: Colors.white,
                    //     toastLength: Toast.LENGTH_LONG,
                    //     gravity: ToastGravity.SNACKBAR,
                    //     timeInSecForIosWeb: 2,
                    //     fontSize: 16.0
                    // );

                    setState(() {
                      _isloading=false;
                    });


                    Fluttertoast.showToast(
                        msg: state.msge,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.amber,
                        textColor: Colors.black,
                        fontSize: 16.0);

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
                        transitionDuration: Duration(milliseconds: 1000),
                      ),
                    );




                    // Navigator.pushReplacement(
                    //   context,
                    //   PageRouteBuilder(
                    //     pageBuilder: (c, a1, a2) => dash_bord(accountType: isCompany.toString(),iscomplted: isCompleted.toString(),),
                    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    //       var begin = Offset(1.0, 0.0);
                    //       var end = Offset.zero;
                    //       var tween = Tween(begin: begin, end: end);
                    //       var offsetAnimation = animation.drive(tween);
                    //       return SlideTransition(
                    //         position: offsetAnimation,
                    //         child: child,
                    //       );
                    //     },
                    //     transitionDuration: Duration(milliseconds: 500),
                    //   ),
                    // );


                  }
                  else if(state is RegistrationSuccessFull){
                    isCompany=state.isCompany;
                    isCompleted=state.isCompleted;

                    Fluttertoast.showToast(
                        msg:"Registration Successfully!",
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 2,
                        fontSize: 16.0
                    );



                    setState(() {
                      _isloading2=false;
                      _isloading3=false;
                    });



                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => dash_bord(accountType: isCompany.toString(),iscomplted: isCompleted.toString(),),
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


                  }

                  else if (state is RegistrationFailed) {
                    Utils.showDialouge(
                        context, AlertType.error, "Oops!", state.msg);

                    setState(() {
                      _isloading=false;
                      _isloading2=false;
                      _isloading3=false;
                    });
                  }
                },
                child: BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                  return Form(key: _key, child: registraton());
                }),
              )),
        ));
  }

  Widget registraton() {
    return Container(
     // width: MediaQuery.of(context).size.width,
     //height: MediaQuery.of(context).size.height,
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


                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: (){
                    //         __key.currentState?.openEndDrawer();
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
                    // ),


                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, top: 30),
              child: const CheersClubText(
                text: "REGISTER",
                fontColor: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CheersClubText(
                    text: "Already have an account?",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  GestureDetector(
                    child: const CheersClubText(
                      text: " Login",
                      fontColor: Colors.amberAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            duration: Duration(milliseconds: 1000),
                            type: PageTransitionType.rightToLeft,
                            child: LoginScreen(),
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 30,
                top: 20,
              ),
              width: MediaQuery.of(context).size.width - 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CheersClubText(
                    text: "Customer type",
                    fontColor: Colors.amber,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 30, top: 0),
              child:

              Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: Radio(
                        value: 1,
                        groupValue: _radioSelected,
                        activeColor: HexColor("FEC753"),
                        onChanged: (value) {
                          setState(() {
                            _radioSelected = value as int;
                            _radioVal = 0;
                            print(_radioVal);
                          });
                        },
                      ),
                    ),
                    const CheersClubText(
                      text: "Private",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: Radio(
                        value: 2,
                        groupValue: _radioSelected,
                        activeColor: HexColor("FEC753"),
                        onChanged: (value) {
                          setState(() {
                            _radioSelected = value as int;
                            _radioVal = 1;
                            print(_radioVal);
                          });
                        },
                      ),
                    ),
                    const CheersClubText(
                      text: "Business",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),





              // Row(
              //   children: [
              //
              //     Checkbox(
              //       activeColor: HexColor("FEC753"),
              //       side: BorderSide(color: Colors.amber),
              //       checkColor: Colors.white,
              //       value: this.value,
              //       onChanged: (bool? value) {
              //         setState(() {
              //           typeUser = 0;
              //           this.value_bussiness = false;
              //           this.value = value!;
              //         });
              //       },
              //     ),
              //     Container(
              //       margin: EdgeInsets.only(left: 0, top: 0),
              //       child: const CheersClubText(
              //         text: "Private",
              //         fontColor: Colors.white,
              //         fontWeight: FontWeight.w600,
              //         fontSize: 14,
              //       ),
              //     ),
              //     Checkbox(
              //       activeColor: HexColor("FEC753"),
              //       side: BorderSide(color: Colors.amber),
              //       checkColor: Colors.white,
              //       value: this.value_bussiness,
              //       onChanged: (bool? value) {
              //         setState(() {
              //           typeUser = 1;
              //           this.value = false;
              //           this.value_bussiness = value!;
              //           print("**********BUSINESS******"+typeUser.toString());
              //         });
              //       },
              //     ),
              //     Container(
              //       margin: EdgeInsets.only(left: 0, top: 0),
              //       child: const CheersClubText(
              //         text: "Bussiness",
              //         fontColor: Colors.white,
              //         fontWeight: FontWeight.w600,
              //         fontSize: 14,
              //       ),
              //     ),
              //
              //   ],
              // ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: Username_Controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'User Name',
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
                style: TextStyle(color: Colors.white),
                controller: Email_Controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
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


            ///Register button
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

                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(Email_Controller.text)) {


                      Utils.showDialouge(
                          context, AlertType.error, "Oops!", AppLocalizations.of(context).translate('Please enter valid mail id'));

                    }
                    else{
                      setState(() {
                        _isloading = true;
                        _isloading3=false;
                        _isloading2=false;
                      });
                      Register();

                    }




                    // String?  username =Username_Controller.text;
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setString('username', username);

                  }

              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 30, top: 20),
              child: const CheersClubText(
                text: "Or Sign in With",
                fontColor: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),

            /// Google sign
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30,top: 10),
              child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // background
                    onPrimary: Colors.black, // foreground
                  ),
                  child: Container(
                    height: 40,
                    child:  _isloading2? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),),
                      ],
                    ): Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Image.asset(
                            "assets/images/google.png",
                            height: 36,
                            width: 36,
                            fit: BoxFit.contain,
                          ),
                        ),


                        const CheersClubText(
                          text: "Google",
                          fontColor: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),

                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  onPressed: () async{

                    setState(() {
                      _isloading2=true;
                      _isloading=false;
                      _isloading3=false;
                    });

                    await glogin().then((value) =>  googlelogin());
                  }

              ),
            ),
            ///Facebook sign
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30,top: 5),
              child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: HexColor("3A559F"), // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Container(
                    height: 40,
                    child: _isloading3? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),),
                      ],
                    ):  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Image.asset(
                            "assets/images/fb.png",
                            height: 36,
                            width: 36,
                            fit: BoxFit.contain,
                          ),
                        ),


                        const CheersClubText(
                          text: "Facebook",
                          fontColor: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),

                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  onPressed: () async{

                    setState(() {
                      _isloading3=true;
                      _isloading2=false;
                      _isloading=false;
                    });

                   await flogin(context).then((value) => facebooklogin());
                  }

              ),
            ),

            ///Apple sign
            // Padding(
            //   padding: const EdgeInsets.only(left: 30, right: 30,top: 5),
            //   child:  ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         primary: Colors.black, // background
            //         onPrimary: Colors.white, // foreground
            //       ),
            //       child: Container(
            //         height: 40,
            //         child: _isloading4? Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
            //                 height: 18,
            //                 width: 18,
            //                 child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),),
            //           ],
            //         ):Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //
            //             Container(
            //               height: 40,
            //               width: 40,
            //               padding: EdgeInsets.only(
            //                 top: 10,
            //                 bottom: 10,
            //               ),
            //               child: Image.asset(
            //                 "assets/images/applelogo.png",
            //                 color: Colors.white,
            //                 height: 36,
            //                 width: 36,
            //                 fit: BoxFit.contain,
            //               ),
            //             ),
            //
            //
            //             const CheersClubText(
            //               text: "Apple",
            //               fontColor: Colors.white,
            //               fontWeight: FontWeight.w600,
            //               fontSize: 14,
            //             ),
            //
            //             SizedBox(
            //               width: 20,
            //             )
            //           ],
            //         ),
            //       ),
            //       onPressed: () async{
            //
            //         setState(() {
            //           _isloading4=true;
            //         });
            //
            //         //await glogin(context).then((value) => googlelogin());
            //       }
            //
            //   ),
            // ),

            ///Instagram sign
            // Padding(
            //   padding: const EdgeInsets.only(left: 30, right: 30,top: 5),
            //   child:  ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         primary:  HexColor("ED58C0"), // background
            //         onPrimary: Colors.white, // foreground
            //       ),
            //       child: Container(
            //         height: 40,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //
            //             Container(
            //               height: 40,
            //               width: 40,
            //               padding: EdgeInsets.only(
            //                 top: 10,
            //                 bottom: 10,
            //               ),
            //               child: Image.asset(
            //                 "assets/images/insta.png",
            //                 height: 36,
            //                 width: 36,
            //                 fit: BoxFit.contain,
            //               ),
            //             ),
            //
            //
            //             const CheersClubText(
            //               text: "Instagram",
            //               fontColor: Colors.white,
            //               fontWeight: FontWeight.w600,
            //               fontSize: 14,
            //             ),
            //
            //             SizedBox(
            //               width: 20,
            //             )
            //           ],
            //         ),
            //       ),
            //       onPressed: () {
            //         // Navigator.push(context, MaterialPageRoute(builder: (context)=> InstagramView ()));
            //       }
            //
            //   ),
            // ),

            SizedBox(height: 100,),

          ],
        ),
      ),
    );
  }

  void Register() {
    registerCubit.authenticateUser(
        Username_Controller.text,
        Email_Controller.text,
        _radioVal,
        Password_Controller.text,
        confirm_password_Controller.text);
  }


  Future<void> googlelogin() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String? googleaccessToken = preferences.getString('GoogleToken'.toString());
    registerCubit.socialauthenticateUser(
        googleaccessToken, "google");
  }

  Future<void> facebooklogin() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String? facebookaccessToken = preferences.getString('FacebookToken'.toString());
    registerCubit.socialauthenticateUser(
        facebookaccessToken, "facebook");
  }

}
