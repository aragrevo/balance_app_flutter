import 'package:flutter/material.dart';

class CustomSpacer extends StatelessWidget {
  const CustomSpacer(this.height, {Key? key}) : super(key: key);

  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
