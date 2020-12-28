import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/screen/main_page/problem/problem_desc.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class FlatWarningProblem extends StatefulWidget {
  FlatWarningProblem({Key key}) : super(key: key);

  @override
  _FlatWarningProblemState createState() => _FlatWarningProblemState();
}

class _FlatWarningProblemState extends State<FlatWarningProblem> {
  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: dHeight * 0.12, bottom: dHeight * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ups_sorry".tr().toString(),
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(fontSize: dWidth * globals.fontSize24)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "flat_warning_txt".tr().toString(),
                style: TextStyle(
                  fontFamily: globals.font,
                  fontSize: dWidth * globals.fontSize16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff303032),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: SvgPicture.asset("assets/img/dont_men.svg"),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: FlatButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(34),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "back".tr().toString(),
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
