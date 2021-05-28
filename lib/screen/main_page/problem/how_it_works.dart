import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/screen/main_page/problem/problem_desc.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class HowItWorks extends StatefulWidget {
  final int id;
  final String title;
  final String content;
  final int category_id;
  final int subcategoryId;
  final String breadcrumbs;
  final bool photo_required;
  HowItWorks(
      {this.id,
      this.title,
      this.content,
      this.category_id,
      this.subcategoryId,
      this.breadcrumbs,
      this.photo_required,
      Key key})
      : super(key: key);

  @override
  _HowItWorksState createState() => _HowItWorksState();
}

class _HowItWorksState extends State<HowItWorks> {
  bool _isUnderstand = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool pressAction = false;

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: !_isUnderstand
              ? Container(
                  padding: EdgeInsets.only(
                      top: dHeight * 0.12, bottom: dHeight * 0.06),
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
                        child: Html(
                          data: widget.content,
                          style: {
                            "p": Style(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              margin: EdgeInsets.symmetric(vertical: 0),
                            ),
                          },
                        ),
                      ),
                      Container(
                        child: SvgPicture.asset("assets/img/finish.svg"),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 0.5),
                                    borderRadius: BorderRadius.circular(34),
                                  ),
                                  child: FlatButton(
                                    onHighlightChanged: (value) {
                                      setState(() {
                                        pressAction = value;
                                      });
                                    },
                                    color: pressAction
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(34),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pushReplacement(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return ProblemDesc(
                                              widget.id,
                                              widget.title,
                                              widget.category_id,
                                              widget.subcategoryId,
                                              widget.breadcrumbs,
                                              widget.photo_required,
                                            );
                                          },
                                        ),
                                        // ModalRoute.withName(HomePage.routeName),
                                      );
                                    },
                                    child: Text(
                                      "understand".tr().toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              color: pressAction
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .primaryColor),
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
                                      widget.breadcrumbs,
                                      widget.photo_required,
                                    );
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
        ),
        CheckConnection(),
      ],
    );
  }
}
