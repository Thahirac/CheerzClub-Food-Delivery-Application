// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/RestouretCart/restourent_cart_cubit.dart';
import 'package:cheersclub/cubit/repository/RestourentkartRepository.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/models/cart/RestourentKartModel.dart';
import 'package:cheersclub/models/payment/paymentModelclass.dart';
import 'package:cheersclub/pages/payment_failurepage.dart';
import 'package:cheersclub/pages/payment_successpage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cheersclub/networking/app_exception.dart';
import 'package:cheersclub/pages/PlaceOrder.dart';
import 'package:cheersclub/pages/Restourents_list.dart';
import 'package:cheersclub/pages/paymentpage.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:future_progress_dialog/future_progress_dialog.dart';
import '../widgets/cheerzclub_const.dart';
import 'LoginScreen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class Restourentcart extends StatefulWidget {
  final int? restorent_id;
  const Restourentcart({Key? key, this.restorent_id}) : super(key: key);

  @override
  _RestourentcartState createState() => _RestourentcartState();
}

class _RestourentcartState extends State<Restourentcart> {


  TextEditingController datetimeController = TextEditingController();
  TextEditingController dialCodeController = TextEditingController();
  TextEditingController recipientent_name_Controller = TextEditingController();
  TextEditingController request_controller = TextEditingController();
  TextEditingController recipientent_message_Controller = TextEditingController();
  TextEditingController mobilenumber_Controller = TextEditingController();
  TextEditingController noController = TextEditingController();
  TextEditingController no1Controller = TextEditingController();
  TextEditingController no2Controller = TextEditingController();

  //dynamic imageFile;
  File? file;
  String? filenamecheck;
  int sizeInBytes=20 ;
  double sizeInMb=5;


  Future selectFile() async {
    try {

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'mp4', 'jpeg', 'mov'],
      );
      final fileName = file != null
          ? (file!.path)
          : AppLocalizations.of(context).translate("nfile");

      if (result == null) return;
      final path = result.files.single.path;

      setState(() => file = File(path!));
      filenamecheck = fileName;
      print("******FILE*****${file!.path}");



