import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/models/category.dart';
import 'package:xalq_nazorati/models/news.dart';
import 'package:xalq_nazorati/screen/main_page/news/news_screen.dart';
import 'package:xalq_nazorati/widget/adv_widget.dart';
import 'package:xalq_nazorati/widget/category/category_list.dart';
import 'package:xalq_nazorati/widget/news/news_list.dart';
import 'package:xalq_nazorati/widget/problems/box_text_default.dart';
import 'package:xalq_nazorati/widget/problems/box_text_warning.dart';
import '../../widget/input/search_input.dart';

class MainPage extends StatefulWidget {
  static const routeName = "/main-page";
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<List> getCategory() async {
    var url = '${globals.api_link}/problems/categories';
    // Map<String, String> headers = {"Authorization": "token ${globals.token}"};

    var response = await Requests.get(url);

    var reply = response.json();

    return reply;
  }

  int notificationCnt = 0;
  List notifyList = [];

  getNotification() async {
    var url =
        '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/notifications/count';
    Map<String, String> headers = {"Authorization": "token ${globals.token}"};

    var response = await Requests.get(url, headers: headers);
    if (response.statusCode == 200) {
      var reply = response.json();
      setState(() {
        notificationCnt = reply["count"];
      });
    } else {
      var reply = response.json();
      print(reply);
    }
  }

  getNotificationList() async {
    Map<String, String> headers = {"Authorization": "token ${globals.token}"};
    var url =
        '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/notifications';
    var response = await Requests.get(url, headers: headers);
    if (response.statusCode == 200) {
      var reply = response.json();
      return reply;
    } else if (response.statusCode == 500)
      print("500");
    else {
      var reply = response.json();
      print(reply);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List> getNews() async {
    var url = '${globals.api_link}/news?limit=3';

    // Map<String, String> headers = {"Authorization": "token ${globals.token}"};

    var response = await Requests.get(url);

    var reply = response.json();
    return reply["results"];
  }

  // List<Categories> parseCategory(String responseBody) {
  //   final parsed = (json.decode(responseBody).cast<Map<String, dynamic>>());

  //   return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
  // }

  // List<News> parseNews(var responseBody) {
  //   final parsed = json.decode(responseBody).cast<dynamic>();
  //   var res = parsed.map<News>((json) => News.fromJson(json)).toList();
  //   return res;
  // }

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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.03,
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "notifications".tr().toString(),
                      style: Theme.of(context).textTheme.display2,
                    ),
                    FutureBuilder(
                        future: getNotificationList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? Container(
                                  height: 70.0 * snapshot.data.length,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context, index) {
                                      print(snapshot.data[index]);
                                      return Container(
                                          height: 90,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        BoxTextWarning(
                                                            "ID ${snapshot.data[index]["problem_id"]}",
                                                            "success"),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8)),
                                                        BoxTextDefault(
                                                            "${snapshot.data[index]["datetime"]}")
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        print("asdasd");
                                                      },
                                                      child: Icon(Icons.close),
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.only(top: 8),
                                                    height: 55,
                                                    child: Text(
                                                      "${snapshot.data[index]["action"]}",
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            globals.font,
                                                        color:
                                                            Color(0xff313B6C),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Divider(),
                                              ],
                                            ),
                                          ));
                                    },
                                  ),
                                )
                              : Container();
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    getNotification();
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                  height: 210,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff12B79B),
                        Color(0xff00AC8A),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${"hello".tr().toString()}, ${globals.userData['first_name'] ?? ""}",
                                style: TextStyle(
                                    fontFamily: globals.font,
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "welcome".tr().toString(),
                                style: TextStyle(
                                    fontFamily: globals.font,
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          globals.token != null
                              ? Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Color.fromRGBO(255, 255, 255, 0.3),
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        customDialog(context);
                                      },
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/img/bell.svg",
                                            height: 28,
                                            color: Colors.white,
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: notificationCnt != 0
                                                ? Container(
                                                    width: 16,
                                                    height: 16,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Color(0xffFF5555),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "$notificationCnt",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              globals.font,
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFeatures: [
                                                            FontFeature.enable(
                                                                "pnum"),
                                                            FontFeature.enable(
                                                                "lnum")
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      SearchtInput("search".tr().toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, bottom: 10),
                  child: Text(
                    "send_problem".tr().toString(),
                    style: TextStyle(
                        fontFamily: globals.font,
                        color: Color(0xff313B6C),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: getCategory(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? CategoryList(categories: snapshot.data)
                                : Center(
                                    child: Text("Loading".tr().toString()),
                                  );
                          }),
                    ],
                  ),
                ),
                Container(
                  child: AdvWidget(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "today".tr().toString(),
                            style: TextStyle(
                                fontFamily: globals.font,
                                color: Color(0xff313B6C),
                                fontSize: 18,
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
                            child: Text(
                              "show_all".tr().toString(),
                              style: TextStyle(
                                  fontFamily: globals.font,
                                  color: Color(0xff66676C),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: FutureBuilder(
                            future: getNews(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              return snapshot.hasData
                                  ? NewsList(
                                      news: snapshot.data,
                                      breaking: true,
                                    )
                                  : Center(
                                      child: Text("no_news".tr().toString()),
                                    );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  "test_notify".tr().toString(),
                  style: TextStyle(
                      fontFamily: globals.font,
                      color: Colors.white,
                      fontSize: (mediaQuery.size.width < 360) ? 14 : 16,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ],
      ),
    );
  }
}
