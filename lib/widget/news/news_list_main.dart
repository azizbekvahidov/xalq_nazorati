import 'package:flutter/material.dart';
import 'package:xalq_nazorati/screen/main_page/news/news_screen.dart';
import 'package:xalq_nazorati/widget/news/news_item_main.dart';
import 'package:xalq_nazorati/widget/news/news_item_planned.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/news/news_item_urgent.dart';

class NewsListMain extends StatefulWidget {
  final List news;
  final bool breaking;
  bool isMain;
  NewsListMain({Key key, this.news, this.breaking, this.isMain = false})
      : super(key: key);
  @override
  _NewsListMainState createState() => _NewsListMainState();
}

class _NewsListMainState extends State<NewsListMain> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var dWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        widget.news.length == 0
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "today".tr().toString().replaceAll("\n", " "),
                    style: TextStyle(
                        fontFamily: globals.font,
                        color: Color(0xff313B6C),
                        fontSize: dWidth * globals.fontSize18,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return NewsScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "show_all".tr().toString(),
                        style: TextStyle(
                            fontFamily: globals.font,
                            color: Color(0xff66676C),
                            fontSize: dWidth * globals.fontSize12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
        Container(
          height: widget.news.length == 0 ? 0 : 300,
          // height: 141.0 * widget.news.length,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: widget.news.length,
            itemBuilder: (content, index) {
              String title = widget.news[index]["api_title".tr().toString()];
              return NewsItemMain(
                widget.news[index]["id"].toString(),
                title,
                widget.news[index]["location"],
                widget.news[index]["date_time"],
                widget.news[index]["img"],
                widget.news[index]["status"],
              );
            },
          ),
        ),
      ],
    );
  }
}
