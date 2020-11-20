import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
// import 'package:workmanager/workmanager.dart';
import 'package:xalq_nazorati/methods/http_get.dart';

import 'globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screen/main_page/main_page.dart';
import './screen/rule_page.dart';
import './screen/home_page.dart';
import './screen/register/pas_recognized_screen.dart';
import './screen/register/register_personaldata_screen.dart';
import './screen/register/pass_recognize_screen.dart';
import './screen/register/register_verify_screen.dart';
import './screen/register/register_phone_screen.dart';

import './screen/login_screen.dart';
import './screen/lang_screen.dart';
import 'package:firebase_core/firebase_core.dart';

const periodicTask = "periodicTask";
const simpleTaskKey = "simpleTask";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // await Workmanager.initialize(callbackDispatcher,
  //     isInDebugMode:
  //         true); //to true if still in testing lev turn it to false whenever you are launching the app

  // await Workmanager.registerPeriodicTask("1",
  //     periodicTask, //This is the value that will be returned in the callbackDispatcher

  //     initialDelay: Duration(seconds: 5),
  //     frequency: Duration(seconds: 10),
  //     existingWorkPolicy: ExistingWorkPolicy.replace,
  //     constraints: Constraints(
  //       networkType: NetworkType.connected,
  //     ));
  //
  // ("5", periodicTask,
  //     existingWorkPolicy: ExistingWorkPolicy.replace,
  //     frequency: Duration(minutes: 1), //when should it check the link
  //     initialDelay:
  //         Duration(seconds: 5), //duration before showing the notification
  //     constraints: Constraints(
  //       networkType: NetworkType.connected,
  //     ));
  runApp(EasyLocalization(
    child: MyApp(),
    path: "lang",
    saveLocale: true,
    supportedLocales: [
      Locale('uz', 'UZ'),
      Locale('ru', 'RU'),
      Locale('en', 'US'),
    ],
  ));
}
/*
Timer timer;

// void callbackDispatcher() {
//   try {
//     Workmanager.executeTask((task, inputData) async {
//       print(task);
//       FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
//       var android = new AndroidInitializationSettings("app_icon");
//       var iOS = IOSInitializationSettings();
//       var initSetttings = InitializationSettings(android: android, iOS: iOS);
//       flp.initialize(initSetttings);
//       switch (task) {
//         case simpleTaskKey:
//           startTimer(flp);
//           break;
//         case Workmanager.iOSBackgroundTask:
//           startTimer(flp);
//           break;
//         case periodicTask:
//           refreshBells(flp);
//           break;
//       }
//       return Future.value(true);
//       // return startTimer(flp);
//     });
//   } catch (e) {
//     print(e);
//   }
// }

void startTimer(flp) {
  Timer.periodic(Duration(seconds: 10), (Timer t) {
    refreshBells(flp);
  });
}

Future showNotification(String id, fltrNotification) async {
  var androidDetails = new AndroidNotificationDetails(
      "id", "name", "description",
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  var iOSDetails = IOSNotificationDetails();
  var generalNotificationDetails =
      new NotificationDetails(android: androidDetails, iOS: iOSDetails);
  await fltrNotification.show(int.parse(id), "task", "you crated task some $id",
      generalNotificationDetails);
}

Future notificationSelected(String payload) {}

Future getProblems() async {
  try {
    if (globals.token != null) {
      var url = '${globals.api_link}/problems/list/processing';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        var reply = response.json();
        // var some = temp.values.toList();
        var res = reply["results"];
        for (var i = 0; i < res.length; i++) {
          if (globals.problems[res[i]["id"]] == null) {
            Map<int, bool> elem = {res[i]["id"]: false};
            globals.problems.addAll(elem);
          }
        }
      }

      url = '${globals.api_link}/problems/list/confirmed';
      response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        var reply = response.json();
        // var some = temp.values.toList();
        var res = reply["results"];
        for (var i = 0; i < res.length; i++) {
          if (globals.problems[res[i]["id"]] == null) {
            Map<int, bool> elem = {res[i]["id"]: false};
            globals.problems.addAll(elem);
          }
        }
      }
      url = '${globals.api_link}/problems/list/denied';
      response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        var reply = response.json();
        // var some = temp.values.toList();
        var res = reply["results"];
        for (var i = 0; i < res.length; i++) {
          if (globals.problems[res[i]["id"]] == null) {
            Map<int, bool> elem = {res[i]["id"]: false};
            globals.problems.addAll(elem);
          }
        }
      }
      globals.isGetProblem = true;
      print(globals.problems);
    }
  } catch (e) {
    print(e);
  }
}

void refreshBells(flp) async {
  getProblems();
  var status = await Permission.notification.status;
  try {
    if (globals.token != null) {
      String _list = "";
      int i = 0;
      globals.problems.forEach((key, value) {
        i++;
        _list += "$key";
        if (i != globals.problems.length) _list += ",";
      });

      var url =
          '${globals.api_link}/problems/refresh-user-bells?problem_ids=$_list';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        var res = response.json();
        if (res['result'].length != 0) {
          for (var i = 0; i < res['result'].length; i++) {
            var problem_id = res['result'][i];
            if (!globals.problems[problem_id]) {
              showNotification("${problem_id}", flp);
              globals.problems[problem_id] = true;
            }
            // globals.problems[problem_id] = true;
          }
        }
      }
    }
    // String reply = await response.transform(utf8.decoder).join();

    // var temp = parseProblems(reply);

  } catch (e) {
    print(e);
  }
}
*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Xalq Nazorati',
      theme: ThemeData(
        primaryColor: Color(0xff1ABC9C),
        fontFamily: 'Gilroy',
        appBarTheme: AppBarTheme(
          elevation: 2,
          color: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              // ignore: deprecated_member_use
              title: TextStyle(
                fontFamily: globals.font,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              display1: TextStyle(
                fontFamily: globals.font,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Color(0xffB2B7D0),
              ),
              display2: TextStyle(
                fontFamily: globals.font,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff313B6C),
              ),

              button: TextStyle(
                fontFamily: globals.font,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        RegisterPhoneScreen.routeName: (ctx) => RegisterPhoneScreen(),
        RegisterVerifyScreen.routeName: (ctx) => RegisterVerifyScreen(),
        PassRecognizeScreen.routeName: (ctx) => PassRecognizeScreen(),
        PasRecognizedScreen.routeName: (ctx) => PasRecognizedScreen(),
        RegisterPersonalDataScreen.routeName: (ctx) =>
            RegisterPersonalDataScreen(),
        HomePage.routeName: (ctx) => HomePage(),
        RulePage.routeName: (ctx) => RulePage(),
        MainPage.routeName: (ctx) => MainPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _title = "Title";
  String _helper = "helper";
  String _lang = null;
  String _token = null;
  String _country = null;
  Timer timer;

  Future<void> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('lang');
    String countryValue = prefs.getString('country');
    String token = prefs.getString('userToken');
    // setState(() {
    _lang = stringValue;
    _token = token;
    _country = countryValue;
    // });
  }

  Future getUser() async {
    var url = '${globals.api_link}/users/profile';
    Map<String, String> headers = {"Authorization": "token $_token"};
    HttpGet request = HttpGet();
    var response = await Requests.get(url, headers: headers);
    if (response.statusCode == 200) {
      // dynamic json = response.json();

      globals.userData = response.json();
      globals.token = _token;
    } else {
      globals.token = null;
      dynamic json = response.json();
      print(json["detail"]);
      Fluttertoast.showToast(
          msg: json['detail'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15.0);
    }
    // String reply = await response.transform(utf8.decoder).join();
    print(response.statusCode);
    // globals.userData = json.decode(reply);
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel-id', 'fcm', 'androidcoding.in',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'fcm',
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    // On Select Android Notifications
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();

              // On select iOS notification
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    globals.device = Platform.isIOS ? "ios" : "android";

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message ${message}');
        displayNotification(message);
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      globals.deviceToken = token;
      print(token);
    });
    /*FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings("app_icon");
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSetttings);
    startTimer(flp);
     */
    getStringValuesSF();
    Timer(Duration(seconds: 2), () {
      if (_lang == null) {
        globals.lang = _lang;
        globals.country = _country;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LangScreen()));
      } else {
        globals.lang = _lang;
        globals.country = _country;
        if (_token == null) {
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        } else {
          // globals.token = _token;
          getUser();
          if (globals.token != null) {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          } else {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SvgPicture.asset('assets/img/logo.svg'),
        ),
      ),
    );
  }
}
