import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';

class IdeaDesc extends StatefulWidget {
  final int index;
  IdeaDesc(this.index);
  @override
  _IdeaDescState createState() => _IdeaDescState();
}

class _IdeaDescState extends State<IdeaDesc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Предложить идею",
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(4, 6), // changes position of shadow
                  ),
                ],
              ),
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.only(top: 25, bottom: 20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Color.fromRGBO(178, 183, 208, 0.5),
                          width: 0.5,
                        ),
                      ),
                      child: SvgPicture.asset(
                        "assets/img/road.svg",
                        width: 52.5,
                        height: 52.5,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        "Гаражи и парковки",
                        style: TextStyle(
                          color: Color(0xff323F4B),
                          fontFamily: globals.font,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Предложения по улучшению детских площадок",
                        style: TextStyle(
                          color: Color(0xff323F4B),
                          fontFamily: globals.font,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.symmetric(horizontal: 38),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          color: globals.activeButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34),
                          ),
                          onPressed: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (BuildContext context) {
                            //   return ProblemSolvedRateScreen();
                            // }));
                          },
                          child: Text(
                            "Подать идею",
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
