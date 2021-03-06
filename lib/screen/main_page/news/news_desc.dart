import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/models/news.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';

class NewsDesc extends StatefulWidget {
  final String id;
  NewsDesc(this.id);

  @override
  _NewsDescState createState() => _NewsDescState();
}

class _NewsDescState extends State<NewsDesc> {
  Future<Map> getNews() async {
    var url = '${globals.api_link}/news/${widget.id}';

    var response = await Requests.get(url);

    var reply = response.json();
    return reply;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double cWidth = mediaQuery.size.width -
        mediaQuery.padding.left -
        mediaQuery.padding.right;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Новости",
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
            future: getNews(),
            builder: (context, snapshot) {
              var data = snapshot.data;
              if (snapshot.hasError) print(snapshot.error);
              DateFormat formatter = DateFormat('dd.MM.yyyy');

              String _publishDate;
              String dayOfWeek;
              if (snapshot.hasData) {
                _publishDate =
                    formatter.format(DateTime.parse(data["date_time"]));
                dayOfWeek = DateFormat('EEEE')
                    .format(DateTime.parse(data["date_time"]));
              }
              return snapshot.hasData
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 19),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 25, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(true),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Color(0xffEBEDF3),
                                      border: Border.all(
                                          color: Color(0xffB2B7D0), width: 0.5),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  width: cWidth - 75,
                                  child: Text(
                                    data["api_title".tr().toString()],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: globals.font,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            "$_publishDate, $dayOfWeek",
                            style: TextStyle(
                                color: Color(0xffB2B7D0),
                                fontFamily: globals.font,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 20, top: 15),
                            width: cWidth,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: data['img'] == null
                                  ? Container()
                                  : Image.network(data['img']),
                            ),
                          ),

                          data["api_content".tr().toString()] != null
                              ? Html(data: data["api_content".tr().toString()])
                              : Container(),
                          // Center(
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.only(bottom: 15, top: 30),
                          //     child: Text("Поделиться с друзьями:"),
                          //   ),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {},
                          //       child: Container(
                          //         width: 50,
                          //         height: 50,
                          //         decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(25)),
                          //         alignment: Alignment.center,
                          //         child: SvgPicture.asset(
                          //             "assets/img/facebook.svg"),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.only(left: 20),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {},
                          //       child: Container(
                          //         width: 50,
                          //         height: 50,
                          //         decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(25)),
                          //         alignment: Alignment.center,
                          //         child: SvgPicture.asset(
                          //             "assets/img/twitter.svg"),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.only(left: 20),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {},
                          //       child: Container(
                          //         width: 50,
                          //         height: 50,
                          //         decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(25)),
                          //         alignment: Alignment.center,
                          //         child: SvgPicture.asset(
                          //             "assets/img/instagram.svg"),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: EdgeInsets.only(left: 20),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {},
                          //       child: Container(
                          //         width: 50,
                          //         height: 50,
                          //         decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(25)),
                          //         alignment: Alignment.center,
                          //         child: SvgPicture.asset(
                          //             "assets/img/telegram.svg"),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Text("Loading"),
                    );
            }),
      ),
    );
  }
}
