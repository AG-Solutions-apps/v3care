import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonBgWidget extends StatelessWidget {
  final Widget child;

  const CommonBgWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            "assets/images/v3_bg.png",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        child,
      ],
    );
  }
}