      sizeInBytes = file!.lengthSync();
      sizeInMb = sizeInBytes / (1024 * 1024);


    } on PlatformException catch (e) {
      print('failed : $e');
    }
  }

  var utcDatetime;
  bool value = false;
  bool _selectedtype = false;
  String? selectedtypevalue;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  String? _chosenValue = "+31";
  late RestourentCartCubit restourentCartCubit;

  List<Cart>? cart = [];
  dynamic sutotal = 0.0;
  dynamic vat21 = 0.0;
  dynamic vat9 = 0.0;
  dynamic total = 0.0;
  dynamic transactionfee = 0.0;
  String? url;
  int? order_Id;
  String? logError;
  //String? payment_intent_id;
  bool? isloading;
  bool pisloading = false;

  Widget myAppBarIcon() {
    return Container(
      width: 30,
      height: 30,
      child: Stack(
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 26,
          ),
          Container(
            width: 27,
            height: 30,
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 0),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HexColor("FFC853"),
                  border: Border.all(color: Colors.white, width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    cart!.length.toString(),
                    style: const TextStyle(fontSize: 8, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double heght = 40;
  bool _visible = false;
  bool _visible1 = false;
  List<Contact>? _contacts = [];
  String no = "";
  String no1 = "";
  String no2 = "";
  Contact? contact_obj;
  Contact? contact_obj1;
  Contact? contact_obj2;
  bool _permissionDenied = false;

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() {
        _contacts = contacts;
      });
    }
  }

  Widget _body(bool _permissionDenied) {
    if (_permissionDenied) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
        color: HexColor("28292C"),
        height: 50,
        child: Center(
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: noController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "00000 00000",
              hintStyle: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: "Raleway"),
            ),
            // onChanged: (v){
            //   setState(() {
            //     contact_obj?.displayName="";
            //   });
            // },
          ),
        ),
      );
    }

    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
        height: 46,
        margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
        padding: const EdgeInsets.only(left: 4),
        //color: HexColor("FEC753"),
        child: Row(
          children: [
            Container(
              width: 120,
              color: HexColor("28292C"),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButton2<Contact>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.amber,
                    ),
                    dropdownWidth: 150,
                    dropdownMaxHeight: 300,
                    dropdownDecoration: const BoxDecoration(
                      color: Colors.amber,
                    ),
                    style: const TextStyle(color: Colors.black),
                    iconSize: 24,
                    dropdownElevation: 16,
                    isExpanded: true,
                    focusColor: HexColor("28292C"),
                    iconEnabledColor: Colors.amber,
                    hint: CheersClubText(
                      text:
                          AppLocalizations.of(context).translate("contactlist"),
                      alignment: TextAlign.center,
                      fontColor: Colors.white,
                      fontSize: 10,
                    ),
                    // value: contact_obj,
                    onChanged: (value) async {
                      final fullContact =
                          await FlutterContacts.getContact(value!.id);

                      setState(() {
                        contact_obj = value;
                        no = fullContact!.phones.isNotEmpty
                            ? fullContact.phones.first.number
                            : '(none)';
                        //no.length>11?no.substring(3)
                        noController = TextEditingController(text: no);
                        print(fullContact.name.first);

                        print(fullContact.phones.isNotEmpty
                            ? fullContact.phones.first.number
                            : '(none)');
                      });
                    },
                    items: _contacts
                        ?.map<DropdownMenuItem<Contact>>((Contact value) {
                      return DropdownMenuItem<Contact>(
                          value: value,
                          child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 30,
                              child: CheersClubText(
                                text: "${value.displayName}",
                                alignment: TextAlign.left,
                                fontSize: 15,
                                over: TextOverflow.ellipsis,
                                fontColor: value == contact_obj
                                    ? Colors.white
                                    : Colors.black,
                              )));
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 1,
            ),
            Expanded(
              child: Container(
                color: HexColor("28292C"),
                height: 50,
                child: Center(
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: noController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "00000 00000",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Raleway"),
                    ),
                    // onChanged: (v){
                    // setState(() {
                    //   contact_obj?.displayName="";
                    // });
                    //},
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _body1(bool _permissionDenied) {
    if (_permissionDenied) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
        color: HexColor("28292C"),
        height: 50,
        child: Center(
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: no1Controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "00000 00000",
              hintStyle: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: "Raleway"),
            ),
            // onChanged: (v){
            //   setState(() {
            //     contact_obj?.displayName="";
            //   });
            // },
          ),
        ),
      );
    }

    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
        height: 46,
        margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
        padding: const EdgeInsets.only(left: 4),
        //color: HexColor("FEC753"),
        child: Row(
          children: [
            Container(
              width: 120,
              color: HexColor("28292C"),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButton2<Contact>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.amber,
                    ),
                    dropdownWidth: 150,
                    dropdownMaxHeight: 300,
                    dropdownDecoration: const BoxDecoration(
                      color: Colors.amber,
                    ),
                    style: const TextStyle(color: Colors.black),
                    iconSize: 24,
                    dropdownElevation: 16,
                    isExpanded: true,
                    focusColor: HexColor("28292C"),
                    iconEnabledColor: Colors.amber,
                    hint: CheersClubText(
                      text:
                          AppLocalizations.of(context).translate("contactlist"),
                      alignment: TextAlign.center,
                      fontColor: Colors.white,
                      fontSize: 10,
                    ),
                    //value: contact_obj1,
                    onChanged: (value) async {
                      final fullContact =
                          await FlutterContacts.getContact(value!.id);

                      setState(() {
                        contact_obj1 = value;
                        no1 = fullContact!.phones.isNotEmpty
                            ? fullContact.phones.first.number
                            : '(none)';
                        no1Controller = TextEditingController(text: no1);
                        print(fullContact.name.first);

                        print(fullContact.phones.isNotEmpty ? fullContact.phones.first.number : '(none)');
                      });
                    },
                    items: _contacts
                        ?.map<DropdownMenuItem<Contact>>((Contact value) {
                      return DropdownMenuItem<Contact>(
                          value: value,
                          child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 30,
                              child: CheersClubText(
                                text: "${value.displayName}",
                                alignment: TextAlign.left,
                                fontSize: 15,
                                over: TextOverflow.ellipsis,
                                fontColor: value == contact_obj1
                                    ? Colors.white
                                    : Colors.black,
                              )));
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 1,
            ),
            Expanded(
              child: Container(
                color: HexColor("28292C"),
                height: 50,
                child: Center(
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: no1Controller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "00000 00000",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Raleway"),
                    ),
                    // onChanged: (v){
                    //   setState(() {
                    //     contact_obj1?.displayName="";
                    //   });
                    // },
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _body2(bool _permissionDenied) {
    if (_permissionDenied) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
        color: HexColor("28292C"),
        height: 50,
        child: Center(
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: no2Controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "00000 00000",
              hintStyle: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: "Raleway"),
            ),
            // onChanged: (v){
            //   setState(() {
            //     contact_obj?.displayName="";
            //   });
            // },
          ),
        ),
      );
    }

    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
        height: 46,
        margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
        padding: const EdgeInsets.only(left: 4),
        //color: HexColor("FEC753"),
        child: Row(
          children: [
            Container(
              width: 120,
              color: HexColor("28292C"),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButton2<Contact>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.amber,
                    ),
                    dropdownWidth: 150,
                    dropdownMaxHeight: 300,
                    dropdownDecoration: const BoxDecoration(
                      color: Colors.amber,
                    ),
                    style: const TextStyle(color: Colors.black),
                    iconSize: 24,
                    dropdownElevation: 16,
                    isExpanded: true,
                    focusColor: HexColor("28292C"),
                    iconEnabledColor: Colors.amber,
                    hint: CheersClubText(
                      text:
                          AppLocalizations.of(context).translate("contactlist"),
                      alignment: TextAlign.center,
                      fontColor: Colors.white,
                      fontSize: 10,
                    ),
                    //value: contact_obj2,
                    onChanged: (value) async {
                      final fullContact =
                          await FlutterContacts.getContact(value!.id);

                      setState(() {
                        contact_obj2 = value;
                        no2 = fullContact!.phones.isNotEmpty
                            ? fullContact.phones.first.number
                            : '(none)';
                        no2Controller = TextEditingController(text: no2);
                        print(fullContact.name.first);

                        print(fullContact.phones.isNotEmpty
                            ? fullContact.phones.first.number
                            : '(none)');
                      });
                    },
                    items: _contacts
                        ?.map<DropdownMenuItem<Contact>>((Contact value) {
                      return DropdownMenuItem<Contact>(
                          value: value,
                          child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 30,
                              child: CheersClubText(
                                text: "${value.displayName}",
                                alignment: TextAlign.left,
                                fontSize: 15,
                                over: TextOverflow.ellipsis,
                                fontColor: value == contact_obj2
                                    ? Colors.white
                                    : Colors.black,
                              )));
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 1,
            ),
            Expanded(
              child: Container(
                color: HexColor("28292C"),
                height: 50,
                child: Center(
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: no2Controller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "00000 00000",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Raleway"),
                    ),
                    // onChanged: (v){
                    //   setState(() {
                    //     contact_obj2?.displayName="";
                    //   });
                    // },
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<int> initialPaymentApi() async {
    try {
      var token = await UserManager.instance.getToken();
      var userId = await UserManager.instance.getAccountId();

      ///development
      // var request = http.MultipartRequest('POST', Uri.parse('https://dev.cheerzclub.com/public/api/v1/user/restaurant/initiate-payment'));

      ///live
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://www.cheerzclub.com/api/v1/user/restaurant/initiate-payment'));

      request.fields.addAll({
        "restaurant_id": widget.restorent_id.toString(),
        "name": recipientent_name_Controller.text,
        "delivery_type": selectedtypevalue.toString(),
        "dialcode": _chosenValue.toString(),
        "dialcode2": _chosenValue.toString(),
        "dialcode3": _chosenValue.toString(),
        "phone": noController.text.toString(),
        "message": recipientent_message_Controller.text,
        "phone2": no1Controller.text.toString(),
        "phone3": no2Controller.text.toString(),
        "delivery_local_timezone": utcDatetime.toString(),
        "note": request_controller.text,
      });
      file?.path == null
          ? null
          : request.files.add(await http.MultipartFile.fromPath(
              'message_attachment', file!.path));
      request.headers.addAll({'Authorization': 'Bearer $token'});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        String responsee = res.body.toString();
        var source = jsonDecode(res.body);

        print("^^^^^^^^^^^^^^^ORDER ID^^^^^^^^^$order_Id");
        print("edit prof res......888888.....*...$responsee");

        return source['order_id'];

        // Fluttertoast.showToast(
        //   msg: AppLocalizations.of(context).translate('Initial payment success'),
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white);

        // setState(() {
        //   pisloading=true;
        // });

        // Navigator.pushReplacement(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (c, a1, a2) => PayMent(url: url.toString(),restaurantId: widget.restorent_id,),
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

        // Navigator.pushReplacement(
        //   context,
        //   PageTransition(
        //       duration: Duration(milliseconds: 500),
        //       type: PageTransitionType.rightToLeft,
        //       child: PayMent(url: url.toString(),restaurantId: widget.restorent_id,),
        //       inheritTheme: true,
        //       ctx: context),
        // );

      } else {
        print("Initial payment Exeception:${response.reasonPhrase}");

        Fluttertoast.showToast(
            msg: response.reasonPhrase.toString(),
            backgroundColor: Colors.amber,
            textColor: Colors.black);

        setState(() {
          pisloading = false;
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
        pisloading = false;
      });

    }

    throw FetchDataException('No Internet connection');
  }

  Future<http.StreamedResponse> Stripepaymentapi({int? order_id_val1}) async {
    try {
      var userId = await UserManager.instance.getAccountId();
      var headers = {'Content-Type': 'application/json'};

      ///live
      var request = http.Request(
          'POST', Uri.parse('https://www.cheerzclub.com/api/stripe-start'));

      // print("*******ORDER ID*****Stripe******"+ order_Id.toString());
      print(
        "*******RESTAURANT ID******${widget.restorent_id}",
      );

      print("*******USER ID******$userId");

      request.body = json.encode({
        "amt": total,
        "user_id": userId,
        "order_id": order_id_val1,
        "restaurant_id": widget.restorent_id,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        String responsee = res.body.toString();
        var source = jsonDecode(res.body);

        url = source['url'];

        print("******************web****url*******$url");
        print("edit prof res......888888.....*...$responsee");

        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)
                .translate('Initial payment success'),
            backgroundColor: Colors.green,
            textColor: Colors.white);

        setState(() {
          pisloading = true;
        });

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => PayMent(
              url: url.toString(),
              restaurantId: widget.restorent_id,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
      } else {

        print("Stripe payment Exeception:${response.reasonPhrase}");

         Fluttertoast.showToast(
            msg: response.reasonPhrase.toString(),
            backgroundColor: Colors.amber,
            textColor: Colors.black) ;

        setState(() {
          pisloading = false;
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
        pisloading = false;
      });

    }


    throw FetchDataException('No Internet connection');
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 3));
      return 'Please try again';
    });
  }

  Future<void> showProgressWithoutMsg(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
              getFuture(),
              progress: const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Colors.amber,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(15)),
            ));
    showResultDialog(context, result);
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(result),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              setState(() {
                pisloading = true;
              });

              await initialPaymentApi();
              //Stripepaymentapi();

              showProgressWithoutMsg(context);
            },
            child: const CheersClubText(
              text: "Retry",
              fontColor: Colors.white,
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }

  ///Stripe payment in mobile app direct***********************************************

  /* Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(String amount, String currency) async {
    try {
      paymentIntent = await createPaymentIntent(amount,currency);
      //Payment Sheet



      if(paymentIntent!=null){
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              merchantDisplayName: 'Prospects',
              paymentIntentClientSecret: paymentIntent?['client_secret'],
              customerId: paymentIntent?['customer'],
              customerEphemeralKeySecret: paymentIntent?['ephemeralkey'],
              applePay: const PaymentSheetApplePay(merchantCountryCode: '+31',),
              googlePay: PaymentSheetGooglePay(currencyCode: "NL", merchantCountryCode: "+31",),
              style: ThemeMode.dark,
              customFlow :true,
            ));

        ///now finally display payment sheeet
       // displayPaymentSheet();
        Stripepaymentapi();
      }

    } catch (e, s) {
      setState(() {
        pisloading=false;
      });
      log('*******exception:*********$e$s');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $STRIPE_SECRET_KEY',
          // 'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );



      // ignore: avoid_print

      //return jsonDecode(response.body);

      if (response.statusCode == 200) {
        String res = response.body.toString();
        var source = jsonDecode(res);
        payment_intent_id = source['id'];

        log('*****PAYMENT INTENT********* ${payment_intent_id.toString()}');
        log('Payment Intent Body->>> ${response.body.toString()}');

      }
      else {
        log('Payment Intent Body->>> ${response.body.toString()}');

      }

    } catch (err) {
      setState(() {
        pisloading=false;
      });
      // ignore: avoid_print
      log('err charging user: ${err.toString()}');
    }
  }




  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100 ;
    return calculatedAmout.toString();
  }

  displayPaymentSheet() async {

    try {
      await Stripe.instance.presentPaymentSheet(
      ).then((value){
        Stripepaymentapi();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => PaymentSuccessPage(
              resId: widget.restorent_id,
              icon: Icons.check,
              color: Colors.green,
              message: AppLocalizations.of(context).translate('ts'),
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
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        //paymentIntent = null;

        setState(() {
          pisloading=false;
        });

      }).onError((error, stackTrace){
        setState(() {
          pisloading=false;
        });
        Stripepaymentapi();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) =>   PaymentFailurePage(
              rest_id: widget.restorent_id,
              icon: Icons.cancel,
              color: Colors.red,
              message: AppLocalizations.of(context).translate('pf'),
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
        print('Error is:--->$error $stackTrace');
      });


    } on StripeException catch (e) {
      setState(() {
        pisloading=false;
      });
      print('Error is:---> $e');
      Stripepaymentapi();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) =>   PaymentFailurePage(
            rest_id: widget.restorent_id,
            icon: Icons.cancel,
            color: Colors.red,
            message: AppLocalizations.of(context).translate('pf'),
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
    } catch (e) {
      print('$e');
    }
  }*/

  @override
  void initState() {
    // TODO: implement initState
    restourentCartCubit = RestourentCartCubit(RestourentKartrepositoryy());
    restourentCartCubit.loadProducts(widget.restorent_id.toString());
    logError=="Your Login Session Expired"? null:  _fetchContacts();

    print("^^^^^^^^^^^^REST ID${widget.restorent_id}");

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Clean up the controller when the widget is removed
    datetimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("1A1B1D"),
      key: _key,
      endDrawer: const drowerAfterlogin(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocProvider(
              create: (context) => restourentCartCubit,
              child: BlocListener<RestourentCartCubit, RestourentCartState>(
                bloc: restourentCartCubit,
                listener: (context, state) {
                  if (state is RestourentCartInitial) {}
                  if (state is RestourentCartLoading) {
                    isloading = state.isloading;
                  } else if (state is RestourentCartSuccess) {
                    cart = state.cart;
                    setState(() {
                      heght = 40 * cart!.length.toDouble();
                    });
                    sutotal = state.sutotal;
                    total = state.total;
                    transactionfee = state.transactionfee;
                    vat21 = state.vat21;
                    vat9 = state.vat9;
                  } else if(state is RestourentCartFailed){

                    if(state.error.toString()=="Your Login Session Expired") {

                      logError= state.error;

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
                          pageBuilder: (c, a1, a2) => const LoginScreen(),
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
                    }else {

                      Utils.showDialouge(
                          context, AlertType.error, "Oops!", state.error);
                    }

                }  else if (state is RestourentCartdeletSuccess) {
                    print("*********STATE****CART***COUNT*****${cart!.length}");
                    BlocProvider.of<RestourentCartCubit>(context)
                        .loadProducts(widget.restorent_id.toString());
                    // isloading=false;
                  }
                  if (state is Paymentinitial) {}
                  if (state is PaymentLoading) {
                  } else if (state is PaymentSuccesS) {
                    // Fluttertoast.showToast(
                    //     msg: "Initial Payment success",
                    //     backgroundColor: Colors.green,
                    //     textColor: Colors.white);

                    //url= state.url;
                    // Navigator.pushReplacement(
                    //   context,
                    //   PageTransition(
                    //       duration: Duration(milliseconds: 500),
                    //       type: PageTransitionType.rightToLeft,
                    //       child: PayMent(url: url.toString(),restaurantId: widget.restorent_id,),
                    //       inheritTheme: true,
                    //       ctx: context),
                    // );
                  } else if (state is PaymentFail) {
                    Utils.showDialouge(
                        context, AlertType.error, "Oops!", state.error);
                  }
                },
                child: BlocBuilder<RestourentCartCubit, RestourentCartState>(
                    builder: (context, state) {
                  return isloading == false
                      ? cartForm()
                      : Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: CupertinoActivityIndicator(
                              radius: 10,
                            ),
                          ),
                        );
                }),
              )),
        ),
      ),
    );
  }

  Widget cartForm() {
    // List<Widget> _contatos = new List.generate(_count, (int i) => _body());
    if (cart!.length == 0) {
      return CartEmpty(context);
    } else {
      return Container(
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 10, top: 40),
                            child: myAppBarIcon()),
                      ],
                    ),
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
                            margin: const EdgeInsets.only(right: 20, top: 40),
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
                margin: const EdgeInsets.only(left: 20, top: 30),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => PlaceOrder(
                              restouretId: widget.restorent_id,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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

                        // Navigator.pushReplacement(
                        //   context,
                        //   PageTransition(
                        //       duration: Duration(milliseconds: 500),
                        //       type: PageTransitionType.leftToRight,
                        //       child: PlaceOrder(
                        //         restouretId: widget.restorent_id,
                        //       ),
                        //       inheritTheme: true,
                        //       ctx: context),
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 6),
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white, width: 2)),
                        margin: const EdgeInsets.only(right: 0, top: 0),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CheersClubText(
                      text: AppLocalizations.of(context).translate("mycart"),
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CheersClubText(
                            text: "${"(${cart!.length}" +
                                " " +
                                AppLocalizations.of(context)
                                    .translate("items")})",
                            fontColor: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          )
                        ],
                      ),
                    )
                  ],
                )),

            //beginig of kart
            Container(
              color: HexColor("5D5D5E"),
              height: 40,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          CheersClubText(
                              text:
                                  """${AppLocalizations.of(context).translate("des")}""",
                              alignment: TextAlign.justify,
                              fontColor: Colors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                          CheersClubText(
                              text:
                                  AppLocalizations.of(context).translate("qty"),
                              fontColor: Colors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                          CheersClubText(
                              text: AppLocalizations.of(context)
                                  .translate("PRICE"),
                              fontColor: Colors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                          CheersClubText(
                              text: AppLocalizations.of(context)
                                  .translate("remove"),
                              fontColor: Colors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //kart description
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart?.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Table(
                      border: TableBorder(
                        bottom:
                            BorderSide(color: Colors.grey.shade800, width: 0.5),
                      ),
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 15, top: 15),
                            child: CheersClubText(
                                text: """${cart?[index].name ?? ""}""",
                                alignment: TextAlign.justify,
                                fontColor: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 15, top: 15),
                            child: CheersClubText(
                                text: "${cart?[index].quantity ?? " "}" +
                                    "  ${cart?[index].orderType ?? "   "}",
                                fontColor: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 15, top: 15),
                            child: CheersClubText(
                                text: cart?[index]
                                        .itemPrice!
                                        .toStringAsFixed(2)
                                        .toString() ??
                                    "",
                                fontColor: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15, top: 15),
                            child: GestureDetector(
                              // ontaping the 'remove' txt this popup comes
                              onTap: () async {
                                await showDialog(
                                  builder: (ctxt) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.white70, width: 1),
                                        borderRadius: BorderRadius.circular(18),
                                      ),

                                      title: Text(
                                        AppLocalizations.of(context)
                                            .translate("removeitem"),
                                        style: const TextStyle(
                                            color: Colors.amber,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                        AppLocalizations.of(context)
                                            .translate("rusywri"),
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
                                                AppLocalizations.of(context)
                                                    .translate("n"),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            // YES button
                                            IconButton(
                                              icon: Text(
                                                AppLocalizations.of(context)
                                                    .translate("y"),
                                                style: const TextStyle(
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              onPressed: () {
                                                BlocProvider.of<
                                                            RestourentCartCubit>(
                                                        context)
                                                    .deleteproduct(cart?[index]
                                                        .id
                                                        .toString());
                                                print(
                                                    "*********REMOVING****CART***COUNT*****${cart!.length}");

                                                Navigator.pop(context);
                                              },
                                            ),
                                            const SizedBox(
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
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: HexColor("FFC853"),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  );
                },
              ),
            ),

            Container(
//                  color: HexColor("5D5D5E"),
              height: 40,
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(top: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CheersClubText(
                    text: AppLocalizations.of(context).translate("tfee"),
                    fontColor: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/euro.png",
                          height: 10,
                          width: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        CheersClubText(
                            text: transactionfee.toStringAsFixed(2).toString(),
                            fontColor: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ],
                    ),
                  )
                ],
              ),
            ),

            Container(
//                  color: HexColor("5D5D5E"),
              height: 40,
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(top: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CheersClubText(
                      text: AppLocalizations.of(context).translate("stotal"),
                      fontColor: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  const Expanded(child: SizedBox()),
                  Container(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/euro.png",
                          height: 10,
                          width: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        CheersClubText(
                            text: sutotal.toStringAsFixed(2).toString(),
                            fontColor: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ],
                    ),
                  )
                ],
              ),
            ),

            vat21 == null
                ? Container()
                : Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    margin: const EdgeInsets.only(top: 0, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CheersClubText(
                            text:
                                AppLocalizations.of(context).translate("vat21"),
                            fontColor: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        const Expanded(child: SizedBox()),
                        Container(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/euro.png",
                                height: 10,
                                width: 10,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              CheersClubText(
                                text: vat21.toStringAsFixed(2).toString(),
                                fontColor: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

            vat9 == null
                ? Container()
                : Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    margin: const EdgeInsets.only(top: 0, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CheersClubText(
                            text:
                                AppLocalizations.of(context).translate("vat9"),
                            fontColor: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        const Expanded(child: SizedBox()),
                        Container(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/euro.png",
                                height: 10,
                                width: 10,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              CheersClubText(
                                text: vat9.toStringAsFixed(2).toString(),
                                fontColor: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

            Container(
              // color: HexColor("5D5D5E"),
              height: 40,
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(top: 0, bottom: 0),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.white,
                width: 0.5,
              ))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CheersClubText(
                      text: AppLocalizations.of(context).translate("total"),
                      fontColor: Colors.amber,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  const Expanded(child: SizedBox()),
                  Container(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/euro.png",
                          height: 10,
                          width: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        CheersClubText(
                            text: total.toStringAsFixed(2).toString(),
                            fontColor: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              width: MediaQuery.of(context).size.width - 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CheersClubText(
                    text: AppLocalizations.of(context)
                        .translate("Whomtosurprise"),
                    fontColor: Colors.amber,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  )
                ],
              ),
            ),

            //Recipientent name
            Container(
              margin: const EdgeInsets.only(left: 20, right: 220, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("recipientname"),
                fontColor: Colors.white,
                fontSize: 11,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
              child: TextFormField(
                keyboardType: TextInputType.name,
                style: const TextStyle(color: Colors.white),
                controller: recipientent_name_Controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
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

            //Order type
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              width: MediaQuery.of(context).size.width - 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CheersClubText(
                    text: AppLocalizations.of(context).translate("ordertype"),
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 30, top: 0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 0, top: 0),
                    child: CheersClubText(
                      text: AppLocalizations.of(context).translate("instant"),
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    checkColor: Colors.black,
                    value: this.value,
                    onChanged: (bool? value) {
                      setState(() {
                        this._selectedtype = false;
                        this.value = value!;
                        selectedtypevalue = "1";
                      });
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 0, top: 0),
                    child: CheersClubText(
                      text: AppLocalizations.of(context).translate("scheduled"),
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    checkColor: Colors.black,
                    value: this._selectedtype,
                    onChanged: (bool? value) {
                      setState(() {
                        this.value = false;
                        this._selectedtype = value!;
                        selectedtypevalue = "2";
                      });
                    },
                  ),
                ],
              ),
            ),

            Visibility(
              visible: _selectedtype,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //date picker
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 220, top: 20),
                      child: const CheersClubText(
                        text: "Delivery Date & Time",
                        fontColor: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
                      child: TextFormField(
                        controller: datetimeController,
                        readOnly: true,
                        onTap: () async {
                          DatePicker.showDateTimePicker(context, showTitleActions: true,
                              onConfirm: (date) {

                               log('confirm $date');
                                utcDatetime = date.toUtc();
                                datetimeController.text = DateFormat('yyyy-MM-dd – kk:mm a').format(date);
                                log('*************To UTC***********$utcDatetime');
                                log('************datetimeController.text***********${datetimeController.text}');

                              },
                            minTime: DateTime.now(),
                              currentTime: DateTime.now(),
                          theme: const DatePickerTheme(
                            cancelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,fontFamily: "Raleway"),
                          doneStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,fontFamily: "Raleway"),
                          headerColor: Colors.amber,
                          backgroundColor: Colors.black,
                          itemStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,fontFamily: "Raleway"),)

                          );


                          // var date = await showDatePicker(
                          //   context: context,
                          //   initialDate: DateTime.now(),
                          //   firstDate: DateTime.now().subtract(Duration(days: 0)),
                          //   lastDate: DateTime(DateTime.now().year + 100),
                          // );
                          //
                          // dateController.text = DateFormat.yMd().format(date!);
                          //
                          // localtoutcdate = date.toUtc();
                          //
                          // timezone = date.timeZoneName;
                          //
                          // offset = date.timeZoneOffset;
                          //
                          // date.timeZoneOffset.isNegative? checkofset = "-": checkofset ="+";
                          //
                          //
                          // log("*********dateController.text****** ${dateController.text}");
                          // log("*********localtoutcdate*********** $localtoutcdate");
                          // log("*********Timezone Name*********** $timezone");
                          // log("*********Timezone Offset*********** $offset");
                          // log("********* checkofset*********** $checkofset");


                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'yyyy-mm-dd – HH:mm',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14),
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

                    //time picker
                  /*  Container(
                      margin: EdgeInsets.only(left: 20, right: 220, top: 20),
                      child: CheersClubText(
                        text: AppLocalizations.of(context).translate("dt"),
                        fontColor: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 4),
                      child: TextFormField(
                        onTap: () async {
                          var time = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          timeController.text = time!.format(context);

                          localtoutctimehr = time.hour;
                          localtoutctimemin = time.minute;


                          log("*********timeController.text****** ${timeController.text}");
                          log("*********localtoutctimehr*********** $localtoutctimehr");
                          log("*********localtoutctimemin*********** $localtoutctimemin");

                        },
                        readOnly: true,
                        style: const TextStyle(color: Colors.white),
                        controller: timeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "--:-- --",
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14),
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
                    ),*/
                  ],
                ),
              ),
            ),

            // //Dial option
            // Container(
            //   margin:
            //   EdgeInsets.only(left: 20, right: 220, top: 20, bottom: 5),
            //   child: CheersClubText(
            //     text: AppLocalizations.of(context).translate("dc"),
            //     fontColor: Colors.white,
            //     fontSize: 11,
            //
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 20, right: 20,
            //   ),
            //   child: Container(
            //     color: HexColor("28292C"),
            //     child: DropdownButtonFormField<String>(
            //       decoration: InputDecoration(
            //         contentPadding: EdgeInsets.only(
            //           left: 10,
            //         ),
            //         border: InputBorder.none,
            //       ),
            //       dropdownColor: Colors.amber,
            //       isExpanded: true,
            //       focusColor: HexColor("28292C"),
            //       value: _chosenValue,
            //       //elevation: 5,
            //       style: TextStyle(color: Colors.black),
            //       iconEnabledColor: Colors.amber,
            //       items: _myJson.map((Map map) {
            //         return DropdownMenuItem<String>(
            //           value: map["dial_code"].toString(),
            //           child: CheersClubText(
            //               text: map["dial_code"] + " - " + map["name"],
            //               fontColor: map["dial_code"] == _chosenValue
            //                   ? Colors.white
            //                   : Colors.black,
            //               fontSize: 14,
            //               over: TextOverflow.ellipsis),
            //         );
            //       }).toList(),
            //       hint: CheersClubText(
            //         text: "+31-Netherlands",
            //         fontColor: Colors.white,
            //         fontSize: 14,
            //       ),
            //       onChanged: (String? value) {
            //         setState(() {
            //           _chosenValue = value;
            //           print(_chosenValue);
            //         });
            //       },
            //     ),
            //   ),
            // ),

            //Dial option

            Container(
              margin: const EdgeInsets.only(left: 20, right: 220, top: 20, bottom: 5),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("dc"),
                fontColor: Colors.white,
                fontSize: 11,
              ),
            ),

            /*   Padding(
            padding: const EdgeInsets.only(
              left: 20, right: 20,
            ),
            child: Container(
              color: HexColor("28292C"),
              child: DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                    showSearchBox: true,
                 // disabledItemFn: (String s) => s.startsWith('I'),
                ),
                items: ["Brazil", "Italia", "Tunisia", 'Canada',"+31-Netherlands"],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: "+31-Netherlands",
                    hintStyle: TextStyle(fontFamily: "",fontSize: 14,color:  Colors.white,)
                  ),
                ),
                onChanged: print,
                selectedItem: "+31-Netherlands",
              ),
            ),
          ),*/

            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Container(
                color: HexColor("28292C"),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButton2<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      dropdownWidth: 250,
                      dropdownMaxHeight: 250,
                      dropdownDecoration: const BoxDecoration(
                        color: Colors.amber,
                      ),
                      style: const TextStyle(color: Colors.black),
                      iconSize: 24,
                      dropdownElevation: 16,
                      isExpanded: true,
                      focusColor: HexColor("28292C"),
                      value: _chosenValue,
                      iconEnabledColor: Colors.amber,
                      items: _myJson.map((Map map) {
                        return DropdownMenuItem<String>(
                          value: map["dial_code"].toString(),
                          child: CheersClubText(
                              text: map["dial_code"] + " - " + map["name"],
                              fontColor: map["dial_code"] == _chosenValue
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                              over: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      hint: const CheersClubText(
                        text: "+31-Netherlands",
                        fontColor: Colors.white,
                        fontSize: 14,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _chosenValue = value;
                          print(_chosenValue);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

            //phone number
            Container(
              margin: const EdgeInsets.only(left: 20, right: 220, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("pno"),
                fontColor: Colors.white,
                fontSize: 11,
              ),
            ),

            //phone
            Column(
              children: [
                _body(_permissionDenied),
                Visibility(
                    visible: _visible,
                    child: Column(
                      children: [
                        _body1(_permissionDenied),
                        _body2(_permissionDenied),
                      ],
                    )),
              ],
            ),

            _visible == true
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _visible = true;
                              });
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                CheersClubText(
                                  text: AppLocalizations.of(context)
                                      .translate("addanotherno"),
                                  fontColor: Colors.white,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

            //Recipient message
            Container(
              margin: const EdgeInsets.only(left: 20, right: 220, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("recipientmsg"),
                fontColor: Colors.white,
                fontSize: 11,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: recipientent_message_Controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
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

            //file picker
            Container(
              margin: const EdgeInsets.only(left: 20, right: 220, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("i/v"),
                fontColor: Colors.white,
                fontSize: 11,
              ),
            ),

            Container(
              height: 40,
              color: HexColor("28292C"),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      selectFile();
                    },
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
                      height: 20,
                      child: Center(
                        child: CheersClubText(
                          text: AppLocalizations.of(context).translate("cfile"),
                          fontColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  Center(
                    child: file == null
                        ? CheersClubText(
                            text: AppLocalizations.of(context)
                                .translate("nofilec"),
                            fontColor: Colors.grey.shade600,
                            fontSize: 10,
                          )
                        : Container(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              file.toString(),
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 20,top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CheersClubText(
                    text: "File size limit : 100 MB",
                    fontColor: Colors.grey,
                    fontSize: 11,
                  ),
                ],
              ),
            ),

            //Request to Restourent
            Container(
              margin: const EdgeInsets.only(left: 20, right: 220, top: 20),
              child: CheersClubText(
                text: AppLocalizations.of(context).translate("rtor"),
                fontColor: Colors.white,
                fontSize: 11,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 4),
              child: TextFormField(
                controller: request_controller,
                style: const TextStyle(color: Colors.white),
                //controller: Password_Controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
                  filled: true,
                  fillColor: HexColor("28292C"),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
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
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 60, right: 190),
              child: Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("FFC853"),
                  ),
                  onPressed: () async {
                    if (recipientent_name_Controller.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)
                              .translate('Please fill recipient name field'),
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);
                    } else if (selectedtypevalue == "2" &&
                        utcDatetime==null) {
                      Fluttertoast.showToast(
                          msg: 'Please select a date and time',
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);
                    }  else if (selectedtypevalue == null) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)
                              .translate('Please select a order type'),
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);
                    } else if (noController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)
                              .translate('Please select a phone number'),
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);
                    } else if (noController.text.contains("+") ||
                        noController.text.length > 11) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context).translate(
                              'Please select without country code phone number'),
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);
                    } else if (no1Controller.text.contains("+") ||
                        no1Controller.text.length > 11) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context).translate(
                              'Please select without country code phone number'),
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);
                    } else if (no2Controller.text.contains("+") ||
                        no2Controller.text.length > 11) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context).translate(
                              'Please select without country code phone number'),
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);
                    } else if (recipientent_message_Controller.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)
                              .translate('Please fill recipient message'),
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);
                    } else if (sizeInMb > 100){

                      Fluttertoast.showToast(
                          msg: "Selected file too large,please select upto 100 MB",
                          backgroundColor: Colors.amber,
                          textColor: Colors.black);

                    }
                    else {
                      setState(() {
                        pisloading = true;
                      });
                      final order_id_val = await initialPaymentApi();

                      print("********ORDER ID*****ONTAP$order_id_val");

                      await Stripepaymentapi(order_id_val1: order_id_val);

                      //showProgressWithoutMsg(context);

                    }
                  },
                  child: pisloading == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CheersClubText(
                                text: AppLocalizations.of(context)
                                    .translate("pay"),
                                fontColor: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset(
                              "assets/images/euro.png",
                              height: 8,
                              width: 8,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            CheersClubText(
                                text: total.toStringAsFixed(2).toString(),
                                fontColor: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: Colors.black,
                                ))
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(
              height: 200,
            ),
          ],
        ),
      );
    }
  }

  final List<Map> _myJson = [
    {"name": "Afghanistan", "dial_code": "+93", "code": "AF"},
    {"name": "Aland Islands", "dial_code": "+358", "code": "AX"},
    {"name": "Albania", "dial_code": "+355", "code": "AL"},
    {"name": "Algeria", "dial_code": "+213", "code": "DZ"},
    {"name": "AmericanSamoa", "dial_code": "+1684", "code": "AS"},
    {"name": "Andorra", "dial_code": "+376", "code": "AD"},
    {"name": "Angola", "dial_code": "+244", "code": "AO"},
    {"name": "Anguilla", "dial_code": "+1264", "code": "AI"},
    {"name": "Antarctica", "dial_code": "+672", "code": "AQ"},
    {"name": "Antigua and Barbuda", "dial_code": "+1268", "code": "AG"},
    {"name": "Argentina", "dial_code": "+54", "code": "AR"},
    {"name": "Armenia", "dial_code": "+374", "code": "AM"},
    {"name": "Aruba", "dial_code": "+297", "code": "AW"},
    {"name": "Australia", "dial_code": "+61", "code": "AU"},
    {"name": "Austria", "dial_code": "+43", "code": "AT"},
    {"name": "Azerbaijan", "dial_code": "+994", "code": "AZ"},
    {"name": "Bahamas", "dial_code": "+1242", "code": "BS"},
    {"name": "Bahrain", "dial_code": "+973", "code": "BH"},
    {"name": "Bangladesh", "dial_code": "+880", "code": "BD"},
    {"name": "Barbados", "dial_code": "+1246", "code": "BB"},
    {"name": "Belarus", "dial_code": "+375", "code": "BY"},
    {"name": "Belgium", "dial_code": "+32", "code": "BE"},
    {"name": "Belize", "dial_code": "+501", "code": "BZ"},
    {"name": "Benin", "dial_code": "+229", "code": "BJ"},
    {"name": "Bermuda", "dial_code": "+1441", "code": "BM"},
    {"name": "Bhutan", "dial_code": "+975", "code": "BT"},
    {
      "name": "Bolivia, Plurinational State of bolivia",
      "dial_code": "+591",
      "code": "BO"
    },
    {"name": "Bosnia and Herzegovina", "dial_code": "+387", "code": "BA"},
    {"name": "Botswana", "dial_code": "+267", "code": "BW"},
    {"name": "Brazil", "dial_code": "+55", "code": "BR"},
    {
      "name": "British Indian Ocean Territory",
      "dial_code": "+246",
      "code": "IO"
    },
    {"name": "Brunei Darussalam", "dial_code": "+673", "code": "BN"},
    {"name": "Bulgaria", "dial_code": "+359", "code": "BG"},
    {"name": "Burkina Faso", "dial_code": "+226", "code": "BF"},
    {"name": "Burundi", "dial_code": "+257", "code": "BI"},
    {"name": "Cambodia", "dial_code": "+855", "code": "KH"},
    {"name": "Cameroon", "dial_code": "+237", "code": "CM"},
    {"name": "Canada", "dial_code": "+1", "code": "CA"},
    {"name": "Cape Verde", "dial_code": "+238", "code": "CV"},
    {"name": "Cayman Islands", "dial_code": "+ 345", "code": "KY"},
    {"name": "Central African Republic", "dial_code": "+236", "code": "CF"},
    {"name": "Chad", "dial_code": "+235", "code": "TD"},
    {"name": "Chile", "dial_code": "+56", "code": "CL"},
    {"name": "China", "dial_code": "+86", "code": "CN"},
    {"name": "Colombia", "dial_code": "+57", "code": "CO"},
    {"name": "Comoros", "dial_code": "+269", "code": "KM"},
    {"name": "Congo", "dial_code": "+242", "code": "CG"},
    {
      "name": "Congo, The Democratic Republic of the Congo",
      "dial_code": "+243",
      "code": "CD"
    },
    {"name": "Cook Islands", "dial_code": "+682", "code": "CK"},
    {"name": "Costa Rica", "dial_code": "+506", "code": "CR"},
    {"name": "Cote d'Ivoire", "dial_code": "+225", "code": "CI"},
    {"name": "Croatia", "dial_code": "+385", "code": "HR"},
    {"name": "Cuba", "dial_code": "+53", "code": "CU"},
    {"name": "Cyprus", "dial_code": "+357", "code": "CY"},
    {"name": "Czech Republic", "dial_code": "+420", "code": "CZ"},
    {"name": "Denmark", "dial_code": "+45", "code": "DK"},
    {"name": "Djibouti", "dial_code": "+253", "code": "DJ"},
    {"name": "Dominica", "dial_code": "+1767", "code": "DM"},
    {"name": "Dominican Republic", "dial_code": "+1849", "code": "DO"},
    {"name": "Ecuador", "dial_code": "+593", "code": "EC"},
    {"name": "Egypt", "dial_code": "+20", "code": "EG"},
    {"name": "El Salvador", "dial_code": "+503", "code": "SV"},
    {"name": "Equatorial Guinea", "dial_code": "+240", "code": "GQ"},
    {"name": "Eritrea", "dial_code": "+291", "code": "ER"},
    {"name": "Estonia", "dial_code": "+372", "code": "EE"},
    {"name": "Ethiopia", "dial_code": "+251", "code": "ET"},
    {"name": "Falkland Islands (Malvinas)", "dial_code": "+500", "code": "FK"},
    {"name": "Faroe Islands", "dial_code": "+298", "code": "FO"},
    {"name": "Fiji", "dial_code": "+679", "code": "FJ"},
    {"name": "Finland", "dial_code": "+358", "code": "FI"},
    {"name": "France", "dial_code": "+33", "code": "FR"},
    {"name": "French Guiana", "dial_code": "+594", "code": "GF"},
    {"name": "French Polynesia", "dial_code": "+689", "code": "PF"},
    {"name": "Gabon", "dial_code": "+241", "code": "GA"},
    {"name": "Gambia", "dial_code": "+220", "code": "GM"},
    {"name": "Georgia", "dial_code": "+995", "code": "GE"},
    {"name": "Germany", "dial_code": "+49", "code": "DE"},
    {"name": "Ghana", "dial_code": "+233", "code": "GH"},
    {"name": "Gibraltar", "dial_code": "+350", "code": "GI"},
    {"name": "Greece", "dial_code": "+30", "code": "GR"},
    {"name": "Greenland", "dial_code": "+299", "code": "GL"},
    {"name": "Grenada", "dial_code": "+1473", "code": "GD"},
    {"name": "Guadeloupe", "dial_code": "+590", "code": "GP"},
    {"name": "Guam", "dial_code": "+1671", "code": "GU"},
    {"name": "Guatemala", "dial_code": "+502", "code": "GT"},
    {"name": "Guernsey", "dial_code": "+44", "code": "GG"},
    {"name": "Guinea", "dial_code": "+224", "code": "GN"},
    {"name": "Guinea-Bissau", "dial_code": "+245", "code": "GW"},
    {"name": "Guyana", "dial_code": "+595", "code": "GY"},
    {"name": "Haiti", "dial_code": "+509", "code": "HT"},
    {
      "name": "Holy See (Vatican City State)",
      "dial_code": "+379",
      "code": "VA"
    },
    {"name": "Honduras", "dial_code": "+504", "code": "HN"},
    {"name": "Hong Kong", "dial_code": "+852", "code": "HK"},
    {"name": "Hungary", "dial_code": "+36", "code": "HU"},
    {"name": "Iceland", "dial_code": "+354", "code": "IS"},
    {"name": "India", "dial_code": "+91", "code": "IN"},
    {"name": "Indonesia", "dial_code": "+62", "code": "ID"},
    {
      "name": "Iran, Islamic Republic of Persian Gulf",
      "dial_code": "+98",
      "code": "IR"
    },
    {"name": "Iraq", "dial_code": "+964", "code": "IQ"},
    {"name": "Ireland", "dial_code": "+353", "code": "IE"},
    {"name": "Israel", "dial_code": "+972", "code": "IL"},
    {"name": "Italy", "dial_code": "+39", "code": "IT"},
    {"name": "Jamaica", "dial_code": "+1876", "code": "JM"},
    {"name": "Japan", "dial_code": "+81", "code": "JP"},
    {"name": "Jordan", "dial_code": "+962", "code": "JO"},
    {"name": "Kazakhstan", "dial_code": "+77", "code": "KZ"},
    {"name": "Kenya", "dial_code": "+254", "code": "KE"},
    {"name": "Kiribati", "dial_code": "+686", "code": "KI"},
    {
      "name": "Korea, Democratic People's Republic of Korea",
      "dial_code": "+850",
      "code": "KP"
    },
    {
      "name": "Korea, Republic of South Korea",
      "dial_code": "+82",
      "code": "KR"
    },
    {"name": "Kuwait", "dial_code": "+965", "code": "KW"},
    {"name": "Kyrgyzstan", "dial_code": "+996", "code": "KG"},
    {"name": "Laos", "dial_code": "+856", "code": "LA"},
    {"name": "Latvia", "dial_code": "+371", "code": "LV"},
    {"name": "Lebanon", "dial_code": "+961", "code": "LB"},
    {"name": "Lesotho", "dial_code": "+266", "code": "LS"},
    {"name": "Liberia", "dial_code": "+231", "code": "LR"},
    {"name": "Libyan Arab Jamahiriya", "dial_code": "+218", "code": "LY"},
    {"name": "Liechtenstein", "dial_code": "+423", "code": "LI"},
    {"name": "Lithuania", "dial_code": "+370", "code": "LT"},
    {"name": "Luxembourg", "dial_code": "+352", "code": "LU"},
    {"name": "Macao", "dial_code": "+853", "code": "MO"},
    {"name": "Macedonia", "dial_code": "+389", "code": "MK"},
    {"name": "Madagascar", "dial_code": "+261", "code": "MG"},
    {"name": "Malawi", "dial_code": "+265", "code": "MW"},
    {"name": "Malaysia", "dial_code": "+60", "code": "MY"},
    {"name": "Maldives", "dial_code": "+960", "code": "MV"},
    {"name": "Mali", "dial_code": "+223", "code": "ML"},
    {"name": "Malta", "dial_code": "+356", "code": "MT"},
    {"name": "Marshall Islands", "dial_code": "+692", "code": "MH"},
    {"name": "Martinique", "dial_code": "+596", "code": "MQ"},
    {"name": "Mauritania", "dial_code": "+222", "code": "MR"},
    {"name": "Mauritius", "dial_code": "+230", "code": "MU"},
    {"name": "Mayotte", "dial_code": "+262", "code": "YT"},
    {"name": "Mexico", "dial_code": "+52", "code": "MX"},
    {
      "name": "Micronesia, Federated States of Micronesia",
      "dial_code": "+691",
      "code": "FM"
    },
    {"name": "Moldova", "dial_code": "+373", "code": "MD"},
    {"name": "Monaco", "dial_code": "+377", "code": "MC"},
    {"name": "Mongolia", "dial_code": "+976", "code": "MN"},
    {"name": "Montenegro", "dial_code": "+382", "code": "ME"},
    {"name": "Montserrat", "dial_code": "+1664", "code": "MS"},
    {"name": "Morocco", "dial_code": "+212", "code": "MA"},
    {"name": "Mozambique", "dial_code": "+258", "code": "MZ"},
    {"name": "Myanmar", "dial_code": "+95", "code": "MM"},
    {"name": "Namibia", "dial_code": "+264", "code": "NA"},
    {"name": "Nauru", "dial_code": "+674", "code": "NR"},
    {"name": "Nepal", "dial_code": "+977", "code": "NP"},
    {"name": "Netherlands", "dial_code": "+31", "code": "NL"},
    {"name": "Netherlands Antilles", "dial_code": "+599", "code": "AN"},
    {"name": "New Caledonia", "dial_code": "+687", "code": "NC"},
    {"name": "New Zealand", "dial_code": "+64", "code": "NZ"},
    {"name": "Nicaragua", "dial_code": "+505", "code": "NI"},
    {"name": "Niger", "dial_code": "+227", "code": "NE"},
    {"name": "Nigeria", "dial_code": "+234", "code": "NG"},
    {"name": "Niue", "dial_code": "+683", "code": "NU"},
    {"name": "Norfolk Island", "dial_code": "+672", "code": "NF"},
    {"name": "Northern Mariana Islands", "dial_code": "+1670", "code": "MP"},
    {"name": "Norway", "dial_code": "+47", "code": "NO"},
    {"name": "Oman", "dial_code": "+968", "code": "OM"},
    {"name": "Pakistan", "dial_code": "+92", "code": "PK"},
    {"name": "Palau", "dial_code": "+680", "code": "PW"},
    {
      "name": "Palestinian Territory, Occupied",
      "dial_code": "+970",
      "code": "PS"
    },
    {"name": "Panama", "dial_code": "+507", "code": "PA"},
    {"name": "Papua New Guinea", "dial_code": "+675", "code": "PG"},
    {"name": "Paraguay", "dial_code": "+595", "code": "PY"},
    {"name": "Peru", "dial_code": "+51", "code": "PE"},
    {"name": "Philippines", "dial_code": "+63", "code": "PH"},
    {"name": "Pitcairn", "dial_code": "+872", "code": "PN"},
    {"name": "Poland", "dial_code": "+48", "code": "PL"},
    {"name": "Portugal", "dial_code": "+351", "code": "PT"},
    {"name": "Puerto Rico", "dial_code": "+1939", "code": "PR"},
    {"name": "Qatar", "dial_code": "+974", "code": "QA"},
    {"name": "Romania", "dial_code": "+40", "code": "RO"},
    {"name": "Russia", "dial_code": "+7", "code": "RU"},
    {"name": "Rwanda", "dial_code": "+250", "code": "RW"},
    {"name": "Reunion", "dial_code": "+262", "code": "RE"},
    {"name": "Saint Barthelemy", "dial_code": "+590", "code": "BL"},
    {
      "name": "Saint Helena, Ascension and Tristan Da Cunha",
      "dial_code": "+290",
      "code": "SH"
    },
    {"name": "Saint Kitts and Nevis", "dial_code": "+1869", "code": "KN"},
    {"name": "Saint Lucia", "dial_code": "+1758", "code": "LC"},
    {"name": "Saint Martin", "dial_code": "+590", "code": "MF"},
    {"name": "Saint Pierre and Miquelon", "dial_code": "+508", "code": "PM"},
    {
      "name": "Saint Vincent and the Grenadines",
      "dial_code": "+1784",
      "code": "VC"
    },
    {"name": "Samoa", "dial_code": "+685", "code": "WS"},
    {"name": "San Marino", "dial_code": "+378", "code": "SM"},
    {"name": "Sao Tome and Principe", "dial_code": "+239", "code": "ST"},
    {"name": "Saudi Arabia", "dial_code": "+966", "code": "SA"},
    {"name": "Senegal", "dial_code": "+221", "code": "SN"},
    {"name": "Serbia", "dial_code": "+381", "code": "RS"},
    {"name": "Seychelles", "dial_code": "+248", "code": "SC"},
    {"name": "Sierra Leone", "dial_code": "+232", "code": "SL"},
    {"name": "Singapore", "dial_code": "+65", "code": "SG"},
    {"name": "Slovakia", "dial_code": "+421", "code": "SK"},
    {"name": "Slovenia", "dial_code": "+386", "code": "SI"},
    {"name": "Solomon Islands", "dial_code": "+677", "code": "SB"},
    {"name": "Somalia", "dial_code": "+252", "code": "SO"},
    {"name": "South Africa", "dial_code": "+27", "code": "ZA"},
    {"name": "South Sudan", "dial_code": "+211", "code": "SS"},
    {"name": "Spain", "dial_code": "+34", "code": "ES"},
    {"name": "Sri Lanka", "dial_code": "+94", "code": "LK"},
    {"name": "Sudan", "dial_code": "+249", "code": "SD"},
    {"name": "Suriname", "dial_code": "+597", "code": "SR"},
    {"name": "Svalbard and Jan Mayen", "dial_code": "+47", "code": "SJ"},
    {"name": "Swaziland", "dial_code": "+268", "code": "SZ"},
    {"name": "Sweden", "dial_code": "+46", "code": "SE"},
    {"name": "Switzerland", "dial_code": "+41", "code": "CH"},
    {"name": "Syrian Arab Republic", "dial_code": "+963", "code": "SY"},
    {"name": "Taiwan", "dial_code": "+886", "code": "TW"},
    {"name": "Tajikistan", "dial_code": "+992", "code": "TJ"},
    {
      "name": "Tanzania, United Republic of Tanzania",
      "dial_code": "+255",
      "code": "TZ"
    },
    {"name": "Thailand", "dial_code": "+66", "code": "TH"},
    {"name": "Timor-Leste", "dial_code": "+670", "code": "TL"},
    {"name": "Togo", "dial_code": "+228", "code": "TG"},
    {"name": "Tokelau", "dial_code": "+690", "code": "TK"},
    {"name": "Tonga", "dial_code": "+676", "code": "TO"},
    {"name": "Trinidad and Tobago", "dial_code": "+1868", "code": "TT"},
    {"name": "Tunisia", "dial_code": "+216", "code": "TN"},
    {"name": "Turkey", "dial_code": "+90", "code": "TR"},
    {"name": "Turkmenistan", "dial_code": "+993", "code": "TM"},
    {"name": "Turks and Caicos Islands", "dial_code": "+1649", "code": "TC"},
    {"name": "Tuvalu", "dial_code": "+688", "code": "TV"},
    {"name": "Uganda", "dial_code": "+256", "code": "UG"},
    {"name": "Ukraine", "dial_code": "+380", "code": "UA"},
    {"name": "United Arab Emirates", "dial_code": "+971", "code": "AE"},
    {"name": "United States", "dial_code": "+1", "code": "US"},
    {"name": "Uruguay", "dial_code": "+598", "code": "UY"},
    {"name": "Uzbekistan", "dial_code": "+998", "code": "UZ"},
    {"name": "Vanuatu", "dial_code": "+678", "code": "VU"},
    {
      "name": "Venezuela, Bolivarian Republic of Venezuela",
      "dial_code": "+58",
      "code": "VE"
    },
    {"name": "Vietnam", "dial_code": "+84", "code": "VN"},
    {"name": "Virgin Islands, British", "dial_code": "+1284", "code": "VG"},
    {"name": "Virgin Islands, U.S.", "dial_code": "+1340", "code": "VI"},
    {"name": "Wallis and Futuna", "dial_code": "+681", "code": "WF"},
    {"name": "Yemen", "dial_code": "+967", "code": "YE"},
    {"name": "Zambia", "dial_code": "+260", "code": "ZM"},
    {"name": "Zimbabwe", "dial_code": "+263", "code": "ZW"}
  ];
}

Widget CartEmpty(BuildContext context) {
  return Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
          ),
          CheersClubText(
            text: AppLocalizations.of(context).translate("uce"),
            fontColor: Colors.white,
            fontSize: 17,
          ),
          const SizedBox(height: 5),
          CheersClubText(
            text: AppLocalizations.of(context).translate("aoin"),
            fontColor: Colors.grey.shade50,
            fontSize: 14,
          ),
          const SizedBox(height: 5),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.black,
                primary: Colors.amber,
              ),
              child: Container(
                margin: const EdgeInsets.all(10),
                child: CheersClubText(
                  text: AppLocalizations.of(context).translate("on"),
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => const RestourentList(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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

                // Navigator.pushReplacement(
                //   context,
                //   PageTransition(
                //       duration: Duration(milliseconds: 400),
                //       type: PageTransitionType.leftToRight,
                //       child: RestourentList(),
                //       inheritTheme: true,
                //       ctx: context),
                // );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
