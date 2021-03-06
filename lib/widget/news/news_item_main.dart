import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/main_page/news/news_desc.dart';

class NewsItemMain extends StatefulWidget {
  final String id;
  final String title;
  final String location;
  final String publishDate;
  final String img;
  final String status;

  NewsItemMain(this.id, this.title, this.location, this.publishDate, this.img,
      this.status);
  @override
  _NewsItemMainState createState() => _NewsItemMainState();
}

class _NewsItemMainState extends State<NewsItemMain> {
  customDialog(BuildContext context) {
    DateFormat formatter = DateFormat('HH:mm, dd.MM.yyyy');
    String _publishDate = formatter.format(DateTime.parse(widget.publishDate));
    var dWidth = MediaQuery.of(context).size.width;
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.03,
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "new".tr().toString(),
                                    style: TextStyle(
                                      fontFamily: globals.font,
                                      fontSize: 16,
                                      color: Color(0xff313B6C),
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: FlatButton(
                                      height: 10,
                                      padding: EdgeInsets.all(0),
                                      minWidth: 10,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.37,
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Container(
                                    child: Text(
                                      widget.title,
                                      style: TextStyle(
                                        fontFamily: globals.font,
                                        fontSize: 14,
                                        color: Color(0xff313B6C),
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${"execute_date".tr().toString()}: ${_publishDate}",
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontSize: 14,
                              color: Color.fromRGBO(49, 59, 108, 0.54),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                              fontFeatures: [
                                FontFeature.enable("pnum"),
                                FontFeature.enable("lnum")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    String _publishDate = formatter.format(DateTime.parse(widget.publishDate));

    DateFormat formatter2 = DateFormat('HH:mm, dd.MM.yyyy');
    String _publishDate2 =
        formatter2.format(DateTime.parse(widget.publishDate));
    final mediaQuery = MediaQuery.of(context);
    final double cWidth = (mediaQuery.size.width -
        mediaQuery.padding.left -
        mediaQuery.padding.right);
    return InkWell(
      onTap: () {
        print(widget.title.length);
        customDialog(context);
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 240,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xffF6F6F6),
                    border: Border.all(
                      width: 1,
                      color: Color(0xffD4D6E3),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SvgPicture.asset(
                        "assets/img/news_bg.svg",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                height: 120,
                child: Container(
                  padding: EdgeInsets.only(left: 0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.location != ""
                              ? widget.title.length > 55
                                  ? "${widget.title.substring(0, 55)}..."
                                  : widget.title
                              : widget.title.length > 155
                                  ? "${widget.title.substring(0, 155)}..."
                                  : widget.title,
                          style: TextStyle(
                            color: Color(0xff313B6C),
                            fontFamily: globals.font,
                            fontSize:
                                mediaQuery.size.width * globals.fontSize14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        widget.location != ""
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    "assets/img/newsLocate.svg",
                                    height: 16,
                                    width: 16,
                                  ),
                                  Container(
                                    width: cWidth - 190,
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      widget.location,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: mediaQuery.size.width *
                                              globals.fontSize10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        widget.location == ""
                            ? Text(
                                "${"execute_date".tr().toString()}: ${_publishDate2}",
                                style: TextStyle(
                                  fontFamily: globals.font,
                                  fontSize: 12,
                                  color: Color(0xff676767),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                  fontFeatures: [
                                    FontFeature.enable("pnum"),
                                    FontFeature.enable("lnum")
                                  ],
                                ),
                              )
                            : Container(),
                        widget.location != ""
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/img/newsClock.svg",
                                    height: 16,
                                    width: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "${"accident_time".tr().toString()}: ${_publishDate}",
                                      style: TextStyle(
                                        fontFamily: globals.font,
                                        fontSize: mediaQuery.size.width *
                                            globals.fontSize10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFeatures: [
                                          FontFeature.enable("pnum"),
                                          FontFeature.enable("lnum")
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        widget.location != ""
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    (widget.status == "processing")
                                        ? "assets/img/news_proccess.svg"
                                        : "assets/img/news_complete.svg",
                                    width: 16,
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      (widget.status == "processing")
                                          ? "news_proccess".tr().toString()
                                          : "news_complete".tr().toString(),
                                      style: TextStyle(
                                        fontFamily: globals.font,
                                        fontSize: mediaQuery.size.width *
                                            globals.fontSize10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFeatures: [
                                          FontFeature.enable("pnum"),
                                          FontFeature.enable("lnum")
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
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
