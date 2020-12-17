import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class PnflScanAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color textColor;
  PnflScanAppbar({this.title, this.centerTitle, this.textColor, Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _PnflScanAppbarState createState() => _PnflScanAppbarState();
}

class _PnflScanAppbarState extends State<PnflScanAppbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.transparent,
          offset: Offset(4, 6),
          blurRadius: 10.0,
        )
      ]),
      child: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        centerTitle: widget.centerTitle,
        elevation: 0.0,
        title: Text(
          widget.title,
          style: Theme.of(context)
              .textTheme
              .display2
              .apply(color: widget.textColor)
              .copyWith(
                  fontSize:
                      MediaQuery.of(context).size.width * globals.fontSize20),
        ),
      ),
    );
  }
}
