import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_content_screen.dart';
import 'package:xalq_nazorati/widget/problems/box_text_default.dart';
import 'package:xalq_nazorati/widget/problems/box_text_warning.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ProblemCard extends StatefulWidget {
  final bool alert;
  final String status;
  final String title;
  ProblemCard({this.alert, this.status, this.title});
  @override
  _ProblemCardState createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  @override
  Widget build(BuildContext context) {
    bool _alert = widget.alert == null ? false : widget.alert;
    var mediaQuery = MediaQuery.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProblemContentScreen(widget.title, widget.status);
            },
          ),
        );
      },
      child: ShadowBox(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 19, vertical: 15),
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
                                  borderRadius: BorderRadius.circular(3.375),
                                  color: Color(0xffFF5555),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          child: SvgPicture.asset("assets/img/bell.svg"),
                        ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: [
                  BoxTextWarning(
                      "Проблема решена и ждёт подтверждения", widget.status),
                  BoxTextDefault("9д : 23ч : 45м"),
                  BoxTextDefault("№15000"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
