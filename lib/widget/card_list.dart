import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final String title;
  final String name;

  CardList(this.title, this.name);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff66676C),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xff000000),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
