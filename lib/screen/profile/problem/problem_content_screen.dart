import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/screen/chat/main_chat.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_not_relevant_screen.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_status_screen.dart';
import 'package:xalq_nazorati/screen/profile/problem/solve_problem_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/custom_card_list.dart';
import 'package:xalq_nazorati/widget/problems/box_text_default.dart';
import 'package:xalq_nazorati/widget/problems/box_text_warning.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ProblemContentScreen extends StatefulWidget {
  final String status;
  final String title;
  ProblemContentScreen(this.title, this.status);
  @override
  _ProblemContentScreenState createState() => _ProblemContentScreenState();
}

class _ProblemContentScreenState extends State<ProblemContentScreen> {
  bool _alert = true;
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              ShadowBox(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: mediaQuery.size.width * 0.7,
                                child: Text(
                                  "Неубранная контейнерная площадка",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Gilroy",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              _alert
                                  ? Stack(
                                      children: [
                                        Container(
                                          child: SvgPicture.asset(
                                            "assets/img/bell.svg",
                                            color: Colors.black,
                                          ),
                                        ),
                                        Positioned(
                                          right: 2,
                                          top: 0,
                                          child: Container(
                                            width: 6.75,
                                            height: 6.75,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.375),
                                              color: Color(0xffFF5555),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      child: SvgPicture.asset(
                                          "assets/img/bell.svg"),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Row(
                            children: [
                              BoxTextWarning(
                                  "Проблема решена и ждёт подтверждения",
                                  widget.status),
                              BoxTextDefault("9д : 23ч : 45м"),
                              BoxTextDefault("№15000"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                      child: Text(
                        "При получении неудовлетворительных результатов при испытаниях хотя бы по одному из требований настоящей программы проводятся повторные испытания удвоенного числа комплексов по пунктам",
                        style: TextStyle(
                          fontFamily: "Gilroy",
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 19),
                      child: Row(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(),
                                      width: mediaQuery.size.width * 0.24,
                                      height: 90,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.asset(
                                              "assets/img/newsPic.jpg"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: mediaQuery.size.width * 0.0266),
                                      width: mediaQuery.size.width * 0.24,
                                      height: 90,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.asset(
                                              "assets/img/newsPic.jpg"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: mediaQuery.size.width * 0.0266),
                                      width: mediaQuery.size.width * 0.24,
                                      height: 90,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.asset(
                                              "assets/img/newsPic.jpg"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: mediaQuery.size.width * 0.0266,
                                          top: mediaQuery.size.width * 0.0266),
                                      width: mediaQuery.size.width * 0.24,
                                      height: 90,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.asset(
                                              "assets/img/newsPic.jpg"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: mediaQuery.size.width * 0.0266),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: mediaQuery.size.width * 0.365,
                            height: 190,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.asset("assets/img/newsPic.jpg"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    )
                  ],
                ),
              ),
              ShadowBox(
                child: Column(
                  children: [
                    CustomCardList(
                        "subcat2", "Статус", ProblemStatusScreen(), true),
                    CustomCardList("subcat2", "Сообщение", MainChat(), true),
                    CustomCardList("subcat2", "Проблема не актуально",
                        ProblemNotRelevantScreen(2), true),
                    CustomCardList("subcat2", "Проблема решена",
                        SolveProblemScreen(status: false), false),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
              )
            ],
          ),
        ),
      ),
    );
  }
}
