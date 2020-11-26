import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class FullScreen extends StatelessWidget {
  final String imgSrc;
  FullScreen(this.imgSrc);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              "${globals.site_link}/${imgSrc}",
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
