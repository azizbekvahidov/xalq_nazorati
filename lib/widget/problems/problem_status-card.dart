import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter/material.dart';

class ProblemStatusCard extends StatelessWidget {
  final List data;
  ProblemStatusCard(this.data);
  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('dd.MM.yyyy, hh:mm');
    return Container(
      height: 100.0 * data.length,
      child: ListView.builder(
          reverse: true,
          physics: NeverScrollableScrollPhysics(),
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
                          fontSize: 14,
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
                          fontSize: 12,
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
    );
  }
}
