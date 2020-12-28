import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:carousel_slider/carousel_slider.dart';

class FullScreen extends StatelessWidget {
  final List<String> imgList;
  FullScreen(this.imgList);
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            // autoPlay: false,
          ),
          items: imgList
              .map((item) => Container(
                    child: Center(
                        child: CachedNetworkImage(
                      imageUrl: item,
                      fit: BoxFit.contain,
                      height: height,
                    )),
                  ))
              .toList(),
        ),
        Positioned(
            top: 40,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.close,
                  size: 40,
                ),
              ),
            )),
      ],
    );
  }
}
