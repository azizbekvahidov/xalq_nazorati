import 'package:flutter/foundation.dart';

class Category with ChangeNotifier {
  final String id;
  final String imgName;
  final String txt;

  Category({
    @required this.id,
    @required this.imgName,
    @required this.txt,
  });
}
