import 'package:flutter/material.dart';

class BasicResponse {

  bool success;
  String message;

  BasicResponse({
    @required this.success,
    @required this.message,
  });
}