import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class ImageCarousel extends StatefulWidget {
  final String title;
  final List<dynamic> files;
  ImageCarousel(this.title, this.files);
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  AutoScrollController _scrollControllertop;
  final scrollDirection = Axis.horizontal;
  @override
  void initState() {
    super.initState();
    _scrollControllertop = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }

  Future _scrollTopLeft() async {
    await _scrollControllertop.scrollToIndex(0,
        preferPosition: AutoScrollPosition.begin);
  }

  Future _scrollTopRight() async {
    await _scrollControllertop.scrollToIndex(4,
        preferPosition: AutoScrollPosition.end);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: _scrollTopLeft,
                      child: Container(
                        alignment: Alignment.center,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 10,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    InkWell(
                      onTap: _scrollTopRight,
                      child: Container(
                        alignment: Alignment.center,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 14),
            height: 100,
            child: ListView.builder(
              controller: _scrollControllertop,
              physics: BouncingScrollPhysics(),
              scrollDirection: scrollDirection,
              itemCount: widget.files.length,
              itemBuilder: (BuildContext ctx, index) {
                var src = widget.files[index];
                print("${widget.title} $src");
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: _scrollControllertop,
                  index: index,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: index == 0 ? 19 : 10,
                        right: index == widget.files.length - 1 ? 19 : 0),
                    width: 100,
                    height: 100,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: (src != null || src != "null")
                          ? Image.network("${globals.site_link}$src")
                          : Container(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
