import 'package:flutter/material.dart';

class CategoryCardList extends StatelessWidget {
  final String title;
  final int id;
  final Widget route;
  bool divider = false;

  CategoryCardList(this.id, this.title, this.route, this.divider);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: (mediaQuery.size.width -
                            mediaQuery.padding.left -
                            mediaQuery.padding.right) *
                        0.84,
                    child: Container(
                      child: RichText(
                        text: TextSpan(
                          text: title,
                          style: TextStyle(
                            fontFamily: "Gilroy",
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return route;
                  },
                ),
              );
            },
          ),
          if (divider) Divider(),
        ],
      ),
    );
  }
}
