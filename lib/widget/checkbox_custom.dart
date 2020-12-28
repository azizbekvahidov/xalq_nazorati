import 'package:flutter/material.dart';

class CheckboxCustom extends StatefulWidget {
  bool value;
  CheckboxCustom(this.value);
  @override
  _CheckboxCustomState createState() => _CheckboxCustomState();
}

class _CheckboxCustomState extends State<CheckboxCustom> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.value = !widget.value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                style: BorderStyle.solid,
                color: Theme.of(context).primaryColor),
            shape: BoxShape.circle,
            color: widget.value
                ? Theme.of(context).primaryColor
                : Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: widget.value
              ? Icon(
                  Icons.check,
                  size: 15.0,
                  color: Colors.white,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  size: 15.0,
                  color: Colors.transparent,
                ),
        ),
      ),
    );
  }
}
