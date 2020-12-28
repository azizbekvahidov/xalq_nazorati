library xalq_nazorati.globals;

import 'dart:io';

import 'package:flutter/material.dart';

String token = null;
String lang = null;
String country = null;
String api_link = "https://new.xalqnazorati.uz/ru/api";
String site_link = "https://new.xalqnazorati.uz";
Map<String, dynamic> userData;
String font = "Raleway";
Color activeButtonColor = Color(0xff00AC8A);
Color deactiveButtonColor = Color(0xffB2B7D0);
Map<String, File> images = {
  "file1": null,
  "file2": null,
  "file3": null,
  "file4": null,
};
String tempPhone = null;
String routeName = null;

Map<int, bool> problems = {};
bool isGetProblem = false;
String deviceToken = "";
String device = "";
var userLocation = null;
var fontSize8 = 0.0213;
var fontSize10 = 0.027;
var fontSize12 = 0.032;
var fontSize14 = 0.0374;
var fontSize16 = 0.0427;
var fontSize18 = 0.048;
var fontSize20 = 0.0534;
var fontSize22 = 0.0587;
var fontSize24 = 0.064;
var fontSize26 = 0.0694;

int routeProblemId;

String capitalize(String stringVal) {
  if (stringVal == null) {
    throw ArgumentError.notNull('string');
  }

  if (stringVal.isEmpty) {
    return stringVal;
  }
  var res = "";
  for (var i = 0; i < stringVal.length; i++) {
    res += stringVal[i].toLowerCase();
  }

  return res[0].toUpperCase() + res.substring(1);
}

bool validateFile(File img) {
  if (img.lengthSync() > 10485760) {
    return false;
  } else {
    return true;
  }
}
