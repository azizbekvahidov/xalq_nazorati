import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/screen/main_page/problem/problem_desc.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class CheckProblemCategory extends StatefulWidget {
  final int id;
  final String title;
  final int category_id;
  final int subcategoryId;
  final String breadcrumbs;
  CheckProblemCategory(
      {this.id,
      this.title,
      this.category_id,
      this.subcategoryId,
      this.breadcrumbs,
      Key key})
      : super(key: key);

  @override
  _CheckProblemCategoryState createState() => _CheckProblemCategoryState();
}

class _CheckProblemCategoryState extends State<CheckProblemCategory> {
  bool _isUnderstand = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: !_isUnderstand
          ? Container(
              padding:
                  EdgeInsets.only(top: dHeight * 0.12, bottom: dHeight * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("for_info".tr().toString(),
                      style: Theme.of(context)
                          .textTheme
                          .display2
                          .copyWith(fontSize: dWidth * globals.fontSize24)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "for_text_1".tr().toString(),
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
                    child: SvgPicture.asset("assets/img/finish.svg"),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        DefaultButton("understand".tr().toString(), () {
                          setState(() {
                            // _isUnderstand = true;
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ProblemDesc(
                                      widget.id,
                                      widget.title,
                                      widget.category_id,
                                      widget.subcategoryId,
                                      widget.breadcrumbs);
                                },
                              ),
                              // ModalRoute.withName(HomePage.routeName),
                            );
                          });
                        }, Theme.of(context).primaryColor),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 0.5),
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
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Границы ответственности",
                      style: Theme.of(context)
                          .textTheme
                          .display2
                          .copyWith(fontSize: dWidth * globals.fontSize24)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        DefaultButton("understand".tr().toString(), () {
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return ProblemDesc(
                                    widget.id,
                                    widget.title,
                                    widget.category_id,
                                    widget.subcategoryId,
                                    widget.breadcrumbs);
                              },
                            ),
                            // ModalRoute.withName(HomePage.routeName),
                          );
                        }, Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
