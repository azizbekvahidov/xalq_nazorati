import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:html/parser.dart' show parse;
import 'package:xalq_nazorati/screen/main_page/news/news_desc.dart';

class NewsItemPlanned extends StatefulWidget {
  final String id;
  final String title;
  final String location;
  final String publishDate;
  final String img;
  final String content;

  NewsItemPlanned(this.id, this.title, this.location, this.publishDate,
      this.img, this.content);
  @override
  _NewsItemPlannedState createState() => _NewsItemPlannedState();
}

class _NewsItemPlannedState extends State<NewsItemPlanned> {
  @override
  Widget build(BuildContext context) {
    print("inner-> ${widget.content}");
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    String _publishDate = formatter.format(DateTime.parse(widget.publishDate));
    List<String> data = [];
    if (widget.content != null) {
      var content = parse(widget.content);
      data.add(content.getElementsByTagName("p")[0].innerHtml);
    }
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
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 121,
                  width: cWidth * 0.20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: widget.img == null
                            ? null
                            : Image.network(widget.img)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  width: cWidth * 0.65,
                  height: 121,
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
                        child: Text(
                          data.length != 0 ? "${data[0]}" : "",
                          maxLines: 3,
                          style: TextStyle(
                            fontFamily: globals.font,
                            fontSize:
                                mediaQuery.size.width * globals.fontSize12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${_publishDate}",
                              style: TextStyle(
                                fontFamily: globals.font,
                                fontSize:
                                    mediaQuery.size.width * globals.fontSize12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffB2B7D0),
                                fontFeatures: [
                                  FontFeature.enable("pnum"),
                                  FontFeature.enable("lnum")
                                ],
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
