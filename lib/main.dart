import 'dart:async';
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
  Future<void> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    String stringValue = prefs.getString('lang');
    setState(() {
      _lang = stringValue;
    });
  }

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
    Timer(
      Duration(seconds: 2),
      () => _lang == null
          ? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LangScreen()))
          : Navigator.pushReplacementNamed(context, LoginScreen.routeName),
    );
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
