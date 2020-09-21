import 'package:flutter/material.dart';

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
                0.7,
            child: TextField(
              controller: widget.passController,
              obscureText: !_passShow,
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                  hintText: widget.hint,
                  hintStyle: Theme.of(context).textTheme.display1),
            ),
          ),
        ],
      ),
    );
  }
}
