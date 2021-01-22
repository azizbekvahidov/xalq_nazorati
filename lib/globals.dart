library xalq_nazorati.globals;

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internet_speed_test/callbacks_enum.dart';
import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:xalq_nazorati/screen/main_page/main_page.dart';

String token = null;
String lang = null;
String country = null;
// String api_link = "https://new.xalqnazorati.uz/ru/api";
// String site_link = "https://new.xalqnazorati.uz";

String api_link = "https://test.xalqnazorati.uz/ru/api";
String site_link = "https://test.xalqnazorati.uz";
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
Future<dynamic> categoryList;
Map<int, Future<dynamic>> subcategoryList = {};
Map<int, Future<dynamic>> subsubcategoryList = {};

Map<dynamic, dynamic> cardAlert = {};

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

generateAddrStr(var addr) {
  var district = addr["district"]["name_${lang.tr().toString()}"];
  var community = addr["neighborhood"]["name_${lang.tr().toString()}"];
  var street = addr["street"]["name_${lang.tr().toString()}"];
  var house = addr["house"]["number"];
  var apart = addr["apartment"] != null ? ", ${addr["apartment"]}" : "";
  return "$district, $street, $house$apart, $community";
}

String internetStatus = "good_conn".tr().toString();
String imgStatus = "assets/img/good_connection.svg";
Color colorStatus = Color(0xff1AFE91);
Timer connectTimer;

final internetSpeedTest = InternetSpeedTest();
startTimer() {
  try {
    internetSpeedTest.startDownloadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        mainPageState.setState(() {
          if (transferRate < 1.4) {
            internetStatus = "bad_conn".tr().toString();
            imgStatus = "assets/img/bad_connection.svg";
            colorStatus = Color(0xffECD821);
          } else {
            internetStatus = "good_conn".tr().toString();
            imgStatus = "assets/img/good_connection.svg";
            colorStatus = Color(0xff1AFE91);
          }
        });
      },
      onProgress: (double percent, double transferRate, SpeedUnit unit) {
        mainPageState.setState(() {
          if (transferRate < 1.4) {
            internetStatus = "${"bad_conn".tr().toString()}";
            imgStatus = "assets/img/bad_connection.svg";
            colorStatus = Color(0xffECD821);
          } else {
            internetStatus = "${"good_conn".tr().toString()}";
            imgStatus = "assets/img/good_connection.svg";
            colorStatus = Color(0xff1AFE91);
          }
        });
      },
      onError: (String errorMessage, String speedTestError) {},
      testServer: "http://ipv4.ikoula.testdebit.info/1M.iso",
      fileSize: 1000,
    );
  } catch (e) {
    print(e);
  }
}
