import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/main_page/news/news_archive_screen.dart';
import 'package:xalq_nazorati/screen/main_page/news/news_breaking_screen.dart';
import 'package:xalq_nazorati/screen/main_page/news/news_planned_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _index = 0;
  Color _bg1;
  Color _txt1;
  Color _bg2;
  Color _txt2;
  Color _bg3;
  Color _txt3;
  final List<Widget> _children = [
    NewsBreakingScreen(),
    // NewsPlannedScreen(),
    NewsArchiveScreen(),
  ];

  void _selectTab(index) {
    setState(() {
      _index = index;
      if (index == 0) {
        _bg1 = Theme.of(context).primaryColor;
        _bg2 = Color(0xffF5F6F9);
        _bg3 = Color(0xffF5F6F9);
        _txt1 = Colors.white;
        _txt2 = Color(0xffA8ACBE);
        _txt3 = Color(0xffA8ACBE);
      } else if (index == 1) {
        _bg1 = Color(0xffF5F6F9);
        _bg2 = Theme.of(context).primaryColor;
        _bg3 = Color(0xffF5F6F9);
        _txt1 = Color(0xffA8ACBE);
        _txt2 = Colors.white;
        _txt3 = Color(0xffA8ACBE);
      } else {
        _bg1 = Color(0xffF5F6F9);
        _bg2 = Color(0xffF5F6F9);
        _bg3 = Theme.of(context).primaryColor;
        _txt1 = Color(0xffA8ACBE);
        _txt2 = Color(0xffA8ACBE);
        _txt3 = Colors.white;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _selectTab(_index));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        title: "news".tr().toString(),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShadowBox(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectTab(0);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: width <= 360 ? 15 : 30),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _bg1,
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              "assets/img/news_breaking.svg",
                              color: _txt1,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "today".tr().toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: globals.font,
                                fontSize: width * globals.fontSize12,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     _selectTab(1);
                    //   },
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Container(
                    //         // padding: EdgeInsets.symmetric(
                    //         //     horizontal: width <= 360 ? 15 : 30),
                    //         height: 50,
                    //         width: 50,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(25),
                    //           color: _bg2,
                    //         ),
                    //         alignment: Alignment.center,
                    //         child: SvgPicture.asset(
                    //           "assets/img/news_planned.svg",
                    //           color: _txt2,
                    //         ),
                    //       ),
                    //       Container(
                    //         alignment: Alignment.center,
                    //         padding: EdgeInsets.only(top: 10),
                    //         child: Text(
                    //           "planning".tr().toString(),
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontFamily: globals.font,
                    //             fontSize: width * globals.fontSize12,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        _selectTab(1);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: width <= 360 ? 15 : 30),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _bg2,
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              "assets/img/news_archive.svg",
                              color: _txt2,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "archive".tr().toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: globals.font,
                                fontSize: width * globals.fontSize12,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ShadowBox(
              child: Container(
                height: height - 315,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _children[_index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
