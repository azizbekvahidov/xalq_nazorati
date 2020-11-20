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
