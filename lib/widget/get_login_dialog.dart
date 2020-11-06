import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/screen/login_screen.dart';
import 'package:xalq_nazorati/screen/register/register_phone_screen.dart';

class GetLoginDialog extends StatelessWidget {
  final String routeName;
  const GetLoginDialog({this.routeName, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset("assets/img/info.svg"),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "sign_up_warning".tr().toString(),
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      globals.routeName = routeName;
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                  text: "get_log_in".tr().toString(),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: globals.font,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: "or".tr().toString(),
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      globals.routeName = routeName;
                      Navigator.pushNamed(
                          context, RegisterPhoneScreen.routeName);
                    },
                  text: "get_sign_ups".tr().toString(),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: globals.font,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  "close".tr().toString(),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }
}
