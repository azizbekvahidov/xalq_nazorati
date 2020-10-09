import 'dart:convert';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
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
  Future<List<Categories>> getCategory() async {
    var url = '${globals.api_link}/problems/categories';
    HttpGet request = HttpGet();
    var response = await request.methodGet(url);

    String reply = await response.transform(utf8.decoder).join();

    return parseCategory(reply);
  }

  Future<List<News>> getNews() async {
    var url = '${globals.api_link}/news?limit=3';
    HttpGet request = HttpGet();
    var response = await request.methodGet(url);

    String reply = await response.transform(utf8.decoder).join();
    var temp = json.decode(reply);
    var some = temp.values.toList();
    return parseNews(json.encode(some[3]));
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
    print(globals.userData);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 40, left: 20, right: 20),
              height: 253,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
                    "Привет, ${globals.userData['first_name']}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "welcome".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: SearchtInput("Поиск категории"),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, bottom: 10),
              child: Text(
                "Сообщить о проблемы",
                style: TextStyle(
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
                                child: Text("Loading"),
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
                        "Срочные новости",
                        style: TextStyle(
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
                          "Смотреть все",
                          style: TextStyle(
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
                                  child: Text("Loading"),
                                );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsFeed {
  final int count;
  final String prev;
  final String next;
  final List<Map<String, dynamic>> result;

  NewsFeed({
    this.result,
    this.count,
    this.next,
    this.prev,
  });

  factory NewsFeed.fromJson(Map<String, dynamic> json) => NewsFeed(
        count: json["count"],
        next: json["next"],
        prev: json["prev"],
        result: json["result"],
      );
}
