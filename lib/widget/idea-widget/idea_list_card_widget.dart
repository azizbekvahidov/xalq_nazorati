import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/idea/idea_desc.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class IdeaListCardWidget extends StatefulWidget {
  final int index;
  IdeaListCardWidget(this.index);
  @override
  _IdeaListCardWidgetState createState() => _IdeaListCardWidgetState();
}

class _IdeaListCardWidgetState extends State<IdeaListCardWidget> {
  @override
  Widget build(BuildContext context) {
    Color _borderColor = Color(0xffFFA515);
    Color _bgColor = Color(0xffFFEDD3);
    Color _txtColor = Color(0xffFFA515);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return IdeaDesc(widget.index);
            },
          ),
        );
      },
      child: Container(
        child: ShadowBox(
          child: Container(
            height: 145,
            padding: EdgeInsets.only(left: 21, right: 21, top: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset("assets/img/newsPic.jpg")),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.index}Детская плошадка"),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: _borderColor),
                                  color: _bgColor),
                              child: Text(
                                "На рассмотрении",
                                style: TextStyle(
                                  color: _txtColor,
                                  fontFamily: globals.font,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/img/likeBtn.svg"),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  "144",
                                  style: TextStyle(
                                    color: Color(0xff100F0F),
                                    fontFamily: globals.font,
                                    fontSize: 10.92,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/img/dislikeBtn.svg"),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  "12",
                                  style: TextStyle(
                                    color: Color(0xff100F0F),
                                    fontFamily: globals.font,
                                    fontSize: 10.92,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Text(
                  "Здравствуйте, мы жители города Ташкента, по улице Мустакиллик, дом 90, были бы...",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: globals.font,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/img/user.svg"),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                        ),
                        Text(
                          "Махбуба Адылова",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontFamily: globals.font,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/img/calendar.svg"),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                        ),
                        Text(
                          "Махбуба Адылова",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontFamily: globals.font,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/img/pin.svg"),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                        ),
                        Text(
                          "Махбуба Адылова",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontFamily: globals.font,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
