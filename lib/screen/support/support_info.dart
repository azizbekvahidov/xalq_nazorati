import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupportInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset("assets/img/call.svg"),
        Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Text(
            "Контактные номера службы поддержки",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff313B6C),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "Gilroy",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 20),
          child: Text(
            "+99890 000 00 00",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Gilroy",
            ),
          ),
        ),
        Text(
          "+99890 000 00 00",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "Gilroy",
          ),
        ),
      ],
    );
  }
}
