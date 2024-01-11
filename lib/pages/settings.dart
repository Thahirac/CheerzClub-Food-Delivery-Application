import 'dart:convert';
import 'dart:io';

import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/localization/language.dart';
import 'package:cheersclub/localization/language_const.dart';
import 'package:cheersclub/networking/app_exception.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../main.dart';
import 'LoginScreen.dart';
import 'Restourents_list.dart';

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {

  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool value1 = false;
  bool value2 = false;
  String? _chosenValue;
  String? lang;
  var responsee;

  // changeLanguage(String language) {
  //   Locale _temp;
  //   switch (language) {
  //     case 'ENGLISH':
  //       _temp = Locale('en', 'US');
  //       break;
  //     case 'FRENCH':
  //       _temp = Locale('fr', 'FR');
  //       break;
  //     case 'NEDERLANDS':
  //       _temp = Locale('nl','NL');
  //       break;
  //     case 'GERMAN':
  //       _temp = Locale('de','DE');
  //       break;
  //     case 'SPANISH':
  //       _temp = Locale('es','ES');
  //       break;
  //     default:
  //       _temp = Locale('en', 'US');
  //   }
  //   MyApp.setLocale(context, _temp);
  // }
  //
  // languageset(value)async{
  //   SharedPreferences preferences= await SharedPreferences.getInstance();
  //   preferences.setString('Chooselang', value.toString());
  //   //print("*Choose***lang**"+ preferences.getString('Chooselang').toString());
  //   changeLanguage(value);
  // }
  //
  // languageget()async{
  //   SharedPreferences preferences= await SharedPreferences.getInstance();
  //   print("*Choose***lang**"+ preferences.getString('Chooselang').toString());
  //
  //     setState(() {
  //     lang = preferences.getString('Chooselang');
  //     _chosenValue=lang==null?"ENGLISH":lang;
  //     changeLanguage(_chosenValue.toString());
  //   });
  //
  // }


  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //languageget();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: drowerAfterlogin(),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: HexColor("1A1B1D"),
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
                child: Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 30,top: 20),
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
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {


                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => RestourentList(),
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
                        //       child: RestourentList(),
                        //       inheritTheme: true,
                        //       ctx: context),
                        // );
                      },
                      child: Container(
                        height: 40,
                        color: HexColor("FEC753"),
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(left: 30, top: 20, right: 30),
                        child: Row(
                          children: [
                            // Icon(
                            //   Icons.add_sharp,
                            //   size: 16,color: Colors.black,
                            // ),
                            CheersClubText(
                              text: AppLocalizations.of(context).translate("BUY A DRINK"),
                              fontColor: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      color: HexColor("FEC753"),
                      margin: EdgeInsets.only(left: 30, top: 20),
                      child: Center(
                        child: CheersClubText(
                          text: AppLocalizations.of(context).translate('SETTINGS'),
                          fontColor: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20, right: 20),
                child: Row(
                  children: [
                    CheersClubText(
                      text: AppLocalizations.of(context).translate("Allowallpushnotifications"),
                      fontSize: 14,
                      fontColor: Colors.white,
                    ),
                    Expanded(child: SizedBox()),
                    Checkbox(
                      activeColor: HexColor("FEC753"),
                      side: BorderSide(color: Colors.white),
                      checkColor: Colors.white,
                      value: this.value1,
                      onChanged: (bool? value) {
                        setState(() {
                          this.value1 = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 30, right: 20, top: 20),
              //   child: Row(
              //     children: [
              //       CheersClubText(
              //         text:
              //         AppLocalizations.of(context).translate("Makemylocationvisibletomychherzclubfriends"),
              //         fontSize: 14,
              //         fontColor: Colors.white,
              //         alignment: TextAlign.justify,
              //       ),
              //       Expanded(child: SizedBox()),
              //       Checkbox(
              //         activeColor: HexColor("FEC753"),
              //         side: BorderSide(color: Colors.white),
              //         checkColor: Colors.white,
              //         value: this.value2,
              //         onChanged: (bool? value) {
              //           setState(() {
              //             this.value2 = value!;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: GestureDetector(
                  onTap: ()async{
                    await showDialog(
                        builder: (ctxt) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.white70,
                              width: 1),
                          borderRadius:
                          BorderRadius.circular(18),
                        ),

                        title: Text(
                          AppLocalizations.of(context).translate( "Alert"),
                          style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        content: Text( AppLocalizations.of(context).translate("rusywdya"),
                          textAlign: TextAlign.justify,
                        ),
                        //YES or NO action buttons (onTap NO, dialog close and onTapping YES removeing the item)
                        actions: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Text(
                                  AppLocalizations.of(context).translate("n"),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // YES button
                              IconButton(
                                icon: Text(
                                  AppLocalizations.of(context).translate("y"),
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                  onPressed: () async {
                                    try {
                                      var token = await UserManager.instance.getToken();
                                      var userId = await UserManager.instance.getAccountId();

                                      ///development
                                      //var request = http.MultipartRequest('POST', Uri.parse('https://dev.cheerzclub.com/public/api/v1/user/auth/deactivate/1'));


                                      ///live
                                      var request = http.MultipartRequest('PATCH', Uri.parse('https://www.cheerzclub.com/api/v1/user/auth/deactivate/' + userId.toString()));


                                      request.headers.addAll({
                                        'Authorization': 'Bearer $token'
                                      });

                                      http.StreamedResponse response = await request.send();



                                      if (response.statusCode == 200) {
                                        final res = await http.Response
                                            .fromStream(response);
                                        // String? source= res.body.toString();
                                        responsee = jsonDecode(res.body);
                                        String? source = responsee['message'];

                                        source == "Account deactivated"
                                            ? Fluttertoast.showToast(
                                            msg: 'Account deactivated Successfully!',
                                            backgroundColor:
                                            Colors.green,
                                            textColor: Colors.white)
                                            : Fluttertoast.showToast(
                                            msg: source.toString(),
                                            backgroundColor:
                                            Colors.amber,
                                            textColor:
                                            Colors.black);


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


                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Account deactivation failed',
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white);

                                        Navigator.pop(context);

                                        print(response.reasonPhrase);
                                      }
                                    } on SocketException {
                                      Fluttertoast.showToast(
                                          msg: 'No Internet connection',
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          toastLength:
                                          Toast.LENGTH_LONG,
                                          gravity:
                                          ToastGravity.SNACKBAR,
                                          timeInSecForIosWeb: 1,
                                          fontSize: 16.0);
                                    }
                                    throw FetchDataException('No Internet connection');


                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    context: context,
                    );
                  },
                  child: Row(
                    children: [
                      CheersClubText(
                        text: AppLocalizations.of(context).translate("Deactivateorsuspendmyaccount"),
                        fontSize: 14,
                        fontColor: Colors.white,
                        alignment: TextAlign.justify,
                      ),
                      Expanded(child: SizedBox()),
                      Icon(
                        Icons.logout,
                        color: Colors.grey.shade300,
                        size: 22,
                      )
                    ],
                  ),
                ),
              ),


              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Row(
                  children: [
                    CheersClubText(
                      text: AppLocalizations.of(context).translate("Language"),
                      fontSize: 14,
                      fontColor: Colors.white,
                      alignment: TextAlign.justify,
                    ),
                    Expanded(child: SizedBox()),
                    Container(
                      child:  DropdownButton<Language>(
                        dropdownColor: Colors.black,
                        iconEnabledColor: Colors.white,
                        iconSize: 30,
                       hint: CheersClubText(text: AppLocalizations.of(context).translate("change_language"),
                           fontWeight: FontWeight.w500,
                           fontColor:  HexColor("FEC753"),
                           fontSize: 14,
                           over: TextOverflow.ellipsis
                       ),
                        onChanged: (Language? language) {
                          _changeLanguage(language!);
                        },
                        items: Language.languageList()
                            .map<DropdownMenuItem<Language>>(
                              (e) => DropdownMenuItem<Language>(
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // CheersClubText(text: e.flag,
                                //     fontWeight: FontWeight.w500,
                                //     fontColor: Colors.white,
                                //     fontSize: 23,
                                // ),

                                CheersClubText(text: e.name,
                                  fontWeight: FontWeight.w500,
                                  fontColor: Colors.white,
                                  fontSize: 14,
                                ),

                              ],
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),



              // Container(
              //   margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              //   child: Row(
              //     children: [
              //       CheersClubText(
              //         text: AppLocalizations.of(context).translate("Signout"),
              //         fontSize: 14,
              //         fontColor: Colors.white,
              //         alignment: TextAlign.justify,
              //       ),
              //       Expanded(child: SizedBox()),
              //       GestureDetector(
              //         onTap: (){
              //           _key.currentState!.openEndDrawer();
              //         },
              //         child: Icon(
              //           Icons.arrow_forward_ios,
              //           color: Colors.white,
              //           size: 20,
              //         ),
              //       )
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
