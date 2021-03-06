import 'dart:async';
import 'dart:io';
import 'dart:ui';
// import 'package:connectivity/connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:requests/requests.dart';

import 'package:xalq_nazorati/errors/CustomReportHandler.dart';
import 'package:xalq_nazorati/errors/CustomPageReportMode.dart';
import 'package:xalq_nazorati/methods/my_connect.dart';

import 'package:xalq_nazorati/screen/no_connection.dart';
import 'package:xalq_nazorati/screen/profile/change_personal_data.dart';
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
import 'package:catcher/catcher.dart';

const periodicTask = "periodicTask";
const simpleTaskKey = "simpleTask";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // close listener after 30 seconds, so the program doesn't run forever
  // await Future.delayed(Duration(seconds: 30));
  // await listener.cancel();
  await Firebase.initializeApp();

  /// Настройка для режима отладки, открывает страницу ошибки, выводит сообщение в консоль и вызывает [CustomReportHandler]
  CatcherOptions debugOptions = CatcherOptions(
    CustomPageReportMode(),
    [
      ConsoleHandler(),
      CustomReportHandler(),
    ],
  );

  /// Настройка для режима релиза, открывает страницу ошибки и вызывает [CustomReportHandler]
  CatcherOptions releaseOptions = CatcherOptions(CustomPageReportMode(), [
    ConsoleHandler(),
    CustomReportHandler(),
  ]);

  // Catcher(
  //   navigatorKey: NavigationService.navigationKey,
  //   rootWidget:
  runApp(
    EasyLocalization(
      child: MyApp(),
      path: "lang",
      saveLocale: true,
      supportedLocales: [
        Locale('uz', 'UZ'),
        Locale('ru', 'RU'),
        Locale('ru', 'UZ'),
      ],
    ),
    // debugConfig: debugOptions,
    // releaseConfig: releaseOptions,
  );
}

const SCREEN_BORDER_WIDTH = 3.0;

