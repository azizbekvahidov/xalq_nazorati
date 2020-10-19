import 'package:flutter/material.dart';

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
              imgSrc,
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
