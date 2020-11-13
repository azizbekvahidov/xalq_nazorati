import 'dart:async';
import 'dart:convert';
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

  Future<List> getNews() async {
    var url = '${globals.api_link}/news?limit=3';

    // Map<String, String> headers = {"Authorization": "token ${globals.token}"};

    var response = await Requests.get(url);

    var reply = response.json();

    return reply["result"];
  }

  List<Categories> parseCategory(String responseBody) {
    final parsed = (json.decode(responseBody).cast<Map<String, dynamic>>());

    return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
  }

  List<News> parseNews(var responseBody) {
    final parsed = json.decode(responseBody).cast<dynamic>();
    var res = parsed.map<News>((json) => News.fromJson(json)).toList();
    return res;
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.only(bottom: 40, left: 20, right: 20),
                  height: 188,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ],
      ),
    );
  }
}
