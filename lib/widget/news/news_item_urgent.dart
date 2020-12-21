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

  NewsItemUrgent(
      this.id, this.title, this.location, this.publishDate, this.img);
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
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return NewsDesc(widget.id);
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 121,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: widget.img == null
                        ? Container()
                        : Image.network(widget.img)),
              ),
              // child: Image.network(widget.img),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              width: cWidth - 152,
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 3,
                    style: TextStyle(
                      color: Color(0xff313B6C),
                      fontFamily: globals.font,
                      fontSize: mediaQuery.size.width * globals.fontSize14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/img/newsLocate.svg"),
                        Container(
                          width: cWidth - 190,
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            widget.location,
                            maxLines: 3,
                            style: TextStyle(
                                fontFamily: globals.font,
                                fontSize:
                                    mediaQuery.size.width * globals.fontSize10,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/img/newsClock.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Время аварии: ${_publishDate}",
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontSize:
                                  mediaQuery.size.width * globals.fontSize12,
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
