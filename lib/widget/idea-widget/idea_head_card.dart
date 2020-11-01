import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/idea/idea_add_screen.dart';

class IdeaHeadCard extends StatelessWidget {
  final int id;
  final String title;
  final String desc;
  final String img;
  bool btnStatus = false;

  IdeaHeadCard(this.id, this.title, this.desc, this.img, this.btnStatus);
  @override
  Widget build(BuildContext context) {
    return Container(
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
                img,
                width: 52.5,
                height: 52.5,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                title,
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
                desc,
                style: TextStyle(
                  color: Color(0xff323F4B),
                  fontFamily: globals.font,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            btnStatus
                ? Container(
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return IdeaAddScreen(id);
                          }));
                        },
                        child: Text(
                          "Подать идею",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
