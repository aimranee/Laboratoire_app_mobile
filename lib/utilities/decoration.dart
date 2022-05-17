import 'package:laboratoire_app/utilities/color.dart';
import 'package:flutter/material.dart';

class IBoxDecoration {
  static upperBoxDecoration() {
    return BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)));
  }
}
