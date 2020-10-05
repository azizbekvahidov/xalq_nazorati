import 'package:flutter/material.dart';

class ProblemStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 15, left: 19, right: 19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Новым исполнителем назначен главный архитектор г.Ташкента Пулатов Мавлон по причине",
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
                "12.05.2020, 09:10",
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
  }
}
