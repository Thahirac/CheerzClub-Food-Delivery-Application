// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CheersButton extends StatelessWidget {
  final Gradient? gradient;
  final double width;
  final double height;
  final Function? onPressed;
  final String? title;
  final Color? textColor;
  final double cornerRadius;
  const CheersButton({
    Key? key,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
    this.title,
    this.textColor,
    this.cornerRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500]!,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius))),
      child: InkWell(
          onTap: onPressed as void Function()?,
          child: Center(
            child: Text(title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontFamily: "Poppins Bold",
                )),
          )),
    );
  }
}
