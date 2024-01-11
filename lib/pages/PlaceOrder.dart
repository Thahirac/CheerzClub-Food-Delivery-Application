// ignore_for_file: file_names

import 'package:cheersclub/Utils/utils.dart';
import 'package:cheersclub/cubit/placeorder/place_order_cubit.dart';
import 'package:cheersclub/cubit/repository/PlaceOrderRepo.dart';
import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/models/Restourent/RestourentViewModel.dart';
import 'package:cheersclub/models/Restourent/products.dart';
import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:cheersclub/widgets/cheersclub_text.dart';
import 'package:cheersclub/widgets/drowers/drowers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import 'LoginScreen.dart';
import 'Restourents_list.dart';
import 'kartpage.dart';

class PlaceOrder extends StatefulWidget {
  final int? restouretId;


  const PlaceOrder({Key? key, this.restouretId,})
      : super(key: key);

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {

  bool _isloading=false;
  bool isPressed = false;
  bool value = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  String? _chosenValue;
  String? _chosenValue2 = "no data";
  String? _chosenValue3 = "no data";
  late PlaceOrderCubit placeOrderCubit;
  Restaurant? restaurant;
  List<MainCategories>? main_catogories = [];
  List<SubCategories>? subCategories_drks = [];
  List<SubCategories>? subCategories_snaks = [];
  List<SubCategories>? subCategories_deserts = [];
  List<Products>? products_list = [];

  List<int>? _selectedItems;
  var Count_Controller = TextEditingController();
  SubCategories? selecteddrink;
  SubCategories? selecteddrink2;
  SubCategories? selecteddrink3;
  SubCategories? mainselected;
  String? _radioValue; //Initial definition of radio button value
  String? choice;
  List<TextEditingController>? _controllers = [];
  bool value_bussiness = false;
  String? type = "";
  int? cart_count;
  int? cart_countt;
  var _selectedid;

  void radioButtonChanges(String? value) {
    setState(() {
      _radioValue = value!;
      switch (value) {
        case 'Glass':
          choice = value;
          break;
        case 'Bottle':
          choice = value;
          break;
        default:
          choice = null;
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

  String? restId;
  @override
  void initState() {
    _selectedItems = <int>[];
    placeOrderCubit = PlaceOrderCubit(GetOneRestourents());
    restId = widget.restouretId!.toString();

    // TODO: implement initState
    placeOrderCubit.SingleRestorentLoadingGet(widget.restouretId!);

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: drowerAfterlogin(),
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
          create: (context) => placeOrderCubit,
          child: BlocListener<PlaceOrderCubit, PlaceOrderState>(
            bloc: placeOrderCubit,
            listener: (context, state) {
              if (state is PlaceOrderInitial) {}
              if (state is PlaceOrderLoading) {
                /*
                Navigator.push(
                  context,
                  PageTransition(
                      duration: Duration(milliseconds: 1000),
                      type: PageTransitionType.rightToLeft,
                      child: Home(),
                      inheritTheme: true,
                      ctx: context),
                );
              */
              } else if (state is PlaceOrderSuccess) {
                //selectedDistrict = subCategories!.first;
                cart_count = state.cart_count;
                restaurant = state.restaurant;
                main_catogories = state.mainCategories;
                subCategories_drks = state.subCategories_drks;
                print(subCategories_drks!.length);
                print("*********");
                // selecteddrink = subCategories_drks!.first;
                subCategories_snaks = state.subCategories_snaks;
                subCategories_deserts = state.subCategories_deserts;
                //   Utils.showDialouge(context, AlertType.error, "Oops!", state.msg);
              } else if (state is PlaceOrderFail) {
                //   Utils.showDialouge(context, AlertType.error, "Oops!", state.msg);
              } else if (state is AddToKartLoading) {
                //   Utils.showDialouge(context, AlertType.error, "Oops!", state.msg);
              } else if (state is AddToKartSuccess) {
                //cart_countt =state.cart_countt;
                cart_countt = state.cart_countt;
                Utils.showDialouge(context, AlertType.success, "Wow!",
                    AppLocalizations.of(context).translate("Added item successfully"), okButtonCallBack: () {
                  setState(() {});
                });

                setState(() {
                  _isloading=false;
                });

              } else if (state is AddToKartFail) {

                if(state.error.toString()=="Your Login Session Expired") {


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
                }else {

                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.error);
                }


                setState(() {
                  _isloading=false;
                });

              } else if (state is productLoading) {
                //  Utils.showDialouge(
                //      context, AlertType.error, "Oops!", state.error);
              } else if (state is productSuccess) {
                products_list = state.products_list;
              } else if (state is productFail) {
                Utils.showDialouge(
                    context, AlertType.error, "No Products Yet", state.error);
              }
            },
            child: BlocBuilder<PlaceOrderCubit, PlaceOrderState>(
                builder: (context, state) {
              // print("gjgfjhfjf" + cart_count.toString());
              if (state is PlaceOrderInitial) {
                return Container();
              }
              if (state is PlaceOrderLoading) {
                return  Container(
                  color: HexColor("1A1B1D"),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: CupertinoActivityIndicator(radius: 10,),
                  ),
                );
              } else if (state is PlaceOrderSuccess) {
                return kartForm();
              } else if (state is PlaceOrderFail) {
                return kartForm();
              } else if (state is AddToKartLoading) {
                return kartForm();
              } else if (state is AddToKartSuccess) {
                return kartForm();
              } else if (state is AddToKartFail) {
                return kartForm();
              } else if (state is productLoading) {
                return kartForm();
              } else if (state is productSuccess) {
                return kartForm();
              } else if (state is productFail) {
                return kartForm();
              } else {
                return kartForm();
              }
            }),
          )),
    );
  }

  Widget myAppBarIcon() {
    return  Container(
      width: 30,
      height: 30,
      child: Stack(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 26,
          ),
          Container(
            width: 27,
            height: 30,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 0),
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
                          "${cart_countt??cart_count}",
                          style: TextStyle(fontSize: 8,color: Colors.black),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget kartForm() {
    return Container(
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
                        Container(
                            margin: EdgeInsets.only(right: 10, top: 40),
                            child: GestureDetector(
                                onTap: () async{
                                 await Navigator.push(
                                    context,
                                    PageTransition(
                                        duration: Duration(milliseconds: 500),
                                        type: PageTransitionType.rightToLeft,
                                        child: Restourentcart(
                                          restorent_id: widget.restouretId,
                                        ),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                  setState(() {

                                  });
                                },
                                child: myAppBarIcon())),
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
              margin: EdgeInsets.only(left: 30, top: 20, bottom: 20),
              child: CheersClubText(
                text: restaurant!.name??"",
                fontColor: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 18,
                    color: Colors.amber,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8, top: 0, bottom: 20),
                  child: CheersClubText(
                    alignment: TextAlign.left,
                    text: "${restaurant?.address ?? ""}" +
                        "\n" +
                        "${restaurant?.city?? ""} " +
                        "${restaurant?.country ?? ""}" "\n" +
                        "E: ${restaurant?.email ?? ""}" "\n" +
                        "${restaurant?.profilePhotoUrl ?? " "}",
                    fontColor: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),






            Container(
              padding: EdgeInsets.all(4),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //     height: 43,
                  //     width: 120,
                  //     margin: EdgeInsets.all(0),
                  //     padding: EdgeInsets.only(left: 4),
                  //     color: HexColor("FEC753"),
                  //     child: DropdownButtonFormField<SubCategories>(
                  //       decoration:
                  //           InputDecoration(enabledBorder: InputBorder.none,),
                  //       icon: const Icon(Icons.arrow_drop_down),
                  //       dropdownColor: Colors.amber,
                  //       style: TextStyle(color: Colors.black),
                  //       iconEnabledColor: Colors.black,
                  //       iconSize: 24,
                  //       elevation: 16,
                  //       hint: CheersClubText(
                  //         text: AppLocalizations.of(context).translate("drinks"),
                  //         fontColor: Colors.black,
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 10,
                  //       ),
                  //       value: selecteddrink,
                  //       // style: VFuelStyles.formTextStyle(),
                  //       onChanged: (value) {
                  //
                  //         setState(() {
                  //           selecteddrink2=null;
                  //           selecteddrink3=null;
                  //           selecteddrink = value;
                  //           mainselected=value;
                  //         });
                  //
                  //
                  //         placeOrderCubit.loadProducts(
                  //             restId, "${selecteddrink!.id}");
                  //       },
                  //       items: subCategories_drks
                  //           ?.map<DropdownMenuItem<SubCategories>>(
                  //               (SubCategories value) {
                  //         return DropdownMenuItem<SubCategories>(
                  //           value: value,
                  //           child: CheersClubText(text:value.name!,
                  //               fontColor: value.name! == selecteddrink
                  //                   ? Colors.white
                  //                   : Colors.black,
                  //               fontSize: 14,
                  //               fontWeight: FontWeight.w600,
                  //               over: TextOverflow.ellipsis),
                  //         );
                  //       }).toList(),
                  //     )),
                  // subCategories_drks!.isEmpty? Container():
                  Container(
                    height: 43,
                    width: 120,
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.only(left: 4),
                    //color: HexColor("FEC753"),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<SubCategories>(

                        icon: const Icon(Icons.arrow_drop_down),
                        dropdownWidth: 150,
                        dropdownMaxHeight: 350,
                        dropdownDecoration: BoxDecoration(color: Colors.black,),
                        style: TextStyle(color: Colors.black),
                        iconEnabledColor: Colors.amber,
                        iconSize: 24,
                        dropdownElevation: 16,
                        hint: CheersClubText(
                          text: AppLocalizations.of(context).translate("drinks"),
                          fontColor: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                        value: selecteddrink,
                        // style: VFuelStyles.formTextStyle(),
                        onChanged: (value) {

                          setState(() {
                            selecteddrink2=null;
                            selecteddrink3=null;
                            selecteddrink = value;
                            mainselected=value;
                          });


                          placeOrderCubit.loadProducts(
                              restId, "${selecteddrink!.id}");
                        },
                        items: subCategories_drks
                            ?.map<DropdownMenuItem<SubCategories>>(
                                (SubCategories value) {
                              return DropdownMenuItem<SubCategories>(
                                value: value,
                                child: CheersClubText(text:value.name,
                                    fontColor: value.name == selecteddrink
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    over: TextOverflow.ellipsis),
                              );
                            }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(width: 10,),



                  // subCategories_snaks!.isEmpty? Container():
                  Container(
                    height: 43,
                    width: 120,
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.only(left: 4),
                    //color: HexColor("FEC753"),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<SubCategories>(

                        icon: const Icon(Icons.arrow_drop_down),
                        dropdownWidth: 150,
                        dropdownMaxHeight: 350,
                        dropdownDecoration: BoxDecoration(color: Colors.black,),
                        style: TextStyle(color: Colors.black),
                        iconEnabledColor: Colors.amber,
                        iconSize: 24,
                        dropdownElevation: 16,
                        hint: CheersClubText(
                          text: AppLocalizations.of(context).translate("desserts"),
                          fontColor: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                        value: selecteddrink2,

                        // style: VFuelStyles.formTextStyle(),
                        onChanged: (value) {

                          setState(() {
                            selecteddrink=null;
                            selecteddrink3=null;
                            selecteddrink2 = value;
                            mainselected=value;
                          });

                          placeOrderCubit.loadProducts(
                              restId, "${selecteddrink2!.id}");
                        },
                        items: subCategories_snaks
                            ?.map<DropdownMenuItem<SubCategories>>(
                                (SubCategories value) {
                              return DropdownMenuItem<SubCategories>(
                                value: value,
                                child: CheersClubText(text:value.name!,
                                    fontColor: value.name! == selecteddrink2
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    over: TextOverflow.ellipsis),
                              );
                            }).toList(),
                      ),
                    ),
                  ),


                  SizedBox(width: 10,),

                  // subCategories_deserts!.isEmpty? Container():
                  Container(
                    height: 43,
                    width: 120,
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.only(left: 4),
                    //color: HexColor("FEC753"),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<SubCategories>(

                        icon: const Icon(Icons.arrow_drop_down),
                        dropdownWidth: 150,
                        dropdownMaxHeight: 350,
                        dropdownDecoration: BoxDecoration(color: Colors.black,),
                        style: TextStyle(color: Colors.black),
                        iconEnabledColor: Colors.amber,
                        iconSize: 24,
                        dropdownElevation: 16,
                        hint: CheersClubText(
                          text: AppLocalizations.of(context).translate("bites"),
                          fontColor: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                        value: selecteddrink3,
                        // style: VFuelStyles.formTextStyle(),
                        onChanged: (value) {
                          setState(() {
                            selecteddrink=null;
                            selecteddrink2=null;
                            selecteddrink3 = value;
                            mainselected=value;
                          });


                          placeOrderCubit.loadProducts(restId, "${selecteddrink3!.id}");
                        },
                        items: subCategories_deserts
                            ?.map<DropdownMenuItem<SubCategories>>(
                                (SubCategories value) {
                              return DropdownMenuItem<SubCategories>(
                                value: value,
                                child: CheersClubText(text:value.name!,
                                    fontColor: value.name! == selecteddrink3
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    over: TextOverflow.ellipsis),
                              );
                            }).toList(),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Container(
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      // selecteddrink3?.name != null
                      //     ? "${selecteddrink3?.name}"
                      //     : selecteddrink2?.name != null
                      //     ? "${selecteddrink2?.name}"
                      //     : selecteddrink?.name != null
                      //     ? "${selecteddrink?.name}" // and so on
                      //     : " "

                      CheersClubText(
                        text:  mainselected?.name?.toUpperCase()??"",
                        fontColor: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              child: Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: products_list?.length,
                      itemBuilder: (context, index) {
                        _controllers?.add(new TextEditingController());
                        //  print(products_list?.length);
                        if (products_list?.length != 0) {
                          return GestureDetector(
                            onTap: () {
                              /*
                          Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 1000),
                                type: PageTransitionType.rightToLeft,
                                child: kartpage(),
                                inheritTheme: true,
                                ctx: context),
                          );
                             */
                              if (!_selectedItems!.contains(index)) {
                                setState(() {
                                  _selectedItems!.clear();
                                  _selectedItems!.add(index);
                                });
                              } else {
                                setState(() {
                                  _selectedItems!
                                      .removeWhere((val) => val == index);
                                });
                              }
                            },
                            child: Container(
                              //height: _selectedItems!.contains(index) ? 400: 250,
                              margin: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width - 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 80,
                                          child: CheersClubText(
                                            text: products_list?[index].name??"",
                                            fontColor: HexColor("FFC853"),
                                            fontSize: 12,
                                          ),
                                        ),
                                        Container(
                                          width: 130,
                                          child: CheersClubText(
                                            text: products_list?[index]
                                                .description??"",
                                            alignment: TextAlign.center,
                                            fontColor: Colors.white,
                                            fontSize: 9,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        for (int i = 0;
                                            i <
                                                products_list![index]
                                                    .priceCategories!
                                                    .length;
                                            i++)
                                          Expanded(
                                            child: Container(
                                              constraints:
                                                  BoxConstraints(maxWidth: 49),
                                              child: CheersClubText(
                                                text:
                                                    '${products_list?[index].priceCategories?[i]['name'] ?? " "} : ${products_list?[index].priceCategories?[i]['price'] ?? " "}    ',
                                                alignment: TextAlign.center,
                                                fontColor: Colors.white,
                                                fontSize: 11,
                                                over: TextOverflow.fade,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _selectedItems!.contains(index) ? true : false,
                                    child: Container(
                                      //height: 300,
                                      margin: const EdgeInsets.only(left: 20, right: 30, top: 0),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 5,),

                                          ///Type selection

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[

                                              for (int i = 0; i < products_list![index].priceCategories!.length; i++)

                                                products_list?[index].priceCategories?[0]['name'] == null
                                                    ? Container()
                                                    : Row(
                                                        children: [
                                                          Theme(
                                                            data: ThemeData(
                                                                unselectedWidgetColor:
                                                                    Colors
                                                                        .white),
                                                            child: Radio<int>(
                                                                activeColor:
                                                                    Colors.amber,
                                                                value: products_list![index].priceCategories?[i]['id'],
                                                                groupValue: _selectedid !=null? _selectedid:products_list![index].priceCategories?[0]['id'],
                                                                onChanged:
                                                                    (value) {
                                                                  print("**selected****value***" + value.toString());
                                                                  setState(() {
                                                                    _selectedid = value!;
                                                                  });
                                                                }),
                                                          ),
                                                          Text(
                                                              '${products_list?[index].priceCategories?[i]['name'] ?? " "}'),
                                                        ],
                                                      ),
                                            ],
                                          ),

                                          const SizedBox(height: 5,),

                                          //
                                          // Checkbox(
                                          //   activeColor: HexColor("FEC753"),
                                          //   side: BorderSide(
                                          //       color: Colors.amber),
                                          //   checkColor: Colors.white,
                                          //   value: this.value,
                                          //   onChanged: (bool? value) {
                                          //     setState(() {
                                          //       type = "Glass";
                                          //       this.value_bussiness =
                                          //           false;
                                          //       this.value = value!;
                                          //     });
                                          //   },
                                          // ),
                                          // Container(
                                          //   margin: EdgeInsets.only(
                                          //       left: 0, top: 0),
                                          //   child:  CheersClubText(
                                          //     text:"Glass",
                                          //     fontColor: Colors.white,
                                          //     fontWeight: FontWeight.w600,
                                          //     fontSize: 11,
                                          //   ),
                                          // ),
                                          // Checkbox(
                                          //   activeColor: HexColor("FEC753"),
                                          //   side: BorderSide(
                                          //       color: Colors.amber),
                                          //   checkColor: Colors.white,
                                          //   value: this.value_bussiness,
                                          //   onChanged: (bool? value) {
                                          //     setState(() {
                                          //       type = "Bottle";
                                          //       this.value = false;
                                          //       this.value_bussiness =
                                          //           value!;
                                          //     });
                                          //   },
                                          // ),
                                          // Container(
                                          //   margin: EdgeInsets.only(
                                          //       left: 0, top: 0),
                                          //   child: const CheersClubText(
                                          //     text: "Bottle",
                                          //     fontColor: Colors.white,
                                          //     fontWeight: FontWeight.w600,
                                          //     fontSize: 11,
                                          //   ),
                                          // ),

                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 34,
                                                width: 65,
                                                margin: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 0,
                                                  bottom: 20,
                                                ),
                                                child: TextFormField(
                                                  keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
                                                  inputFormatters:  [FilteringTextInputFormatter.digitsOnly],
                                                  textInputAction: TextInputAction.done,
                                                 // keyboardType: TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  //maxLength: 4,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  controller:
                                                      _controllers?[index],
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: AppLocalizations.of(context).translate("count"),
                                                    hintStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                    filled: true,
                                                    fillColor:
                                                        HexColor("28292C"),
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 2.0,
                                                            bottom: 6.0,
                                                            top: 8.0),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors
                                                              .amberAccent),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                ),

                                              ),
                                              InkWell(
                                                highlightColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onHighlightChanged: (param){
                                                  setState((){
                                                    isPressed = param;
                                                  });
                                                },
                                                onTap: () {


                                                  if(_controllers![index].text.isNotEmpty){

                                                    setState(() {
                                                      _isloading = true;
                                                    });



                                                    placeOrderCubit.AddToKaert(
                                                      products_list?[index].id.toString(), _controllers?[index].text,
                                                      _selectedid==null?'${products_list?[index].priceCategories?[0]['id']}':
                                                      _selectedid.toString(),
                                                      //'${products_list?[index].priceCategories?[0]['id'] ?? " "}',
                                                      //type
                                                      // products_list?[index].priceCategories.toString(),
                                                    );

                                                    _controllers?[index].clear();
                                                  }
                                                  else{


                                                    Utils.showDialouge(
                                                        context, AlertType.error, "Oops!", "Invalid quantity");

                                                  }




                                                },
                                                child: Container(
                                                  width: 120,
                                                  height: 34,
                                                  color: isPressed ? Colors.grey : HexColor("FEC753"),
                                                  margin: EdgeInsets.only(
                                                      left: 10,
                                                      top: 0,
                                                      bottom: 20),
                                                  child: Center(
                                                    child: _isloading? Padding(padding: EdgeInsets.all(10.0), child: const SizedBox(
                                                        height: 15,
                                                        width: 15,
                                                        child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),):CheersClubText(
                                                      text: AppLocalizations.of(context).translate("addtocart"),
                                                      fontColor: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Padding(
                                              //   padding: const EdgeInsets.only(left: 10, top: 0, bottom: 20),
                                              //   child:  ElevatedButton(
                                              //       style: ElevatedButton.styleFrom(
                                              //         primary: HexColor("FEC753"), // background
                                              //         onPrimary: Colors.black, // foreground
                                              //       ),
                                              //       child: Container(
                                              //         height:  34,
                                              //         child: const Center(
                                              //           child: CheersClubText(
                                              //             text: "Add to Kart",
                                              //             fontColor: Colors.black,
                                              //             fontWeight: FontWeight.w600,
                                              //             fontSize: 12,
                                              //           ),
                                              //         ),
                                              //       ),
                                              //       onPressed: () {
                                              //
                                              //       }
                                              //
                                              //   ),
                                              // ),
                                            ],
                                          ),

                                          SizedBox(height: 100,)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      })),
            ),


            SizedBox(height: 10,),


            InkWell(
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  PageTransition(
                      duration: Duration(milliseconds: 500),
                      type: PageTransitionType.leftToRight,
                      child: RestourentList(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 6),
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white, width: 2)),
                margin: EdgeInsets.only(right: 0, top: 0, left: 20),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35,),
          ],
        ),
      ),
    );
  }
}
