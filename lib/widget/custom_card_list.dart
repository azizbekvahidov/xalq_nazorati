import 'dart:async';

import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter/material.dart';

class CustomCardList extends StatefulWidget {
  final String title;
  final String id;
  final Widget route;
  bool divider = false;

  CustomCardList(this.id, this.title, this.route, this.divider);

  @override
  _CustomCardListState createState() => _CustomCardListState();
}

class _CustomCardListState extends State<CustomCardList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                          child: RichText(
                        text: TextSpan(
                          text: widget.title,
                          style: TextStyle(
                            fontFamily: globals.font,
                            color: Color(0xff050505),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ))),
                  Container(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return widget.route;
                  },
                ),
              );
            },
          ),
          if (widget.divider) Divider(),
        ],
      ),
    );
  }
}
