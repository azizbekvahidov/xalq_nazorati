import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class NewsNotify extends StatefulWidget {
  Map<String, dynamic> news;
  NewsNotify({this.news, Key key}) : super(key: key);

  @override
  _NewsNotifyState createState() => _NewsNotifyState();
}

class _NewsNotifyState extends State<NewsNotify> {
  String _title = "";
  int news_id;
  bool news_state = true;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    if (!prefs.containsKey("news-id")) {
      prefs.setInt('news-id', widget.news["id"]);

      news_id = widget.news["id"];
    }
    if (!prefs.containsKey("news-state")) {
      prefs.setBool('news-state', false);
      news_state = false;
    }

    int stringValue = prefs.getInt('news-id');
    bool stringState = prefs.getBool('news-state');
    if (stringValue == widget.news["id"]) {
      news_id = stringValue;
      news_state = stringState;
    } else {
      prefs.setInt('news-id', widget.news["id"]);
      prefs.setBool('news-state', false);
      news_id = widget.news["id"];
      news_state = false;
    }
    setState(() {});
  }

  setNewsVal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("news-state", true);
    setState(() {
      news_state = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
    _title = widget.news["title_${globals.lang.tr().toString()}"];
  }

  customDialog(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    DateFormat formatter = DateFormat('HH:mm, dd.MM.yyyy');
    String _publishDate =
        formatter.format(DateTime.parse(widget.news["date_time"]));
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
                                      color: Colors.black,
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
                                      _title,
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
    return news_state
        ? Container()
        : Container(
            padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: BoxDecoration(
              color: Color(0xffEAEBF0),
              border: Border.all(
                width: 3,
                color: Color(0xffE84848),
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "quick".tr().toString(),
                      style: TextStyle(
                        fontFamily: globals.font,
                        fontSize: 16,
                        color: Color(0xff313B6C),
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          setNewsVal();
                          // Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  child: Text(
                    _title.length > 72
                        ? "${_title.substring(0, 70)}..."
                        : _title,
                    style: TextStyle(
                      fontFamily: globals.font,
                      fontSize: 14,
                      color: Color(0xff313B6C),
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                InkWell(
                  onTap: () {
                    customDialog(context);
                  },
                  child: Container(
                    height: 28,
                    width: 100,
                    alignment: Alignment.center,
                    // margin:
                    //     EdgeInsets.only(top: 5, left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        color: Colors.transparent,
                        border: Border.all(width: 1, color: Color(0xffE84848))),
                    child: Text(
                      "Просмотреть",
                      style: TextStyle(
                        fontFamily: globals.font,
                        fontSize: 12,
                        color: Color(0xff313B6C),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
