import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/widget/input/default_input.dart';
import 'package:xalq_nazorati/widget/input/textarea_input.dart';

class SupportFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          DefaultInput("Введите тема"),
          DefaultInput("Введите адрес почты"),
          TextareaInput("Введите ваше сообщение...")
        ],
      ),
    );
  }
}
