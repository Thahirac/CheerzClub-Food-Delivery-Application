/*
// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:cheersclub/networking/app_exception.dart';
import 'package:cheersclub/pages/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GoogleSignInController{

  var _googleSignIn =  GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  String? token;

  Future<void> login(BuildContext context) async{

    try{
      this.googleAccount = await _googleSignIn.signIn();

      final result = await this.googleAccount?.authentication;

      print(result?.idToken);
      print("*ACCESS**TOKEN**GOOGLE*"+result!.accessToken.toString());
      SharedPreferences preferences= await SharedPreferences.getInstance();
      preferences.setString('GoogleToken', result.accessToken.toString());
      print("*ACCESS**TOKEN**GOOGLE**2**"+ preferences.getString('GoogleToken').toString());
      token = preferences.getString('GoogleToken');

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

      print('No net');
      throw FetchDataException('No Internet connection');
    }

  }

  // logOut() async{
  //   this.googleAccount = await _googleSignIn.signOut();
  // }

}
*/
