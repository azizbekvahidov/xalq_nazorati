import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter/material.dart';

class ProblemStatusCard extends StatelessWidget {
  final List data;
  final double appHeight;
  ProblemStatusCard(this.data, this.appHeight);
  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    var meduaQiery = MediaQuery.of(context);
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    return Container(
      height: dHeight - appHeight - 240,
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            // shrinkWrap: true,
            // reverse: true,
            physics: BouncingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (BuildContext ctx, index) {
              String statDate = formatter.format(DateTime.parse(
                  DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                      .parseUTC(data[index]["datetime"])
                      .toString()));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 12, left: 19, right: 19),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index]["api_info".tr().toString()],
                          style: TextStyle(
                            fontFamily: globals.font,
                            fontSize: dWidth * globals.fontSize14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          statDate,
                          style: TextStyle(
                            fontFamily: globals.font,
                            fontSize: dWidth * globals.fontSize12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffB2B7D0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              );
            }),
      ),
    );
  }
}
