import 'package:flutter/material.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class PassInput extends StatefulWidget {
  final String hint;
  final passController;
  PassInput(this.hint, this.passController);

  @override
  _PassInputState createState() => _PassInputState();
}

class _PassInputState extends State<PassInput> {
  bool _passShow = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: Color(0xffF5F6F9),
        borderRadius: BorderRadius.circular(22.5),
        border: Border.all(
          color: Color.fromRGBO(178, 183, 208, 0.5),
          style: BorderStyle.solid,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: (mediaQuery.size.width -
                    mediaQuery.padding.left -
                    mediaQuery.padding.right) *
                (mediaQuery.size.width <= 360 ? 0.64 : 0.7),
            child: TextField(
              controller: widget.passController,
              obscureText: !_passShow,
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                  hintText: widget.hint,
                  hintStyle: Theme.of(context).textTheme.display1.copyWith(
                      fontSize: mediaQuery.size.width * globals.fontSize18)),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _passShow = !_passShow;
              });
            },
            child: _passShow
                ? SvgPicture.asset("assets/img/eye_open.svg")
                : SvgPicture.asset("assets/img/eye_close.svg"),
          )
        ],
      ),
    );
  }
}
