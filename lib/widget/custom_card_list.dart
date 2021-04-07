import 'dart:async';
import 'dart:ui';

import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:xalq_nazorati/widget/get_login_dialog.dart';

class CustomCardList extends StatefulWidget {
  final String title;
  final String id;
  final Widget route;
  final String notifyText;
  final bool isNotify;

  bool divider = false;

  CustomCardList(this.id, this.title, this.route, this.divider, this.notifyText,
      this.isNotify);

  @override
  _CustomCardListState createState() => _CustomCardListState();
}

class _CustomCardListState extends State<CustomCardList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  customDialog(BuildContext context) {
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
              height: MediaQuery.of(context).size.height * 0.45,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: GetLoginDialog(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: (mediaQuery.size.width -
                              mediaQuery.padding.left -
                              mediaQuery.padding.right) *
                          0.82,
                      child: Row(
                        children: [
                          Container(
                              child: RichText(
                            text: TextSpan(
                              text: widget.title,
                              style: TextStyle(
                                fontFamily: globals.font,
                                color: Color(0xff050505),
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    mediaQuery.size.width * globals.fontSize18,
                              ),
                            ),
                          )),
                          Container(
                            child: widget.isNotify
                                ? Container(
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red),
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    // padding: EdgeInsets.symmetric(
                                    //     vertical: 2, horizontal: 7),
                                    child: Text(
                                      widget.notifyText,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: globals.font,
                                        fontSize: mediaQuery.size.width *
                                            globals.fontSize10,
                                        fontFeatures: [
                                          FontFeature.enable("pnum"),
                                          FontFeature.enable("lnum")
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      )),
                  Container(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              if (globals.token != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return widget.route;
                    },
                  ),
                ).then((value) {
                  setState(() {});
                });
              } else {
                customDialog(context);
              }
            },
          ),
          (widget.divider)
              ? Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Divider(
                      height: 0,
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                )
              : Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ),
    );
  }
}
