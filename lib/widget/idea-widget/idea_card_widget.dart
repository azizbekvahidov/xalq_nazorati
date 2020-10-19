import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/models/ideas.dart';
import 'package:xalq_nazorati/screen/idea/Idea_list_screen.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class IdeaCardWidget extends StatefulWidget {
  final Ideas data;
  IdeaCardWidget(this.data);
  @override
  _IdeaCardWidgetState createState() => _IdeaCardWidgetState();
}

class _IdeaCardWidgetState extends State<IdeaCardWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return IdeaListScreen(widget.data);
            },
          ),
        );
      },
      child: Container(
        height: 77,
        child: Container(
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffD5D8E5), width: 0.5),
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
            padding: EdgeInsets.symmetric(horizontal: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(
                      color: Color.fromRGBO(178, 183, 208, 0.5),
                      width: 0.5,
                    ),
                  ),
                  child: SvgPicture.asset(
                    "assets/img/road.svg",
                    width: 22,
                    height: 22,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.data.id} ${widget.data.title_ru}",
                      style: TextStyle(
                        color: Color(0xff323F4B),
                        fontFamily: "Gilroy",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 89,
                      child: Text(
                        "${widget.data.description_ru}",
                        maxLines: 2,
                        style: TextStyle(
                          color: Color(0xff7B8794),
                          fontFamily: "Gilroy",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: "${widget.data.count_related_ideas}",
                          style: TextStyle(
                            color: Color(0xff323F4B),
                            fontFamily: "Gilroy",
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: " идей",
                          style: TextStyle(
                            color: Color(0xff323F4B),
                            fontFamily: "Gilroy",
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
