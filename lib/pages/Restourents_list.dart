// ignore_for_file: file_names

import 'dart:io';

import 'package:cheersclub/Utils/managers/location_manager.dart';
import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/auth/Retourents/restourents_cubit.dart';
import 'package:cheersclub/cubit/repository/ResorentsListRepository.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/models/SingleRestorent.dart';
import 'package:cheersclub/pages/PlaceOrder.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer_image/shimmer_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';


class LocationDetails {
  final String? lat;
  final String? long;
  final String? state;
  final String? district;
  final String? address;
  final String? street;
  final String? pin;

  const LocationDetails(
      this.lat,
      this.long,
      this.state,
      this.district,
      this.address,
      this.street,
      this.pin,
      );
}

class RestourentList extends StatefulWidget {
  const RestourentList({Key? key}) : super(key: key);

  @override
  _RestourentListState createState() => _RestourentListState();
}

class _RestourentListState extends State<RestourentList> {

  final _formKey = GlobalKey<FormState>();
  var hotsname_Controller = TextEditingController();
  var place_Controller = TextEditingController();
  var contactperson_Controller= TextEditingController();
  var phonenumber_Controller = TextEditingController();
  // bool _permissionDenied = false;
  //
  // Widget _body(bool _permissionDenied) {
  //   if (_permissionDenied){
  //     return const Padding(
  //       padding: EdgeInsets.only(left: 20, right: 20,),
  //       child: Center(
  //         child:CheersClubText(
  //           text: 'Permission denied, please allow your contact access',
  //           fontColor: Colors.white,
  //           fontSize: 13,
  //         ),
  //       ),
  //     );
  //   }
  //
  //   if (_contacts == null){
  //     return Center(child: CircularProgressIndicator());
  //   }
  //   return Container(
  //       height: 46,
  //       margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
  //       padding: EdgeInsets.only(left: 4),
  //       //color: HexColor("FEC753"),
  //       child: Row(
  //         children: [
  //           Container(
  //             color: HexColor("28292C"),
  //             width: 120,
  //             child: DropdownButtonFormField<Contact>(
  //               isExpanded: true,
  //               decoration: InputDecoration(enabledBorder: InputBorder.none,
  //                 contentPadding: EdgeInsets.only(
  //                   left: 10,
  //                 ),
  //               ),
  //               icon: const Icon(Icons.arrow_drop_down,color: Colors.amber,),
  //               iconSize: 24,
  //               elevation: 16,
  //               dropdownColor: Colors.amber,
  //               hint: CheersClubText(
  //                 text: AppLocalizations.of(context).translate("contact"),
  //                 alignment:  TextAlign.center,
  //                 fontColor: Colors.white,
  //               ),
  //               value: contact_obj,
  //               style: TextStyle(color: Colors.white),
  //               onChanged: (value) async {
  //                 final fullContact = await FlutterContacts.getContact(value!.id);
  //
  //                 setState(() {
  //                   contact_obj = value;
  //                   no = fullContact!.phones.isNotEmpty ? fullContact.phones.first.number : '(none)';
  //
  //                   print(fullContact.name.first);
  //
  //                   print(fullContact.phones.isNotEmpty ? fullContact.phones.first.number : '(none)');
  //
  //                 });
  //               },
  //               items:
  //               _contacts?.map<DropdownMenuItem<Contact>>((Contact value) {
  //                 return DropdownMenuItem<Contact>(
  //                     value: value,
  //                     child: Container(
  //                         padding: EdgeInsets.only(left: 10),
  //                         height: 30,
  //
  //
  //                         child:  CheersClubText(text:"${value.displayName}",
  //                           alignment:  TextAlign.left,
  //                           fontSize: 15,
  //                           over: TextOverflow.ellipsis,
  //                           fontColor: value == contact_obj ? Colors.white : Colors.black,
  //
  //                         )));
  //               }).toList(),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 1,
  //           ),
  //           Expanded(
  //             child: Container(
  //               color: HexColor("28292C"),
  //               height: 50,
  //               child: Center(
  //                 child: CheersClubText(
  //                   text: no,
  //                   alignment:  TextAlign.center,
  //                   fontColor: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ));
  // }



  GlobalKey<ScaffoldState>? _key = GlobalKey();
  var Restourent_Controller = TextEditingController();
  var zipplace_Controller = TextEditingController();


