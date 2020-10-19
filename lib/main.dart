import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // AppLanguage appLanguage = AppLanguage();
  // await appLanguage.fetchLocale();

  // HttpOverrides.global = new MyHttpOverrides();
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
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              display1: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Color(0xffB2B7D0),
              ),
              display2: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff313B6C),
              ),

              button: TextStyle(
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
  String _lang = null;
  String _token = null;
  String _country = null;
  Future<void> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('lang');
    String countryValue = prefs.getString('country');
    String token = prefs.getString('userToken');
    setState(() {
      _lang = stringValue;
      _token = token;
      _country = countryValue;
    });
  }

  Future getUser() async {
    var url = '${globals.api_link}/users/profile';
    HttpGet request = HttpGet();
    var response = await request.methodGet(url);

    String reply = await response.transform(utf8.decoder).join();

    globals.userData = json.decode(reply);
  }

  @override
  void initState() {
    super.initState();

    getStringValuesSF();
    Timer(Duration(seconds: 0), () {
      if (_lang == null) {
        globals.lang = _lang;
        globals.country = _country;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LangScreen()));
      } else {
        if (_token == null) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          globals.lang = _lang;
          globals.country = _country;
          globals.token = _token;

          Navigator.pushReplacementNamed(context, HomePage.routeName);
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
