import 'package:flutter/material.dart';

class SearchtInput extends StatelessWidget {
  final String hint;
  SearchtInput(this.hint);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 20),
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
                0.75,
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xffB2B7D0),
                  size: 26,
                ),
                contentPadding: EdgeInsets.only(top: 0, bottom: 9),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: Theme.of(context).textTheme.display1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
