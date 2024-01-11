// ignore_for_file: file_names

import 'dart:async';

import 'package:cheersclub/cubit/auth/authentication/auth_cubit.dart';
import 'package:cheersclub/cubit/repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Home.dart';
import 'LoginScreen.dart';
import 'Restourents_list.dart';
import 'dashbord.dart';

class Splash_screen extends StatefulWidget {
  const Splash_screen({Key? key}) : super(key: key);
  @override
  _Splash_screenState createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  final splashDelay = 3;
  late AuthenticationCubit authCubit;

  String? accounttype;

  String? version;
  @override
  void initState() {
    super.initState();
    authCubit = AuthenticationCubit(
        AuthenticationIntial(), UserAuthenticationRepository());
    Timer(Duration(seconds: 3), () {
      authCubit.getAuthenticationState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (context) => authCubit,
          child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
            if (state is Authenticated) {
              accounttype=state.accounttype;
              return dash_bord(accountType: accounttype,);
            } else if (state is UnAuthenticated) {
              return RestourentList();
            } else {
              // package();
              return Splachform();
            }
          })),
    );
  }

  Widget Splachform() {
    return Container(
      //width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: SizedBox()),
          Container(
            width: MediaQuery.of(context).size.width - 30,
            padding: EdgeInsets.all(40),
            child: Image.asset(
              "assets/images/cheerzlogonew.png",
              fit: BoxFit.contain,
            ),
          ),
          Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "",
                style: TextStyle(color: Colors.white, fontSize: 12),
              )
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
