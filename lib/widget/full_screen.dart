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
    return CarouselSlider(
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
                  fit: BoxFit.cover,
                  height: height,
                )),
              ))
          .toList(),
    );
  }
}
