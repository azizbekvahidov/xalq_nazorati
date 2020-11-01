import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class IconCardList extends StatelessWidget {
  final String title;
  final String id;
  final Widget route;
  final bool divider;
  final String icon;
  final IconData lastIcon;
  IconCardList(
    this.id,
    this.icon,
    this.title,
    this.route,
    this.divider,
    this.lastIcon,
  );
  void _navigate(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return route;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: (mediaQuery.size.width -
                              mediaQuery.padding.left -
                              mediaQuery.padding.right) *
                          0.84,
                      child: Container(
                          child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 13),
                            child: SvgPicture.asset(icon),
                          ),
                          RichText(
                            text: TextSpan(
                              text: title,
                              style: TextStyle(
                                fontFamily: globals.font,
                                color: Color(0xff050505),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ))),
                  Container(
                    child: Icon(
                      lastIcon,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => _navigate(context),
          ),
          if (divider) Divider(),
        ],
      ),
    );
  }
}
