import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/widget/default_button.dart';

class CustomDottedCircleContainer extends StatefulWidget {
  final double boxSize;

  CustomDottedCircleContainer(this.boxSize);
  @override
  _CustomDottedCircleContainerState createState() =>
      _CustomDottedCircleContainerState();
}

class _CustomDottedCircleContainerState
    extends State<CustomDottedCircleContainer> {
  // File image;
  // pickerCam() async{
  //   File img = await
  // }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                height: 320,
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Выберите фото",
                      style: Theme.of(context).textTheme.display2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/img/image.svg"),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Выбрать из галереи",
                                style: TextStyle(
                                  color: Color(0xff66676C),
                                  fontFamily: "Gilroy",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: InkWell(
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/img/camera.svg"),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Сделать снимок",
                                style: TextStyle(
                                  color: Color(0xff66676C),
                                  fontFamily: "Gilroy",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    DefaultButton("Отмена", () {
                      Navigator.of(context).pop();
                    }, Theme.of(context).primaryColor),
                  ],
                ),
              );
            });
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(widget.boxSize / 2),
        dashPattern: [12, 7],
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
      ),
    );
  }
}
