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
import 'package:xalq_nazorati/screen/profile/problem/problem_content_screen.dart';
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
    reply = overrideCategory(reply);

    return reply;
  }

  int notificationCnt = 0;
  List notifyList = [];
  var _newNotifyList;

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

  checkNotification(var id) async {
    try {
      var url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/notifications/check';
      Map<String, String> data = {"id": id.toString()};
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};

      var response = await Requests.post(url, headers: headers, body: data);
      if (response.statusCode == 201) {
        var reply = response.json();
        getNotification();
        setState(() {});
      } else {
        var reply = response.json();
        print(reply);
      }
    } catch (e) {
      print(e);
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
    _newNotifyList = getNotificationList();
    DateFormat formatterDay = DateFormat('dd');
    DateFormat formatterMonth = DateFormat('MMMM');
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "notifications".tr().toString(),
                            style: Theme.of(context).textTheme.display2,
                          ),
                          FutureBuilder(
                              future: _newNotifyList,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                return snapshot.hasData
                                    ? Container(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.7, //115.0 * snapshot.data.length,
                                        child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: snapshot.data.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            String statDateDay = formatterDay
                                                .format(DateTime.parse(DateFormat(
                                                        "yyyy-MM-ddTHH:mm:ssZ")
                                                    .parseUTC(
                                                        snapshot.data[index]
                                                            ["datetime"])
                                                    .toString()));

                                            String statDateMonth = formatterMonth
                                                .format(DateTime.parse(DateFormat(
                                                        "yyyy-MM-ddTHH:mm:ssZ")
                                                    .parseUTC(
                                                        snapshot.data[index]
                                                            ["datetime"])
                                                    .toString()));
                                            return Dismissible(
                                              key: Key(snapshot.data[index]
                                                  .toString()),
                                              onDismissed: (direction) {
                                                if (direction ==
                                                    DismissDirection
                                                        .endToStart) {
                                                  checkNotification(snapshot
                                                      .data[index]["id"]);
                                                } else if (direction ==
                                                    DismissDirection
                                                        .startToEnd) {
                                                  checkNotification(snapshot
                                                      .data[index]["id"]);
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        var route;
                                                        route = ProblemContentScreen(
                                                            id: snapshot
                                                                    .data[index]
                                                                ["problem_id"]);
                                                        return route;
                                                      },
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  height: 95,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                8)),
                                                                BoxTextDefault(
                                                                    "$statDateDay " +
                                                                        "$statDateMonth"
                                                                            .tr()
                                                                            .toString())
                                                              ],
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                checkNotification(
                                                                    snapshot.data[
                                                                            index]
                                                                        ["id"]);
                                                                setState(() {
                                                                  snapshot.data
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: Icon(
                                                                  Icons.close),
                                                            ),
                                                          ],
                                                        ),
                                                        FlatButton(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          onPressed: () {
                                                            checkNotification(
                                                                snapshot.data[
                                                                        index]
                                                                    ["id"]);
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  var route;
                                                                  route = ProblemContentScreen(
                                                                      id: snapshot
                                                                              .data[index]
                                                                          [
                                                                          "problem_id"]);
                                                                  return route;
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 8),
                                                            height: 50,
                                                            child: Text(
                                                              "${snapshot.data[index]["action"]}",
                                                              style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                fontSize: dWidth *
                                                                    globals
                                                                        .fontSize14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    globals
                                                                        .font,
                                                                color: Color(
                                                                    0xff313B6C),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(),
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          },
                                        ),
                                      )
                                    : Container();
                              }),
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

  overrideCategory(List<dynamic> data) {
    List<dynamic> res = [];
    for (int i = data.length - 1; i >= 0; i--) {
      res.add(data[i]);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    // getNotification();
    final mediaQuery = MediaQuery.of(context);
    var dWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
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
                                  "${"welcome".tr().toString()},",
                                  style: TextStyle(
                                      fontFamily: globals.font,
                                      color: Colors.white,
                                      fontSize: dWidth * globals.fontSize26,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  globals.token != null
                                      ? "${globals.capitalize(globals.userData['last_name'])} ${globals.capitalize(globals.userData['first_name'])}"
                                      : "",
                                  style: TextStyle(
                                      fontFamily: globals.font,
                                      color: Colors.white,
                                      fontSize: dWidth * globals.fontSize26,
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
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            Color(0xffFF5555),
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
                                                              FontFeature
                                                                  .enable(
                                                                      "pnum"),
                                                              FontFeature
                                                                  .enable(
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
                        SearchtInput("search"),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 20, bottom: 10),
                    child: Text(
                      "send_problem".tr().toString(),
                      style: TextStyle(
                          fontFamily: globals.font,
                          color: Color(0xff313B6C),
                          fontSize: dWidth * globals.fontSize18,
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
                              child: Text(
                                "show_all".tr().toString(),
                                style: TextStyle(
                                    fontFamily: globals.font,
                                    color: Color(0xff66676C),
                                    fontSize: dWidth * globals.fontSize12,
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
                        fontSize: dWidth *
                            globals
                                .fontSize16, //(mediaQuery.size.width < 360) ? 14 : 16,
                        fontWeight: FontWeight.w500),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
