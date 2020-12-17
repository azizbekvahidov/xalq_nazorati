import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class CustomIconAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String icon;
  CustomIconAppBar({this.title, this.icon, Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomIconAppBarState createState() => _CustomIconAppBarState();
}

class _CustomIconAppBarState extends State<CustomIconAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.03),
          offset: Offset(4, 6),
          blurRadius: 10.0,
        )
      ]),
      child: AppBar(
        elevation: 0.0,
        leading: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(49, 59, 108, 0.15),
              borderRadius: BorderRadius.circular(50)),
          child: SvgPicture.asset(
            widget.icon,
            color: Color(0xff313B6C),
          ),
          padding: EdgeInsets.all(7),
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 20),
        ),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.display2.copyWith(
              fontSize: MediaQuery.of(context).size.width * globals.fontSize20),
        ),
      ),
    );
  }
}
