import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class AdvWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var width = mediaQuery.size.width;
    return Container(
      margin: EdgeInsets.only(top: 25),
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 170,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Color(0xffdadded),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Color(0xffa3abd3),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff6b7dd4), Color(0xff3e4983)],
              ),
            ),
          ),
          Positioned(
            top: -49,
            left: 74,
            child: Container(
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(49),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff7184E0), Color(0xff485595)],
                ),
              ),
            ),
          ),
          Positioned(
            right: -49,
            top: 36,
            child: Container(
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(49),
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xff4C5A9D), Color(0xff3E4983)],
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 10,
            child: SvgPicture.asset("assets/img/men_icon.svg"),
          ),
          Positioned(
            left: 20,
            top: 27,
            child: Container(
              width: (width < 360) ? width * 0.6 : width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "adv_title".tr().toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: globals.font,
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "adv_desc".tr().toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (width < 360) ? 11 : 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: globals.font,
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
    );
  }
}
