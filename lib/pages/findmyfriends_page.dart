// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/models/Contact/appContact_class.dart';
import 'package:cheersclub/models/Contact/contactList_class.dart';
import 'package:cheersclub/models/auth/user.dart';
import 'package:cheersclub/networking/app_exception.dart';
import 'package:cheersclub/pages/Restourents_list.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:country_codes/country_codes.dart';

class Myfriendslist extends StatefulWidget {
  const Myfriendslist({Key? key}) : super(key: key);

  @override
  _MyfriendslistState createState() => _MyfriendslistState();
}

class _MyfriendslistState extends State<Myfriendslist> {
  var searchController = new TextEditingController();
  List<dynamic>? available = [];
  List<dynamic>? unavailable = [];
  List<Map<String, String>> cnts = [];
  var responsee;
  String? source;
  bool? _ispermision;
  String? _dialCode="";


  // Future<void> getdialcode()async{
  //
  //   await CountryCodes.init(); // Optionally, you may provide a `Locale` to get countrie's localizadName
  //   final Locale? deviceLocale = CountryCodes.getDeviceLocale();
  //   //print(deviceLocale!.languageCode); // Displays en
  //   //print(deviceLocale.countryCode); // Displays US
  //
  //   final CountryDetails details = CountryCodes.detailsForLocale();
  //
  //   setState(() {
  //     _dialCode = details.dialCode.toString();
  //     print("************COUNTRY****"+  _dialCode.toString()); // Displays the dial code, for example +1.
  //   });
  //   //print(details.alpha2Code); // Displays alpha2Code, for example US.
  //   //print(details.name); // Displays the extended name, for example United States.
  //   //print(details.localizedName); // Displays the extended name based on device's language (or other, if provided on init)
  //
  // }



  Future<void> getPermissions() async {
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
        cnts.add({
          'name': _contacts[i].info?.displayName ?? "Null",
          'phone': _contacts[i].info!.phones!.length > 0
              ? _contacts[i].info!.phones!.elementAt(0).value.toString()
              : 'Null'
        });
      }
      contactpost();
    } on HttpException catch (e) {
      print(e);
    } on FormatException catch (e) {
      print(e);
    }
    throw Exception();
  }

  Future<void> contactpost() async {
    try {
      var body = {"contacts": cnts};
      print(body);
      var token = await UserManager.instance.getToken();
      ///development
      //var request = http.Request('POST',Uri.parse('https://dev.cheerzclub.com/public/api/v1/user/sync-contacts'));


      ///live
      var request = http.Request('POST',Uri.parse('https://www.cheerzclub.com/api/v1/user/sync-contacts'));

      request.body = json.encode(body);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });
      print(request.toString() + "***************");
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var source = jsonDecode(res.body);
        setState(() {
          available = source["data"]["available"];
          unavailable = source["data"]["unavailable"];
        });
        print("**Contacts available:***" + available.toString());
        print("**Contacts unavailable:***" + unavailable.toString());
      } else {
        print(response.reasonPhrase);
      }
    } on SocketException {
      Fluttertoast.showToast(
          msg: 'No Internet connection',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 100,
          fontSize: 16.0);
    }
    throw FetchDataException('No Internet connection');
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getdialcode();
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
            child: Center(
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
      body: unavailable?.length == 0 && available?.length == 0
          ? Container(
        color: HexColor("1A1B1D"),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: CupertinoActivityIndicator(
            radius: 10,
          ),
        ),
      )
          : SingleChildScrollView(
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
                  controller:  searchController,
                  onChanged: (val) {
                  },
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
                    hintText:  AppLocalizations.of(context).translate('nou'),
                    hintStyle: TextStyle(
                      color: HexColor("59595B"),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: HexColor("28292C"),

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

              available?.length == 0
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
                  itemCount: available?.length,
                  itemBuilder: (context, index) {
                    return available?[index]['name'] == "Null" &&
                        available?[index]['phone'] == "Null"
                        ? Container()
                        : Padding(
                      padding: EdgeInsets.only(
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
                                  text: available?[index]['name'] ==
                                      "Null"
                                      ? ""
                                      : available?[index]['name'],
                                  fontColor: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                CheersClubText(
                                  text: available?[index]
                                  ['phone'] ==
                                      "Null"
                                      ? ""
                                      : available?[index]['phone'],
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
              unavailable?.length == 0
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheersClubText(
                      text: AppLocalizations.of(context).translate('Invite from Contact'),
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
                  itemCount: unavailable?.length,
                  itemBuilder: (context, index) {
                    return unavailable?[index]['name'] == "Null" &&
                        unavailable?[index]['phone'] == "Null"
                        ? Container()
                        : Padding(
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

                                request.fields.addAll({'phone': unavailable?[index]['phone'].contains("+") || unavailable?[index]['phone'].length>11 ?
                                unavailable![index]['phone'] : _dialCode.toString() + unavailable?[index]['phone'],});

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
                                  text: unavailable?[index]
                                  ['name'] ==
                                      "Null"
                                      ? ""
                                      : unavailable?[index]['name'],
                                  fontColor: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                CheersClubText(
                                  text: unavailable?[index]
                                  ['phone'] ==
                                      "Null"
                                      ? ""
                                      : unavailable?[index]['phone'].contains("+") || unavailable?[index]['phone'].length>11 ?
                                  unavailable![index]['phone'] : _dialCode.toString() + unavailable?[index]['phone'],
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
                                fontColor: Colors.blue.shade300,
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
            ],
          ),
        ),
      ),
    );
  }
}