import 'package:flutter/material.dart';

class FullWidthBox extends StatelessWidget {
  final double height;
  final Color color;
  final String text;
  final Widget? child;
  final double? width;
  FullWidthBox({
    this.height = 370.0,
    this.color = Colors.white,
    this.text = 'صفحه',
    this.child,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      height: height,
      color: color,
      child: child ??
          Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
    );
  }
}
