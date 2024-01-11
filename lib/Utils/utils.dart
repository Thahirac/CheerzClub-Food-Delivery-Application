import 'package:cheersclub/widgets/CheersAlert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
/*
  static List<District> districtsFromJson(List<dynamic> list) {
    List<District> districts = list.map<District>((item) {
      return District.fromJson(item);
    }).toList();
    return districts;
  }

  static List<DeliveryAddress> addressFromJson(List<dynamic> list) {
    List<DeliveryAddress> addresses = list.map<DeliveryAddress>((item) {
      return DeliveryAddress.fromJson(item);
    }).toList();
    return addresses;
  }

  static showLoadingIndicator(BuildContext context) {
    Spinner().showAlertDialog(context);
  }

  static dismissLoadingIndicator(BuildContext context) {
    Navigator.pop(context);
  }
*/
  static showDialouge(
      BuildContext context, AlertType alertType, String title, String? message,
      {Function? okButtonCallBack,
      Function? cancelButtonCallBack,
      String okButtonText = "OK",
      String? cancelButtonText = null}) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return VFuelAlertView(
            color: Colors.white,
            alertType: alertType,
            message: message,
            title: title,
            cancelButtonCallBack: cancelButtonCallBack,
            okButtonCallBack: okButtonCallBack,
            cancelButtonText: cancelButtonText,
            okButtonText: okButtonText,
            alertContext: context,
          );
        });
  }

/*
  // static showDialougeWithAction(
  //     BuildContext context, String title, String message, Function okAction) {
  //   showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: vfuelText(
  //             text: title,
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //           content: vfuelText(
  //             text: message,
  //             fontSize: 16,
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('Cancel'),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 okAction();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       });

 */
  static String getDateString(DateTime dateTime) {
    DateFormat format = DateFormat('dd-MM-yyyy');
    String formattedDate = format.format(dateTime);
    return formattedDate;
  }
}
