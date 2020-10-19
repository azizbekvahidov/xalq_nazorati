import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:xalq_nazorati/models/problem_info.dart';

class ProblemStatusCard extends StatelessWidget {
  final List<ProblemInfo> data;
  ProblemStatusCard(this.data);
  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('dd.MM.yyyy, hh:mm');
    return Container(
      height: 88.0 * data.length,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (BuildContext ctx, index) {
            String statDate =
                formatter.format(DateTime.parse(data[index].datetime));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, left: 19, right: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index].info_ru,
                        style: TextStyle(
                          fontFamily: "Gilroy",
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
                          fontFamily: "Gilroy",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffB2B7D0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
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
