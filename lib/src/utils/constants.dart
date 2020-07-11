import 'package:flutter/material.dart';

class Constants {
  static double mediaHeight(context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return MediaQuery.of(context).size.height - statusBarHeight;
  }

  static double mediaWidth(context) {
    return MediaQuery.of(context).size.width;
  }
}