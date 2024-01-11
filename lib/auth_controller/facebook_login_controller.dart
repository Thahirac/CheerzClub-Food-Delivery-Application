/*
import 'dart:io';

import 'package:cheersclub/networking/app_exception.dart';
import 'package:cheersclub/pages/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacebookSignInController{

  Map? userData;
  String? token1;

  Future<void>  login(BuildContext context)async {

    try {

      var result = await FacebookAuth.i.login(permissions: ["email"]);

      if (result.status == LoginStatus.success) {
        final requesData = await FacebookAuth.i.getUserData(
          fields: "email,name",);
        final token = result.accessToken?.token;

        userData = requesData;

        print("****ACCESS***TOKEN****FACEBOOK***" +
            result.accessToken!.token.toString());


        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
            'FacebookToken', result.accessToken!.token.toString());

        print("*ACCESS**TOKEN***FACEBOOK**2**" +
            preferences.getString('FacebookToken').toString());

        token1 = preferences.getString('FacebookToken');
      }
    }on SocketException {
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
 // logout()async{
 //    await FacebookAuth.i.logOut();
 //    userData =null;
 // }

}



*/
/*

void main() {
  runApp(MyApp());
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  Future<void> _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  void _printCredentials() {
    print(prettyPrint(_accessToken!.toJson()),);
  }

  Future<void> _login() async {
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile

    // loginBehavior is only supported for Android devices, for ios it will be ignored
    // final result = await FacebookAuth.instance.login(
    //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
    //   loginBehavior: LoginBehavior
    //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    // );

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      _printCredentials();
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _userData = userData;
    } else {
      print(result.status);
      print(result.message);
    }

    setState(() {
      _checking = false;
    });
  }


  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Auth Example'),
        ),
        body: _checking
            ? Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ///userdata
                Text(_userData != null ? prettyPrint(_userData!) : "NO LOGGED",),

                SizedBox(height: 80),

                ///acess token
                _accessToken != null ? Text(prettyPrint(_accessToken!.toJson()),) : Container(),

                SizedBox(height: 80),
                CupertinoButton(
                  color: Colors.blue,
                  child: Text(_userData != null ? "LOGOUT" : "LOGIN",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _userData != null ? _logOut : _login,
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


*/

