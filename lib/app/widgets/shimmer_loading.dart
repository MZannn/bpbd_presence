import 'package:bkd_presence/app/themes/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum ShimmerShape { circle, rectangle }

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    Key? key,
    this.height,
    this.width,
    this.shape = ShimmerShape.rectangle,
    this.radius = 24.0,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double radius;
  final ShimmerShape shape;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return shape == ShimmerShape.rectangle
        ? Shimmer.fromColors(
            baseColor: baseColor ?? ColorConstants.grey50,
            highlightColor: highlightColor ?? Colors.white,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          )
        : Shimmer.fromColors(
            baseColor: baseColor ?? ColorConstants.grey50,
            highlightColor: highlightColor ?? Colors.white,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: radius,
            ),
          );
  }
}
