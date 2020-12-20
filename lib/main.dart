import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
// import 'package:workmanager/workmanager.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_content_screen.dart';
import 'package:xalq_nazorati/screen/register/forgot_pass.dart';
import 'package:xalq_nazorati/screen/register/forgot_pass_phone.dart';
import 'package:xalq_nazorati/screen/register/forgot_pass_recover.dart';

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
      navigatorKey: NavigationService.navigationKey,
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
                fontFeatures: [
                  FontFeature.enable("pnum"),
                  FontFeature.enable("lnum")
                ],
              ),
              display1: TextStyle(
                fontFamily: globals.font,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Color(0xffB2B7D0),
                fontFeatures: [
                  FontFeature.enable("pnum"),
                  FontFeature.enable("lnum")
                ],
              ),
              display2: TextStyle(
                fontFamily: globals.font,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff313B6C),
                fontFeatures: [
                  FontFeature.enable("pnum"),
                  FontFeature.enable("lnum")
                ],
              ),

              button: TextStyle(
                fontFamily: globals.font,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFeatures: [
                  FontFeature.enable("pnum"),
                  FontFeature.enable("lnum")
                ],
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
        ForgotPassPhone.routeName: (ctx) => ForgotPassPhone(),
        ProblemContentScreen.routeName: (ctx) => ProblemContentScreen(),
        ForgotPass.routeName: (ctx) => ForgotPass(),
        ForgotPassRecover.routeName: (ctx) => ForgotPassRecover(),
        RegisterPersonalDataScreen.routeName: (ctx) =>
            RegisterPersonalDataScreen(),
        HomePage.routeName: (ctx) => HomePage(),
        RulePage.routeName: (ctx) => RulePage(),
        MainPage.routeName: (ctx) => MainPage(),
      },
    );
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
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
    globals.token = token;
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
    // print(response.statusCode);
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
      payload: message["data"]["problem_id"],
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      try {
        await _navigateToItemDetail(int.parse(payload));
      } catch (e) {
        print(e.toString());
      }
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

  void _navigateToItemDetail(int id) async {
    // Clear away dialogs
    try {
      await navService.push(MaterialPageRoute(builder: (_) {
        return ProblemContentScreen(id: id);
      }));
    } catch (e) {
      print(e);
    }
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
        if (message["data"].containsKey("problem_id"))
          displayNotification(message);
      },
      onResume: (Map<String, dynamic> message) {
        if (message["data"].containsKey("problem_id"))
          navService.push(MaterialPageRoute(builder: (_) {
            return ProblemContentScreen(
                id: int.parse(message["data"]["problem_id"]));
          }));
      },
      onLaunch: (Map<String, dynamic> message) {
        if (message["data"].containsKey("problem_id"))
          Timer(Duration(seconds: 3), () {
            navService.push(MaterialPageRoute(builder: (_) {
              return ProblemContentScreen(
                  id: int.parse(message["data"]["problem_id"]));
            }));
          });
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
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
    });
    print(globals.deviceToken);
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
