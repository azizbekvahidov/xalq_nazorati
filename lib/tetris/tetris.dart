import 'package:flutter/material.dart';
import 'package:xalq_nazorati/tetris/gamer/gamer.dart';
import 'package:xalq_nazorati/tetris/gamer/keyboard.dart';
import 'package:xalq_nazorati/tetris/material/audios.dart';
import 'package:xalq_nazorati/tetris/panel/page_portrait.dart';

class Tetris extends StatefulWidget {
  Tetris({Key key}) : super(key: key);

  @override
  _TetrisState createState() => _TetrisState();
}

class _TetrisState extends State<Tetris> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Sound(child: Game(child: KeyboardController(child: PagePortrait()))),
    );
  }
}
