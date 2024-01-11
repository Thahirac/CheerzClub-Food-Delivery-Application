// ignore_for_file: file_names

import 'dart:developer';
import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/auth/login/login_cubit.dart';
import 'package:cheersclub/cubit/repository/LoginRepository.dart';
import 'package:cheersclub/pages/dashbord.dart';
import 'package:cheersclub/pages/registration_screen.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
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
import '../localization/app_localization.dart';
import 'forgetPassword.dart';
import 'dart:io';
import 'package:cheersclub/networking/app_exception.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
//import 'package:googleapis/people/v1.dart';
//import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';

    // final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '[YOUR_OAUTH_2_CLIENT_ID]',
    //   scopes: <String>[PeopleServiceApi.contactsReadonlyScope],
    // );

class LoginScreen extends StatefulWidget {
  // final String? token;
  const LoginScreen({Key? key,}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  DateTime pre_backpress = DateTime.now();
  bool _isloading=false;
  bool _isloading2=false;
  bool _isloading3=false;
  bool _isloading4=false;
  var email_Controller = TextEditingController();
  var Password_Controller = TextEditingController();
  String? _password = "";
  String? _username = "";
  bool _isObscure = true;
  bool value = false;
  GlobalKey<ScaffoldState>? _key = GlobalKey();
  late LoginCubit loginCubit;
  int? isCompany;
  bool? isCompleted;

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

      setState(() {
        _isloading2=false;
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
    }catch (e) {

      setState(() {
        _isloading2=false;
      });

      log("********google login login page*********"+e.toString());

    }
  }

  /// function to implement the google signin (Firebase direct)
  //late FirebaseAuth _auth;
  // Future<void> glogin() async {
  //
  //   try{
  //
  //     final GoogleSignIn googleSignIn = GoogleSignIn();
  //     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;
  //       final AuthCredential authCredential = GoogleAuthProvider.credential(
  //           idToken: googleSignInAuthentication.idToken,
  //           accessToken: googleSignInAuthentication.accessToken);
  //
  //       // Getting users credential
  //       UserCredential result = await _auth.signInWithCredential(authCredential);
  //       final accesstokenresult = result.credential?.accessToken;
  //
  //       if (accesstokenresult != null) {
  //
  //         log("*ACCESS**TOKEN**GOOGLE***$accesstokenresult");
  //         SharedPreferences preferences= await SharedPreferences.getInstance();
  //         preferences.setString('GoogleToken', accesstokenresult.toString());
  //         log("*ACCESS**TOKEN**GOOGLE**2*****${preferences.getString('GoogleToken')}");
  //
  //       }
  //       else{
  //         setState(() {
  //           _isloading2=false;
  //         });
  //       }// if result not null we simply call the MaterialpageRoute,
  //       // for go to the HomePage screen
  //     }   else{
  //       setState(() {
  //         _isloading2=false;
  //       });
  //     }
  //
  //   }on SocketException {
  //
  //     setState(() {
  //       _isloading2=false;
  //     });
  //
  //     Fluttertoast.showToast(
  //         msg: 'No Internet connection',
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.SNACKBAR,
  //         timeInSecForIosWeb: 1,
  //         fontSize: 16.0);
  //
  //     print('No net');
  //     throw FetchDataException('No Internet connection');
  //   }catch (e) {
  //
  //     setState(() {
  //       _isloading2=false;
  //     });
  //
  //     log("********google login login page*********"+e.toString());
  //
  //   }
  //
  //
  //
  //
  //
  // }

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

  //Implementation details of signin with apple
  Future<void>  loginWithApple(BuildContext context)async {

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      log("Apple login completed!! credentials:");
      log("****ACCESS***TOKEN****APPLE***${credential.identityToken.toString()}");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('AppleToken', credential.identityToken.toString());

    }on SocketException {

      setState(() {
        _isloading4=false;
      });

      Fluttertoast.showToast(
          msg: 'No Internet connection',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);

      print('No net');
      throw FetchDataException('No Internet connection');
    }
  }


  




