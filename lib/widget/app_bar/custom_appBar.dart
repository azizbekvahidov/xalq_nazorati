import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  CustomAppBar({this.title, this.centerTitle, Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
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
        centerTitle: widget.centerTitle,
        elevation: 0.0,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.display2,
        ),
      ),
    );
  }
}
