import 'package:flutter/material.dart';

class DefaultInput extends StatefulWidget {
  final textController;
  final String hint;
  Function notifyParent;
  var inputType = TextInputType.text;
  DefaultInput(
      {Key key,
      this.hint,
      this.textController,
      this.notifyParent,
      this.inputType})
      : super(key: key);

  @override
  _DefaultInputState createState() => _DefaultInputState();
}

class _DefaultInputState extends State<DefaultInput> {
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
                0.74,
            child: TextField(
              keyboardType: widget.inputType,
              onChanged: (value) {
                widget.notifyParent();
              },
              controller: widget.textController,
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                hintText: widget.hint,
                hintStyle: Theme.of(context).textTheme.display1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
