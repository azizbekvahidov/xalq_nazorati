import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IdeaViewItem extends StatelessWidget {
  final String id;
  final String title;
  final String img;
  final String owner;
  final int like;
  final String publishingDate;
  final String region;

  IdeaViewItem({
    @required this.id,
    @required this.title,
    @required this.img,
    @required this.owner,
    @required this.like,
    @required this.publishingDate,
    @required this.region,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Row(
          children: [
            Container(
              width: 104,
              height: 84,
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset("assets/img/${img}"),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                      width: 64,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(22),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff12B79B),
                            Color(0xff00AC8A),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: Colors.white,
                            size: 17,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "${like}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 90,
              padding: EdgeInsets.only(left: 15, top: 5, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xff313B6C),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            owner,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff66676C),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 3, vertical: 10),
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Color(0xff66676C),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Text(
                            publishingDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff66676C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                  Container(
                      child: Row(
                    children: [
                      SvgPicture.asset("assets/img/location.svg"),
                      Text(
                        region,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff66676C),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
