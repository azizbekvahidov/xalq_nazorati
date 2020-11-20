import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';

class PhoneInput extends StatefulWidget {
  final myController;
  PhoneInput(this.myController);

  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
        mask: '__ ___ __ __', filter: {"_": RegExp(r'[0-9]')});
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
    final dHeight = mediaQuery.size.height;
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
          Text(
            "+998",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          VerticalDivider(
            color: Color.fromRGBO(183, 183, 195, 0.5),
            thickness: 0.5,
          ),
          Container(
            width: (mediaQuery.size.width -
                    mediaQuery.padding.left -
                    mediaQuery.padding.right) *
                0.55,
            child: TextField(
              inputFormatters: [maskFormatter],
              controller: widget.myController,
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration.collapsed(
                  hintText: "tel_number_hint".tr().toString(),
                  hintStyle: Theme.of(context).textTheme.display1),
            ),
          ),
        ],
      ),
    );
  }
}