  String? _selectedLatLocation="";
  String? _selectedLongLocation="";
 // String? country="";
  //bool? _ispermision;

  // var locationDetails;
  //
  // Future<void> _checkPermission() async {
  //   // final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
  //   // final isGpsOn = serviceStatus == ServiceStatus.enabled;
  //   // if (!isGpsOn) {
  //   //   print('Turn on location services before requesting permission.');
  //   //   getCurrentAddress();
  //   // }
  //   final status = await Permission.locationWhenInUse.request();
  //   if (status == PermissionStatus.granted) {
  //     setState(() {
  //       _ispermision=true;
  //     });
  //     print('Permission granted');
  //     getCurrentAddress();
  //   } else if (status == PermissionStatus.denied) {
  //     setState(() {
  //       _ispermision=false;
  //     });
  //     print('Permission denied. Show a dialog and again ask for the permission');
  //
  //     Fluttertoast.showToast(
  //         msg: AppLocalizations.of(context).translate("Permission denied,please allow your GPS access"),
  //         backgroundColor: Colors.amber,
  //         textColor: Colors.black,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.SNACKBAR,
  //         timeInSecForIosWeb: 100,
  //         fontSize: 16.0
  //     );
  //
  //   } else if (status == PermissionStatus.permanentlyDenied) {
  //     print('Take the user to the settings page.');
  //     await openAppSettings();
  //   }
  // }
  //
  //
  // void getCurrentAddress() async {
  //    locationDetails = await LocationManager.instance.getCurrentAddressDetails();
  //   setState(() {
  //     _selectedLatLocation = locationDetails!.lat.toString();
  //     _selectedLongLocation  = locationDetails.long.toString();
  //
  //    // restourentsCubit.loadrestourent(_selectedLatLocation.toString(),_selectedLongLocation.toString());
  //
  //     print("************MY**LOCATION****LAT****"+_selectedLatLocation!);
  //     print("************MY**LOCATION****LONG****"+_selectedLongLocation!);
  //
  //   });
  // }


 Future<void> getLocation()async{
   Position position = await _determinePosition();
   try {
     position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
     setState(() {
       _selectedLatLocation = position.latitude.toString();
       _selectedLongLocation  = position.longitude.toString();
       restourentsCubit.loadrestourent(_selectedLatLocation.toString(),_selectedLongLocation.toString());
       print("************MY**LOCATION****LAT****"+_selectedLatLocation!);
       print("************MY**LOCATION****LONG****"+_selectedLongLocation!);
     });
   } catch (e) {
     print("Catch error : "+e.toString());
   }
 }



  Future<Position> _determinePosition() async {
    //bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    //serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   return Future.error('Location services are disabled...');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        Utils.showDialouge(
            context, AlertType.warning, "Warning!", AppLocalizations.of(context).translate("Permission denied,please allow your GPS access"));


        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.


