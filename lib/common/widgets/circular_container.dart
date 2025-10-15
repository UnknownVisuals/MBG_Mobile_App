import 'package:flutter/material.dart';

class REYCircularContainer extends StatelessWidget {
  const REYCircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.margin,
    this.radius = 400,
    this.padding = 0,
    this.child,
    required this.backgroundColor,
  });

  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
