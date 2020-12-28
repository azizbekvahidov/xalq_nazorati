import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/main_page/news/news_desc.dart';

class NewsItemUrgent extends StatefulWidget {
  final String id;
  final String title;
  final String location;
  final String publishDate;
  final String img;
  final String status;

  NewsItemUrgent(this.id, this.title, this.location, this.publishDate, this.img,
      this.status);
  @override
  _NewsItemUrgentState createState() => _NewsItemUrgentState();
}

class _NewsItemUrgentState extends State<NewsItemUrgent> {
  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    String _publishDate = formatter.format(DateTime.parse(widget.publishDate));

    final mediaQuery = MediaQuery.of(context);
    final double cWidth = (mediaQuery.size.width -
        mediaQuery.padding.left -
        mediaQuery.padding.right);
    return InkWell(
      // onTap: () {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (BuildContext context) {
      //         return NewsDesc(widget.id);
      //       },
      //     ),
      //   );
      // },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 150, minHeight: 120),
                  width: 100,
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
                      child: SvgPicture.asset("assets/img/news_bg.svg"),
                      // child: widget.img == null
                      //     ? Container()
                      //     : Image.network(widget.img)),
                    ),
                  ),
                  // child: Image.network(widget.img),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  width: cWidth - 152,
                  constraints: BoxConstraints(minHeight: 120),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 3,
                          style: TextStyle(
                            color: Color(0xff313B6C),
                            fontFamily: globals.font,
                            fontSize:
                                mediaQuery.size.width * globals.fontSize14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
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
                        ),
                        Column(
                          children: [
                            Row(
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
                            ),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            Row(
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
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: cWidth,
            height: 1,
            color: Color.fromRGBO(102, 103, 108, 0.8),
          )
        ],
      ),
    );
  }
}
