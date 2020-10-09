import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/profile/main_profile.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/input/textarea_input.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ProblemSolvedRateScreen extends StatefulWidget {
  @override
  _ProblemSolvedRateScreenState createState() =>
      _ProblemSolvedRateScreenState();
}

class _ProblemSolvedRateScreenState extends State<ProblemSolvedRateScreen> {
  var descController = TextEditingController();
  var rating = 0.0;
  var dataSended = false;

  Future sendData() async {
    setState(() {
      dataSended = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Проблема решена",
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ShadowBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 15),
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset("assets/img/newsPic.jpg"),
                  ),
                ),
              ),
              Text(
                "Пулатов Мавлонбек",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: globals.font,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 7),
              ),
              Text(
                "Веб дизайнер",
                style: TextStyle(
                  fontFamily: globals.font,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              !dataSended
                  ? Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Как наш исполнитель помог вам? пожалуйста, оцените и напишите отзыв",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 18),
                        ),
                        SmoothStarRating(
                          allowHalfRating: false,
                          onRated: (v) {},
                          starCount: 5,
                          rating: rating,
                          size: 40.0,
                          color: Theme.of(context).primaryColor,
                          borderColor: Color(0xffEBEDF3),
                          spacing: 0.0,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 19),
                            child: TextareaInput("", descController)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 19),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                              color: globals.activeButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(34),
                              ),
                              onPressed: () {
                                sendData().then((value) {
                                  Timer(Duration(seconds: 2), () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return MainProfile();
                                    }), (Route<dynamic> route) => true);
                                  });
                                });
                              },
                              child: Text(
                                "Подтвердить",
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Спасибо за поддержку!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
