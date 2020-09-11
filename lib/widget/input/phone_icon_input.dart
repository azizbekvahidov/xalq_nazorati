import 'package:flutter/material.dart';

class PhoneIconInput extends StatelessWidget {
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
          Text(
            "+998",
            style: Theme.of(context).textTheme.title,
          ),
          VerticalDivider(
            color: Color.fromRGBO(183, 183, 195, 0.5),
            thickness: 0.5,
          ),
          Container(
            width: (mediaQuery.size.width -
                    mediaQuery.padding.left -
                    mediaQuery.padding.right) *
                0.56,
            child: TextField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration.collapsed(
                  hintText: "Мобильный номер",
                  hintStyle: Theme.of(context).textTheme.display1),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("good");
            },
            child: Icon(
              Icons.check_circle,
              color: Color(0xffB2B7D0),
            ),
          ),
        ],
      ),
    );
  }
}
