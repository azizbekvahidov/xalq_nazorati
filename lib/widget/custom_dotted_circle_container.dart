import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDottedCircleContainer extends StatefulWidget {
  final double boxSize;

  CustomDottedCircleContainer(this.boxSize);
  @override
  _CustomDottedCircleContainerState createState() =>
      _CustomDottedCircleContainerState();
}

class _CustomDottedCircleContainerState
    extends State<CustomDottedCircleContainer> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(widget.boxSize / 2),
      dashPattern: [12, 6],
      color: Color.fromRGBO(103, 105, 108, 0.5),
      strokeWidth: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(widget.boxSize / 2)),
        child: Container(
          padding: EdgeInsets.all(22),
          child: SvgPicture.asset(
            "assets/img/plus_icon.svg",
            color: Color.fromRGBO(49, 59, 108, 0.5),
          ),
          width: widget.boxSize,
          height: widget.boxSize,
        ),
      ),
    );
  }
}
