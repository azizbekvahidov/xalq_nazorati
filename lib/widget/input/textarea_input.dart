import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class TextareaInput extends StatefulWidget {
  final String hint;
  final textareaController;
  Function notifyParent;
  final maxCnt;
  FocusNode descNode;
  TextareaInput({
    Key key,
    this.hint,
    this.textareaController,
    this.notifyParent,
    this.maxCnt,
    this.descNode,
  }) : super(key: key);

  @override
  _TextareaInputState createState() => _TextareaInputState();
}

class _TextareaInputState extends State<TextareaInput> {
  var cnt;
  var _maxCnt;
  @override
  void initState() {
    super.initState();
    _maxCnt = widget.maxCnt == null ? 1200 : widget.maxCnt;
    cnt = _maxCnt;
  }

  void changeTxt(String value) {
    setState(() {
      widget.notifyParent();
      cnt = _maxCnt - value.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 170,
          decoration: BoxDecoration(
            color: Color(0xffF5F6F9),
            borderRadius: BorderRadius.circular(10),
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
                  focusNode: widget.descNode,
                  onChanged: (text) {
                    String result = text;
                    if (result.length > _maxCnt) {
                      result = result.substring(0, _maxCnt);

                      widget.textareaController.text = result;
                      widget.textareaController.selection =
                          TextSelection.fromPosition(
                              TextPosition(offset: result.length));
                    }
                    changeTxt(result);
                  },
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
                      null,
                  maxLength: 1200,
                  controller: widget.textareaController,
                  maxLines: 7,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hint,
                    hintStyle: Theme.of(context).textTheme.display1.copyWith(
                        fontSize: mediaQuery.size.width * globals.fontSize18),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: Text(
            "${"textarea_counter_start".tr().toString()} $cnt ${"textarea_counter_end".tr().toString()}",
            style: TextStyle(
              color: Color.fromRGBO(102, 103, 108, 0.6),
              fontSize: mediaQuery.size.width * globals.fontSize10,
              fontWeight: FontWeight.w600,
              fontFamily: globals.font,
            ),
          ),
        ),
      ],
    );
  }
}