  @override
  void initState() {
    // TODO: implement initState

    /// initializing the firebase app
    // Firebase.initializeApp().whenComplete(() {
    //   _auth = FirebaseAuth.instance;
    // });

    loginCubit = LoginCubit(UserLoginRepository());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email_Controller.dispose();
    Password_Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (pre_backpress== null ||
              DateTime.now().difference(pre_backpress).inSeconds > 1) {
            print('Press again Back Button exit');
            Fluttertoast.showToast(
                msg: "Press again to exit",
                backgroundColor: Colors.amber,
                textColor: Colors.black,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 2,
                fontSize: 16.0
            );
            pre_backpress = DateTime.now();
            return false;
          } else {
            print('sign out');
            //Navigator.of(context).pop(true);
            return true;
          }
        },

      // onWillPop: () async{
      //   final timegap = DateTime.now().difference(pre_backpress);
      //
      //   final cantExit = timegap >= Duration(seconds: 2);
      //
      //   pre_backpress = DateTime.now();
      //
      //   if(cantExit){
      //
      //     Fluttertoast.showToast(
      //         msg: "Press again to exit",
      //         backgroundColor: Colors.amber,
      //         textColor: Colors.black,
      //         toastLength: Toast.LENGTH_LONG,
      //         gravity: ToastGravity.SNACKBAR,
      //         timeInSecForIosWeb: 2,
      //         fontSize: 16.0
      //     );
      //     return false;
      //   }else{
      //     return true;
      //   }
      // },
      child: Scaffold(
        key: _key,
        //endDrawer: drowerBeforlogin(),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocProvider(
              create: (context) => loginCubit,
              child: BlocListener<LoginCubit, LoginState>(
                bloc: loginCubit,
                listener: (context, state) {
                  if (state is LoginLoading) {}
                  if (state is LoginSuccessFull) {
                    isCompany=state.isCompany;
                    isCompleted=state.isCompleted;

                    Fluttertoast.showToast(
                        msg: "Login Successfully!",
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 2,
                        fontSize: 16.0
                    );

                    setState(() {
                      _isloading=false;
                      _isloading2=false;
                      _isloading3=false;
                    });


                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => dash_bord(accountType: isCompany.toString(),iscomplted: isCompleted.toString(),),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var tween = Tween(begin: begin, end: end);
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );



                  } else if (state is LoginFailed) {
                    Utils.showDialouge(
                        context, AlertType.error, "Oops!", state.msg);

                    setState(() {
                      _isloading=false;
                      _isloading2=false;
                      _isloading3=false;
                    });
                  }
                },
                child:
                    BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
                  return loginform();
                }),
              )),
        ),
      ),
    );
  }

  Widget loginform() {
    return Container(
      // width: MediaQuery.of(context).size.width,
       height: MediaQuery.of(context).size.height,
      color: HexColor("1A1B1D"),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                      margin: const EdgeInsets.only(left: 13, top: 25),
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        "assets/images/cheerzlogonew.png",
                        fit: BoxFit.fitHeight,
                        height: 55,
                        //width: 220,
                      ),
                    ),
                    const Expanded(child: SizedBox()),

                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         _key!.currentState?.openEndDrawer();
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
              margin: const EdgeInsets.only(left: 30, top: 30),
              child: const CheersClubText(
                text: "Login",
                fontColor: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CheersClubText(
                    text: "New user?",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  InkWell(
                    focusColor: Colors.white,
                    child: const CheersClubText(
                      text: " Create an account",
                      fontColor: Colors.amberAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    onTap: () {


                      Navigator.push(
                        context,
                        PageTransition(
                            duration: const Duration(milliseconds: 1000),
                            type: PageTransitionType.rightToLeft,
                            child: const Registration_screen(),
                            inheritTheme: true,
                            ctx: context),
                      );

                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextField(
                controller: email_Controller,
                onChanged: (val) {
                  _username = val;
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'E-mail',
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
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
              margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextField(
                controller: Password_Controller,
                obscureText: _isObscure,
                onChanged: (VAL) {
                  setState(() {
                    _password = VAL;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ?Icons.visibility_off : Icons.visibility  ,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      }),
                  border: InputBorder.none,
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 0.0, top: 8.0),
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
              margin: const EdgeInsets.only(left: 20, right: 30, top: 20),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: HexColor("FEC753"),
                    side: const BorderSide(color: Colors.white),
                    checkColor: Colors.white,
                    value: this.value,
                    onChanged: (bool? value) {
                      setState(() {
                        this.value = value!;
                      });
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 0, top: 0),
                    child: const CheersClubText(
                      text: "Remember Login",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            ///Login button
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30,top: 20),
              child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: HexColor("FEC753"), // background
                    onPrimary: Colors.black, // foreground
                  ),
                  child: Container(
                    height: 40,
                    child:  Center(
                      child:   _isloading? const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),):const CheersClubText(
                        text: "Continue",
                        fontColor: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  onPressed: () {

                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email_Controller.text)) {


                      Utils.showDialouge(
                          context, AlertType.error, "Oops!", AppLocalizations.of(context).translate('Please enter valid mail id'));

                    }
                    else{
                      setState(() {
                        _isloading = true;
                        _isloading3=false;
                        _isloading2=false;
                      });
                      signin();

                    }

                  }

              ),
            ),

            /// Forgot password
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      duration: const Duration(milliseconds: 1000),
                      type: PageTransitionType.rightToLeft,
                      child: const forgetPassword(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      //color: HexColor("FEC753"),
                      margin: const EdgeInsets.only(left: 30, top: 10),
                      child: const Center(
                        child: CheersClubText(
                          text: "Forgot Password",
                          fontColor: Colors.amber,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ///Or login with
            Container(
              margin: const EdgeInsets.only(left: 30, top: 20),
              child: const CheersClubText(
                text: "Or Login With",
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
                    child: _isloading2? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),),
                      ],
                    ):Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.only(
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

                        const SizedBox(
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

                    await glogin().then((value) => googlelogin());
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
                    ): Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.only(
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

                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  onPressed: ()async {

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
            //         await loginWithApple(context).then((value) => applelogin());
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
            //         //Navigator.push(context, MaterialPageRoute(builder: (context)=> InstagramView ()));
            //       }
            //
            //   ),
            // ),





         // SizedBox(height: 100,),


            ///Skip
            // Padding(
            //   padding: const EdgeInsets.only(right: 30,top: 10),
            //   child: InkWell(
            //     splashColor: Colors.amber,
            //     onTap: (){
            //       Navigator.pushReplacement(
            //         context,
            //         PageRouteBuilder(
            //           pageBuilder: (c, a1, a2) => dash_bord(),
            //           transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //             var begin = Offset(1.0, 0.0);
            //             var end = Offset.zero;
            //             var tween = Tween(begin: begin, end: end);
            //             var offsetAnimation = animation.drive(tween);
            //             return SlideTransition(
            //               position: offsetAnimation,
            //               child: child,
            //             );
            //           },
            //           transitionDuration: Duration(milliseconds: 500),
            //         ),
            //       );
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: const [
            //         Text(
            //          "Skip",
            //           style: TextStyle(
            //             decoration: TextDecoration.underline,
            //               color: Colors.white,fontSize: 16,fontFamily: "Raleway",
            //           ),
            //         ),
            //     ],
            //     ),
            //   ),
            // ),



          ],
        ),
      ),
    );

  }

  void signin() {
    loginCubit.authenticateUser(
        email_Controller.text, Password_Controller.text);
  }

  Future<void> googlelogin() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String? googleaccessToken = preferences.getString('GoogleToken'.toString());
    loginCubit.socialauthenticateUser(
        googleaccessToken, "google");
  }

  Future<void> facebooklogin() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String? facebookaccessToken = preferences.getString('FacebookToken'.toString());
    loginCubit.socialauthenticateUser(
        facebookaccessToken, "facebook");
  }

  Future<void> applelogin() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    String? appleToken = preferences.getString('AppleToken'.toString());
    loginCubit.socialauthenticateUser(
        appleToken, "apple");
  }

  // void instagramlogin() {
  //   loginCubit.socialauthenticateUser(
  //       widget.token, "instagram");
  // }

}