      Utils.showDialouge(
          context, AlertType.warning, "Warning!", AppLocalizations.of(context).translate("Permission denied,please allow your GPS access"));



      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }


  late RestourentsCubit restourentsCubit;
  int? cart_count;
  List<SingleRestorent> restList = [];
  @override
  void initState() {
    restourentsCubit = RestourentsCubit(UserResListRepository());
    //_checkPermission();
    getLocation();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key!,
      endDrawer: drowerAfterlogin(),
      body:BlocProvider(
          create: (context) => restourentsCubit,
          child: BlocListener<RestourentsCubit, RestourentsState>(
            bloc: restourentsCubit,
            listener: (context, state) {
              if (state is RestourentsLoading) {
              } else if (state is RestourentsSucces) {
                restList = state.RestourentList;
              } else if (state is RestourentFail) {
                Utils.showDialouge(
                    context, AlertType.error, "Oops!", state.erroe);
              } else if (state is RestourentsSearchloading) {
                restList.clear();
              } else if (state is RestourentsSearchSucess) {
                restList = state.RestourentList;
              } else if (state is RestourentsSearcfail) {
                Utils.showDialouge(
                    context, AlertType.error, "Oops!", state.erroe);
              }
              else if (state is LetusknowLoading){}
              else if (state is LetusknowSuccessFull){

                Fluttertoast.showToast(
                  msg:   AppLocalizations.of(context).translate("Mail send Successfully!"),
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);

                Navigator.pop(context);

                hotsname_Controller.clear();
                place_Controller.clear();
                contactperson_Controller.clear();
                phonenumber_Controller.clear();

              }
              else if(state is LetusknowFail){
                Utils.showDialouge(
                    context, AlertType.error, "Oops!", state.error);
              }

            },
            child: BlocBuilder<RestourentsCubit, RestourentsState>(
                builder: (context, state) {
              if (state is RestourentsLoading) {
                return RestForm();
              } else if (state is RestourentsSucces) {
                return RestForm();
              }
              else if (state is LetusknowLoading){
                return RestForm();
              }
              else if (state is LetusknowSuccessFull){
                return RestForm();
              }
              else if(state is LetusknowFail){
                return RestForm();
              }
              return RestForm();
            }),
          )),
    );
  }

  Widget RestForm() {
    return
    //   restList.length==0?
    // Container(
    //   color: HexColor("1A1B1D"),
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   child: const Center(
    //     child: CupertinoActivityIndicator(radius: 10,),
    //   ),
    // ) :
    SingleChildScrollView(
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
                            _key!.currentState!.openEndDrawer();
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
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  CheersClubText(text: AppLocalizations.of(context).translate("WHERE DO YOU WANT TO CREATE HAPPY MOMENTS?"),
                    fontSize: 17,alignment:TextAlign.start,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    // over: TextOverflow.ellipsis,

                  ),

                ],
              ),
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 20, right: 20, top: 0),
              // padding: EdgeInsets.only(top: 18),
              child: TextField(
                controller: Restourent_Controller,
                cursorColor: Colors.amber,
                textInputAction: TextInputAction.done,
                // onSubmitted: (value) {
                //   if(Restourent_Controller.text !=null){
                //     restourentsCubit.loadrestourentFilter(Restourent_Controller.text,zipplace_Controller.text ==null? "" : zipplace_Controller.text);
                //     Restourent_Controller.clear();
                //   }
                //   else{
                //     restourentsCubit.loadrestourentFilter(Restourent_Controller.text==null? "": Restourent_Controller.text,zipplace_Controller.text==null? "" : zipplace_Controller.text);
                //     zipplace_Controller.clear();
                //   }
                //   print("search");
                // },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: HexColor("59595B"),
                  ),
                  border: InputBorder.none,
                  //floatingLabelBehavior: true,
                  hintText: AppLocalizations.of(context).translate("Name Hotspot"),
                  hintStyle: TextStyle(
                    color: HexColor("59595B"),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 0.0, top: 8.0),

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
              height: 40,
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              // padding: EdgeInsets.only(top: 18),
              child: TextField(
                controller: zipplace_Controller,
                cursorColor: Colors.amber,
                textInputAction: TextInputAction.done,
                // onSubmitted: (value) {
                //   if(Restourent_Controller.text !=null){
                //     restourentsCubit.loadrestourentFilter(Restourent_Controller.text,zipplace_Controller.text ==null? "" : zipplace_Controller.text);
                //     Restourent_Controller.clear();
                //   }
                //   else{
                //     restourentsCubit.loadrestourentFilter(Restourent_Controller.text==null? "": Restourent_Controller.text,zipplace_Controller.text==null? "" : zipplace_Controller.text);
                //     zipplace_Controller.clear();
                //   }
                //   print("search");
                // },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: HexColor("59595B"),
                  ),
                  border: InputBorder.none,
                  //floatingLabelBehavior: true,
                  hintText: AppLocalizations.of(context).translate("Zipcode or place"),
                  hintStyle: TextStyle(
                    color: HexColor("59595B"),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: HexColor("28292C"),

                  contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 0.0, top: 8.0),

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
              padding: const EdgeInsets.only(left: 20, right: 20,top: 14),
              child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: HexColor("FEC753"), // background
                    onPrimary: Colors.black, // foreground
                  ),
                  child: Container(
                    height: 40,
                    child:  Center(
                      child: CheersClubText(
                        text: AppLocalizations.of(context).translate("SEARCH"),
                        fontColor: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onPressed: () {

                    FocusScope.of(context).requestFocus( FocusNode());

                      if(Restourent_Controller.text.isNotEmpty){
                        restourentsCubit.loadrestourentFilter(Restourent_Controller.text,zipplace_Controller.text ==null? "" : zipplace_Controller.text);
                        Restourent_Controller.clear();
                      }
                      else{
                        restourentsCubit.loadrestourentFilter(Restourent_Controller.text==null? "": Restourent_Controller.text,zipplace_Controller.text==null? "" : zipplace_Controller.text);
                        zipplace_Controller.clear();
                      }




                      print("search");

                  }

              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 20, top: 18),
              child: Row(
                children: [
                  CheersClubText(
                    text: AppLocalizations.of(context).translate("Did'nt Find Your Favourite Hotspot"),
                    alignment: TextAlign.start,
                    fontColor: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20,top: 18),
              child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    primary: Colors.redAccent.shade700, // background
                    onPrimary: Colors.black, // foreground
                  ),
                  child: Container(
                    height: 40,
                    child:  Center(
                      child: CheersClubText(
                        text: AppLocalizations.of(context).translate("LET US KNOW"),
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onPressed: () {

                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.black,
                        content: Container(
                          height: 480,
                          width: 350,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: SizedBox()),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.clear_outlined,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                    )
                                  ],
                                ),

                                Container(
                                  padding: EdgeInsets.only(top: 14),
                                  child: Row(
                                    children: [
                                      CheersClubText(
                                        text: AppLocalizations.of(context).translate("LET US KNOW"),
                                        fontColor: Colors.amber,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),


                                Divider(thickness: 1.0,color: Colors.white,),



                                Container(
                                  padding: EdgeInsets.only(top: 14),
                                  child: Row(
                                    children: [
                                      CheersClubText(
                                        text: AppLocalizations.of(context).translate("HOTSPOT"),
                                        fontColor: Colors.amber,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin: EdgeInsets.only(top: 10),
                                  // padding: EdgeInsets.only(top: 18),
                                  child: TextField(
                                    controller: hotsname_Controller ,
                                    cursorColor: Colors.amber,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: HexColor("28292C"),
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
                                  padding: EdgeInsets.only(top: 14),
                                  child: Row(
                                    children: [
                                      CheersClubText(
                                        text: AppLocalizations.of(context).translate("PLACE"),
                                        fontColor: Colors.amber,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin: EdgeInsets.only(top: 10),
                                  // padding: EdgeInsets.only(top: 18),
                                  child: TextField(
                                    controller: place_Controller,
                                    cursorColor: Colors.amber,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: HexColor("28292C"),
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
                                  padding: EdgeInsets.only(top: 14),
                                  child: Row(
                                    children: [
                                      CheersClubText(
                                        text: AppLocalizations.of(context).translate("CONTACT PERSON"),
                                        fontColor: Colors.amber,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin: EdgeInsets.only(top: 10),
                                  // padding: EdgeInsets.only(top: 18),
                                  child: TextField(
                                    controller: contactperson_Controller,
                                    cursorColor: Colors.amber,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: HexColor("28292C"),
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
                                  padding: EdgeInsets.only(top: 14),
                                  child: Row(
                                    children: [
                                      CheersClubText(
                                        text: AppLocalizations.of(context).translate("PHONE NUMBER"),
                                        fontColor: Colors.amber,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin: EdgeInsets.only(top: 10),
                                  // padding: EdgeInsets.only(top: 18),
                                  child: TextField(
                                    controller: phonenumber_Controller,
                                    keyboardType: TextInputType.number,
                                    cursorColor: Colors.amber,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: HexColor("28292C"),
                                      // contentPadding:
                                      // const EdgeInsets.only(left: 14.0, bottom: 0.0, top: 8.0),
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

                               SizedBox(height: 20,),

                                Divider(thickness: 1.0,color: Colors.white,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [

                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white, // background
                                          onPrimary: Colors.black, // foreground
                                        ),
                                        child: Container(
                                          height: 30,
                                          child:  Center(
                                            child: CheersClubText(
                                              text: AppLocalizations.of(context).translate("CLOSE"),
                                              fontColor: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {

                                          Navigator.pop(context);

                                        }

                                    ),

                                    SizedBox(width: 10,),

                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.redAccent.shade700, // background
                                          onPrimary: Colors.black, // foreground
                                        ),
                                        child: Container(
                                          height: 30,
                                          child:  Center(
                                            child: CheersClubText(
                                              text: AppLocalizations.of(context).translate("send"),
                                              fontColor: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      onPressed: () {
                                        // if (_formKey.currentState!.validate()) {

                                          restourentsCubit.Letusknow(hotsname_Controller.text,place_Controller.text,contactperson_Controller.text,phonenumber_Controller.text);

                                        // }

                                      },

                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

                  }

              ),
            ),

           _selectedLatLocation !="" && _selectedLongLocation !="" ?
            Expanded(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: restList.length,
                    itemBuilder: (snapshot,index){

                        return Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Container(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1),
                                child: ProgressiveImage(
                                  baseColor: Colors.grey.shade500,
                                  highlightColor: Colors.grey.shade600,
                                  height: 190,
                                  width: 350,
                                  fit: BoxFit.cover,
                                  image: restList[index].profilePhotoUrl.toString(),
                                  imageError: "assets/images/nia.jpg",

                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 24, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    CheersClubText(
                                      text: restList[index].name?.toUpperCase()??"",
                                      fontColor: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),

                                    const SizedBox(
                                      height: 13,
                                    ),
                                    CheersClubText(
                                      text: restList[index].address?.toString()??"",
                                      fontColor: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),


                                    const SizedBox(
                                      height: 8,
                                    ),


                                    restList[index].city==null || restList[index].latitude==null ||
                                        restList[index].longitude==null ? Container()
                                        :
                                    InkWell(
                                      onTap: ()async{


                                        if (Platform.isAndroid) {
                                          // Android
                                          String lat = restList[index].latitude.toString();
                                          String lng = restList[index].longitude.toString();
                                          var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
                                          await launch(uri.toString());
                                        } else if (Platform.isIOS) {
                                          // iOS
                                          String lat = restList[index].latitude.toString();
                                          String lng = restList[index].longitude.toString();
                                          var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
                                          await launch(uri.toString());
                                        } else {
                                          throw 'Could not launch';
                                        }


                                      },
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 0,
                                          ),
                                          const Icon(
                                            Icons.location_on_rounded,
                                            size: 12,
                                            color: Colors.amber,
                                          ),
                                          CheersClubText(
                                            text: restList[index].zip==null? restList[index].city.toString() : restList[index].city.toString() + "," + restList[index].zip.toString(),
                                            fontColor: Colors.white,
                                            fontSize: 11,
                                          )
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 8,
                                    ),


                                    restList[index].website==null? Container() : InkWell(
                                      onTap: ()async{


                                        if (Platform.isAndroid) {
                                          // Android
                                          // String lat = restList[index].latitude.toString();
                                          // String lng = restList[index].longitude.toString();
                                          var uri = Uri.parse(restList[index].website.toString());
                                          await launch(uri.toString());
                                        } else if (Platform.isIOS) {
                                          // iOS
                                          // String lat = restList[index].latitude.toString();
                                          // String lng = restList[index].longitude.toString();
                                          var uri = Uri.parse(restList[index].website.toString());
                                          await launch(uri.toString());
                                        } else {
                                          throw 'Could not launch';
                                        }


                                      },
                                      child: Row(
                                        children: [

                                          CheersClubText(
                                            text: "${restList[index].website}",
                                            fontColor: Colors.white,
                                            fontSize: 11,
                                          )
                                        ],
                                      ),
                                    ),


                                    Padding(
                                      padding: const EdgeInsets.only(top: 20,bottom: 25),
                                      child:  ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(1.0),
                                            ),
                                            primary: HexColor("FEC753"), // background
                                            onPrimary: Colors.black, // foreground
                                          ),
                                          child: Container(
                                            height: 40,
                                            child:  Center(
                                              child: CheersClubText(
                                                text:  AppLocalizations.of(context)
                                                    .translate("BUY A DRINK"),
                                                fontColor: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (c, a1, a2) => PlaceOrder(
                                                  restouretId: restList[index].id,
                                                ),
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

                                      ),
                                    ),


                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );

                    },

                    ))
               :
            Row(
                     mainAxisAlignment:MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(height: 120,),
                        Container(child: CupertinoActivityIndicator(
                          radius: 10,
                        ),),
                      ],
                    ),
          ],
        ),
      ),
    );
  }
}
