import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/models/Contact/appContact_class.dart';
import 'package:cheersclub/networking/app_exception.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'LoginScreen.dart';
import 'Restourents_list.dart';
class InviteContact extends StatefulWidget {
  const InviteContact({Key? key}) : super(key: key);

  @override
  State<InviteContact> createState() => _InviteContactState();
}

class _InviteContactState extends State<InviteContact> {




  var responsee;
  bool isloading =true;
  bool? _ispermision;
  String? _dialCode="";
  List<dynamic> _availableAlllUsers=[];
  List<dynamic> _availabFoundUsers=[];
  List<dynamic> _unavailableAlllUsers=[];
  List<dynamic> _unavailabFoundUsers=[];
  List<Map<String, String>> cnts = [];
  var searchController = new TextEditingController();
  List<dynamic>availableresult=[];
  List<dynamic>unavailableresult=[];


  Future<void> getPermissions() async {
    isloading =true;
    final status = await Permission.contacts.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        _ispermision=true;
      });
      print('Permission granted');
      getAllContacts();
    } else if (status == PermissionStatus.denied) {
      setState(() {
        _ispermision=false;
      });
      print('Permission denied. Show a dialog and again ask for the permission');

      Utils.showDialouge(
        context, AlertType.warning, "Warning!",AppLocalizations.of(context).translate('Permission denied,please allow your contact access'),);

    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');

      Utils.showDialouge(
        context, AlertType.warning, "Warning!",AppLocalizations.of(context).translate('Permission denied,please allow your contact access'),);

      await openAppSettings();
    }
  }

  getAllContacts() async {

    try {
      await CountryCodes.init(); // Optionally, you may provide a `Locale` to get countrie's localizadName
      final CountryDetails details = CountryCodes.detailsForLocale();
      setState(() {
        _dialCode = details.dialCode.toString();
        print("************COUNTRY:"+  _dialCode.toString()); // Displays the dial code, for example +1.
      });

      List<AppContact> _contacts = (await ContactsService.getContacts()).map((contact) {
        return AppContact(
          info: contact,
        );
      }).toList();



      for (var i = 0; i < _contacts.length; i++) {
        print(_contacts[i].info!.prefix);
        if(_contacts[i].info!.displayName !="null" &&_contacts[i].info!.phones!.isNotEmpty) {
          cnts.add({
            'name': '${_contacts[i].info?.displayName}',
            'phone': '${_contacts[i].info!.phones!.elementAt(0).value}'
          });
        }
      }


      getData();
    } on HttpException catch (e) {
      print(e);
    } on FormatException catch (e) {
      print(e);
    }
    catch(e){
      print(e);
    };
  }


  Future<void> getData() async {
    isloading =true;

    try {

      var body = {"contacts": cnts};
      print("body:"+jsonEncode(body));
      var token = await UserManager.instance.getToken();
      ///development
      //var request = http.Request('POST',Uri.parse('https://dev.cheerzclub.com/public/api/v1/user/sync-contacts'));
      var header = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      ///live
      var request = await http.post(Uri.parse('https://www.cheerzclub.com/api/v1/user/sync-contacts'),headers: header,body: jsonEncode(body));

      if(request.statusCode == 200){
        setState(() {
          isloading =false;


          Map<String, dynamic> r =jsonDecode(request.body);


          if(r["message"]=="Your Login Session Expired"){


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

          }




          List<dynamic> availablelist=r['data']['available'];
          List<dynamic> unavailablelist=r['data']['unavailable'];
          log(availablelist.toString());
          log(unavailablelist.toString());

          _availableAlllUsers =availablelist;
          _availabFoundUsers =availablelist;


          _unavailableAlllUsers =unavailablelist;
          _unavailabFoundUsers =unavailablelist;

          print("body&&&&&&&&&&&&&&&&"+request.body.toString());

        });

      }else{
        print("response"+request.body);
      }


    } catch (e) {
      log(e.toString());
    }
  }

  void _runFilter(String enteredKeyword) {

    if(enteredKeyword.isEmpty){
      availableresult =_availableAlllUsers;
      unavailableresult =_unavailableAlllUsers;

    }else{
      availableresult =_availableAlllUsers.where((user) => user['name'].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

      unavailableresult =_unavailableAlllUsers.where((user) => user['name'].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

    }
    setState(() {
      _availabFoundUsers = availableresult;
    log(_availabFoundUsers.toString());

    _unavailabFoundUsers = unavailableresult;
    log(_unavailabFoundUsers.toString());

  });


  }



  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  HexColor("1A1B1D"),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.only(left: 6),
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2)),
            margin: EdgeInsets.only(right: 15, top: 25, bottom: 20, left: 16),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ),
        title: Container(
          child: CheersClubText(
            text: AppLocalizations.of(context).translate('myfs'),
            fontColor: Colors.white,
            fontSize: 16,
          ),
        ),
      ),

      body:

      isloading==true?
      Container(
        color: HexColor("1A1B1D"),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: CupertinoActivityIndicator(
            radius: 10,
          ),
        ),
      ):



      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // color: HexColor("1A1B1D"),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: EdgeInsets.only(left: 7, right: 7, top: 7),
                // padding: EdgeInsets.only(top: 18),
                child: TextField(
                  controller:searchController , onChanged: (val) =>_runFilter(val),
                  cursorColor: Colors.amber,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    // suffixIcon: Padding(
                    //   padding: const EdgeInsets.only(top: 15,right: 6),
                    //   child: CheersClubText(
                    //     text: "Cancel",fontColor: Colors.white,
                    //     fontSize: 15,
                    //   ),
                    // ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: HexColor("59595B"),
                    ),
                    border: InputBorder.none,
                    //floatingLabelBehavior: true,
                    hintText: AppLocalizations.of(context).translate('Search'),
                    hintStyle: TextStyle(color: Colors.grey.shade600,fontSize: 18,),
                    filled: true,
                    fillColor: HexColor("28292C"),
                    suffixIcon: searchController.text.length>0?InkWell(
                        onTap: (){
                          setState(() {
                            searchController.clear();
                            _runFilter(searchController.text);
                            FocusScope.of(context).requestFocus( FocusNode());
                          });
                        },
                        child: SizedBox(
                            width: 8,
                            height: 8,
                            child: Stack(
                              alignment: Alignment(0.0, 0.0), // all centered
                              children: <Widget>[
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: Colors.grey.shade800),
                                ),
                                Icon(Icons.close_rounded, size:  16, color: Colors.grey.shade400,// 60% width for icon
                                )
                              ],
                            ))):null,

                    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 0.0, top: 16.0),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("28292C")),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: HexColor("28292C")),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              _availabFoundUsers.length == 0
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 220, top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheersClubText(
                      text: AppLocalizations.of(context).translate('Friends'),
                      fontColor: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
              ),

              ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount:  _availabFoundUsers.length,
                  itemBuilder: (context, index) {

                    print("dddddddddddddddddddddd"+_dialCode.toString());

                    String numberview({required String number}){
                      if(number.contains("+") ||number.length >11 ){
                        return number;
                      }else{
                        return _dialCode.toString()+number.toString();
                      }
                    }


                    return  Padding(
                      padding: const EdgeInsets.only(
                          left: 7, right: 7, top: 5),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {},
                            leading: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                CheersClubText(
                                  text:  _availabFoundUsers[index]['name']??"",
                                  fontColor: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                CheersClubText(
                                  text:  numberview(number: '${ _availabFoundUsers[index]['phone']}'),
                                  fontColor: Colors.white,
                                  fontSize: 15,
                                ),
                              ],
                            ),
                            trailing: Padding(
                              padding:
                              const EdgeInsets.only(left: 2),
                              child: Container(
                                width: 80,
                                child: InkWell(
                                  borderRadius:
                                  BorderRadius.circular(6),
                                  splashColor: Colors.grey[50],
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.amber,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(6),
                                    ),
                                    child:  CheersClubText(
                                      text: AppLocalizations.of(context).translate('BUY A DRINK'),
                                      fontColor: Colors.amber,
                                      fontSize: 7,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(
                                              milliseconds: 500),
                                          type: PageTransitionType
                                              .rightToLeft,
                                          child: RestourentList(),
                                          inheritTheme: true,
                                          ctx: context),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade700,
                            height: 13,
                            thickness: 0.3,
                          ),
                        ],
                      ),
                    );
                  }),

              _unavailabFoundUsers.length == 0
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheersClubText(
                      text: AppLocalizations.of(context).translate('Invite from Contact').toString().toUpperCase(),
                      fontColor: Colors.amber,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
              ),
              _availabFoundUsers.isNotEmpty ||  _unavailabFoundUsers.isNotEmpty?
              ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount:  _unavailabFoundUsers.length,
                  itemBuilder: (context, index) {

                    String numberview({required String number}){
                      if(number.contains("+") ||number.length >11 ){
                        return number;
                      }else{
                        return _dialCode.toString()+number.toString();
                      }
                    }


                    return Padding(
                      padding: EdgeInsets.only(
                          left: 7, right: 7, top: 5),
                      child: Column(
                        children: [
                          ListTile(
                            //focusColor:Colors.white,
                            //hoverColor:Colors.white,
                            selectedTileColor:Colors.white,
                            onTap: ()async {
                              try {
                                var token = await UserManager.instance.getToken();

                                ///development
                                //var request = http.MultipartRequest('POST', Uri.parse('https://dev.cheerzclub.com/public/api/v1/user/invite-contact'));


                                ///live
                                var request = http.MultipartRequest('POST', Uri.parse('https://www.cheerzclub.com/api/v1/user/invite-contact'));

                                request.fields.addAll({'phone': numberview(number: '${ _unavailabFoundUsers[index]['phone']}'),});

                                request.headers.addAll({
                                  'Authorization': 'Bearer $token'
                                });

                                http.StreamedResponse response =
                                await request.send();

                                //print("ttttttttttttttt");
                                //print(unavailable?[index]['phone'].length);

                                if (response.statusCode == 200) {
                                  final res = await http.Response
                                      .fromStream(response);
                                  // String? source= res.body.toString();
                                  responsee = jsonDecode(res.body);
                                  String? source = responsee['message'];

                                  source == "Invited"
                                      ? Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context).translate('Invited Successfully!'),
                                      backgroundColor:
                                      Colors.green,
                                      textColor: Colors.white)
                                      : Fluttertoast.showToast(
                                      msg: source.toString(),
                                      backgroundColor:
                                      Colors.amber,
                                      textColor:
                                      Colors.black);

                                  // unavailable?[index]['phone'].contains("+") || unavailable?[index]['phone'].length>11 ?

                                  // Fluttertoast.showToast(
                                  //     msg: AppLocalizations.of(context).translate('please check your phone number contain dial code'),
                                  //     backgroundColor:
                                  //     Colors.amber,
                                  //     textColor:
                                  //     Colors.black);

                                } else {
                                  Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context).translate('Invite failed'),
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white);
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

                              //Hi, ${user?.name} has invited you to CheerzClub.
                              //Share.share('Download CheerzClub and Get Your Drink On from here https://cheerzclub.com/',);


                              // if (Platform.isAndroid) {
                              //   String telephoneNumber = unavailable?[index]['phone'];
                              //   // String? name= name1;
                              //   // String? phone= Phone1;
                              //   String uri = "sms:$telephoneNumber?body=I'm inviting you to use Cheerzclub https://cheerzclub.com/";
                              //   await launch(uri);
                              // } else if (Platform.isIOS) {
                              //   // iOS
                              //   String telephoneNumber = unavailable?[index]['phone'];
                              //   // String? name= name1;
                              //   // String? phone= Phone1;
                              //   String uri = "sms:$telephoneNumber?body=I'm inviting you to use Cheerzclub Cheerzclub https://cheerzclub.com/";
                              //   await launch(uri);
                              // } else {
                              //   throw 'Error occured trying to send a message that number.';
                              // }

                            },
                            leading: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                CheersClubText(
                                  text: _unavailabFoundUsers[index]['name']??"",
                                  fontColor: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CheersClubText(
                                  text: numberview(number: '${_unavailabFoundUsers[index]['phone']}'),
                                  fontColor: Colors.white,
                                  fontSize: 15,
                                ),
                              ],
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CheersClubText(
                                text: AppLocalizations.of(context)
                                    .translate('invt'),
                                fontColor: Colors.green,
                                fontSize: 11,
                                over: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          ),
                          Divider(
                            color: Colors.grey.shade700,
                            height: 13,
                            thickness: 0.3,
                          ),
                        ],
                      ),
                    );
                  })
                  : Center(
                child:
                Column(
                  children: [
                    SizedBox(height: 20,),
                    CheersClubText(
                      text: AppLocalizations.of(context).translate('No Results'),
                      fontColor: Colors.grey.shade500,
                      fontSize: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );

  }
}