const BACKGROUND_COLOR = const Color(0xffC8C8C8); //Color(0xffefcc19);

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();
void setErrorBuilder() {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Scaffold(
        body:
            Center(child: Text("Unexpected error. See console for details.")));
  };
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // setErrorBuilder();
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
      // builder: (BuildContext context, Widget widget) {
      //   setErrorBuilder();
      //   return widget;
      // },
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
        ChangePersonalData.routeName: (ctx) => ChangePersonalData(),
        HomePage.routeName: (ctx) => HomePage(),
        NoConnection.routeName: (ctx) => NoConnection(),
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

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    if (prefs.containsKey("lang")) {
      String stringValue = prefs.getString('lang');
      _lang = stringValue;
    }
    if (prefs.containsKey("country")) {
      String countryValue = prefs.getString('country');
      _country = countryValue;
    }
    if (prefs.containsKey("userToken")) {
      String token = prefs.getString('userToken');
      globals.token = token;
      _token = token;
    }
    // setState(() {
    await getUser();
    // });
  }

  getUser() async {
    try {
      if (globals.isConnection) {
        var url = '${globals.api_link}/users/profile';
        Map<String, String> headers = {"Authorization": "token $_token"};
        var response = await Requests.get(url, headers: headers);
        if (response.statusCode == 200) {
          globals.userData = response.json();
          globals.token = _token;
        } else {
          globals.token = null;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  Future displayNotification(Map<String, dynamic> message) async {
    try {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'channel-id', 'fcm', 'androidcoding.in',
          importance: Importance.max, priority: Priority.high);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        Platform.isIOS
            ? message["aps"]['alert']['title']
            : message['notification']['title'],
        Platform.isIOS
            ? message["aps"]['alert']['body']
            : message['notification']['body'],
        platformChannelSpecifics,
        payload: Platform.isIOS
            ? message["problem_id"]
            : message["data"]["problem_id"],
      );
    } catch (e) {
      print(e);
    }
  }

  Future displayNotificationNews(Map<String, dynamic> message) async {
    try {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'channel-id', 'fcm', 'androidcoding.in',
          importance: Importance.max, priority: Priority.high);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        Platform.isIOS
            ? message["aps"]['alert']['title']
            : message['notification']['title'],
        Platform.isIOS
            ? message["aps"]['alert']['body']
            : message['notification']['body'],
        platformChannelSpecifics,
        // payload: message["data"]["problem_id"],
      );
    } catch (e) {
      print(e);
    }
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

  customDialog(BuildContext context, txt) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: Center(
                child: Text(txt),
              ),
            ),
          );
        });
  }

  ConnectivityResult connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityResult _previousResult;

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print(result);
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        globals.isConnection = true;
        print("connected");
        break;
      case ConnectivityResult.none:
        print("no connection");
        globals.isConnection = false;
        if (globals.isLoad) {
          if (!globals.isOpenNoConnection)
            await navService.push(MaterialPageRoute(builder: (_) {
              return NoConnection();
            }));
        } else
          Timer(Duration(seconds: 2), () async {
            await navService.push(MaterialPageRoute(builder: (_) {
              return NoConnection();
            }));
          });
        break;
    }
    print(globals.isConnection);
  }

  @override
  void initState() {
    super.initState();
    globals.device = Platform.isIOS ? "ios" : "android";

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // var listener =
    //     DataConnectionChecker().onStatusChange.listen((status) async {
    //   print(status);
    //   switch (status) {
    //     case DataConnectionStatus.connected:
    //       // if (globals.isLoad) await navService.canPop();
    //       globals.isConnection = true;
    //       print("connected");
    //       // customDialog(context);
    //       break;
    //     case DataConnectionStatus.disconnected:
    //       globals.isConnection = false;
    //       if (globals.isLoad)
    //         await navService.push(MaterialPageRoute(builder: (_) {
    //           return NoConnection();
    //         }));
    //       else
    //         Timer(Duration(seconds: 2), () async {
    //           await navService.push(MaterialPageRoute(builder: (_) {
    //             return NoConnection();
    //           }));
    //         });

    //       print("disconnected");
    //       break;
    //   }
    // });

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@drawable/ic_stat_xalq_logo');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        if (message.containsKey("data")) {
          if (message["data"].containsKey("problem_id"))
            displayNotification(message);
          else {
            displayNotificationNews(message);
          }
        } else {
          if (message.containsKey("problem_id"))
            displayNotification(message);
          else {
            displayNotificationNews(message);
          }
        }
      },
      onResume: (Map<String, dynamic> message) {
        if (Platform.isIOS) if (message.containsKey("problem_id"))
          navService.push(MaterialPageRoute(builder: (_) {
            return ProblemContentScreen(id: int.parse(message["problem_id"]));
          }));
        else if (message["data"].containsKey("problem_id"))
          navService.push(MaterialPageRoute(builder: (_) {
            return ProblemContentScreen(
                id: int.parse(message["data"]["problem_id"]));
          }));
      },
      onLaunch: (Map<String, dynamic> message) {
        if (Platform.isAndroid) {
          if (message["data"].containsKey("problem_id"))
            Timer(Duration(seconds: 3), () {
              navService.push(MaterialPageRoute(builder: (_) {
                return ProblemContentScreen(
                    id: int.parse(message["data"]["problem_id"]));
              }));
            });
        } else {
          if (message.containsKey("problem_id"))
            Timer(Duration(seconds: 3), () {
              navService.push(MaterialPageRoute(builder: (_) {
                return ProblemContentScreen(
                    id: int.parse(message["problem_id"]));
              }));
            });
        }
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
      print(token);
    });
    getStringValuesSF();

    Timer(Duration(seconds: 2), () {
      if (_lang == null) {
        globals.lang = _lang;
        globals.country = _country;
        globals.isLoad = true;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LangScreen()));
      } else {
        globals.lang = _lang;
        globals.country = _country;
        globals.isLoad = true;
        if (_token == null) {
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        } else {
          // globals.token = _token;

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
