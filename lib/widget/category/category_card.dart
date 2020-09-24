import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import '../../screen/main_page/category_screen.dart';

class CategoryCard extends StatefulWidget {
  final int id;
  final String title;
  final String img;

  CategoryCard(this.id, this.title, this.img);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double cWidth = (mediaQuery.size.width -
            mediaQuery.padding.left -
            mediaQuery.padding.right) *
        0.275;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return CategoryScreen(
                title: widget.title,
                id: widget.id,
              );
            },
          ),
        );

        // CategoryScreen.routeName);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 10, top: 15),
        decoration: BoxDecoration(
          color: Color.fromRGBO(49, 59, 108, 0.1),
          borderRadius: BorderRadius.all(Radius.circular(22)),
          border: Border.all(
            color: Color.fromRGBO(178, 183, 208, 0.4),
          ),
        ),
        width: cWidth,
        height: cWidth * 1.12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.network(
              "${globals.site_link}${widget.img}",
              width: 45,
              height: 45,
            ),
            // SvgPicture.asset(img),
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
