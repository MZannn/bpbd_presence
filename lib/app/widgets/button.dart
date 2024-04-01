import 'package:bpbd_presence/app/themes/color_constants.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final double height;
  final double width;
  const Button(
      {super.key,
      required this.onPressed,
      required this.child,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              100,
            ),
          ),
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}
