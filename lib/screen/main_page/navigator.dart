import 'package:flutter/material.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return new MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return widget.child;
          },
        );
      },
    );
  }
}
