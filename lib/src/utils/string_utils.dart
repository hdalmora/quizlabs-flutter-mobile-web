import 'dart:math';

import 'package:html_unescape/html_unescape_small.dart';

class StringUtils {

  static String enumName(String enumToString) {
    List<String> paths = enumToString.split(".");
    return paths[paths.length - 1];
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    return regex.hasMatch(value) || value.isEmpty;
  }

  static bool validateStringLength(String value) {
    return value.length > 5 || value.isEmpty;
  }

  static String escapeString(String value) {
    var unescape = new HtmlUnescape();
    return unescape.convert(value);
  }
}