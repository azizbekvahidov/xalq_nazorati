import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:xalq_nazorati/models/category.dart';

class CategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = Provider.of<Category>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            category.imgName,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
