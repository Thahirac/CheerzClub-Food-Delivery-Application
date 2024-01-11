// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'CheersButton.dart';
import 'cheersclub_text.dart';

class VFuelAlertView extends StatelessWidget {
  final AlertType? alertType;
  final String? cancelButtonText, okButtonText, message, title;
  final Function? okButtonCallBack, cancelButtonCallBack;
  final BuildContext? alertContext;
  final Color? color;
  const VFuelAlertView(
      {Key? key,
      this.alertType,
      this.cancelButtonText = null,
      this.okButtonText,
      this.message,
      this.title,
      this.okButtonCallBack,
      this.cancelButtonCallBack,
      this.alertContext,
      this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                  height: 65,
                  width: 65,
                  child: Center(
                    child: imageName(),
                  ),
                  decoration: BoxDecoration(
                      color: imageBgColor(), shape: BoxShape.circle)),
              SizedBox(
                height: 15,
              ),
              CheersClubText(
                text: title,
                fontColor: iconColor(),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              CheersClubText(
                text: message,
                fontColor: Colors.black,
              ),
              SizedBox(
                height: 25,
              ),

              Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (cancelButtonText != null)
                            Expanded(
                                child: CheersButton(
                                    height: 40,
                                    title: cancelButtonText,
                                    onPressed: () {
                                      Navigator.pop(alertContext!);
                                      cancelButtonCallBack!();
                                    })),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: CheersButton(
                                  cornerRadius:
                                      cancelButtonText != null ? 0 : 5,
                                  height: 40,
                                  title: okButtonText,
                                  onPressed: () {
                                    Navigator.pop(alertContext!);
                                    okButtonCallBack;
                                  }))
                        ],
                      )))
            ],
          ),
        ));
  }

  Icon? imageName() {
    var icon;
    switch (alertType!) {
      case AlertType.error:
        icon = Icon(
          Icons.close,
          color: HexColor("FEC753"),
        );
        break;
      case AlertType.success:
        icon = Icon(
          Icons.check,
          color: Colors.white,
        );
        break;
      case AlertType.warning:
        icon = Icon(
          Icons.warning_amber_rounded,
          color: Colors.black,
          size: 45,
        );
        break;
    }
    return icon;
  }

  Color? imageBgColor() {
    var color;
    switch (alertType!) {
      case AlertType.error:
        color = Colors.red;
        break;
      case AlertType.success:
        color = Colors.green;
        break;
      case AlertType.warning:
        color = HexColor("FEC753");
        break;
    }
    return color;
  }

  Color? iconColor() {
    var color;
    switch (alertType!) {
      case AlertType.error:
        color = Colors.red;
        break;
      case AlertType.success:
        color = Colors.green;
        break;
      case AlertType.warning:
        color = Colors.amber;
        break;
    }
    return color;
  }
}

enum AlertType {
  error,
  success,
  warning,
}
