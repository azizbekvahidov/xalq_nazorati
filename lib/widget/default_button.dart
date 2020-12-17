import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class DefaultButton extends StatefulWidget {
  final String txt;
  final Function routeFunc;
  final Color color;
  DefaultButton(this.txt, this.routeFunc, this.color);
  @override
  _DefaultButtonState createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FlatButton(
        color: widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34),
        ),
        onPressed: widget.routeFunc,
        child: Text(
          widget.txt,
          style: Theme.of(context).textTheme.button.copyWith(
              fontSize:
                  MediaQuery.of(context).size.height * globals.fontSize10),
        ),
      ),
    );
  }
}
