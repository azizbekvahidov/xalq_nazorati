import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class CheckConnection extends StatefulWidget {
  CheckConnection({Key key}) : super(key: key);

  @override
  _CheckConnectionState createState() => _CheckConnectionState();
}

class _CheckConnectionState extends State<CheckConnection> {
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      globals.isConnection = true;
      setState(() {});
      print("connected");
    } else if (result == ConnectivityResult.none) {
      globals.isConnection = false;
      setState(() {});
      print("no connection");
    }
    // switch (result) {
    //   case ConnectivityResult.wifi:

    //     break;
    //   case ConnectivityResult.mobile:
    //     globals.isConnection = true;
    //     setState(() {});
    //     print("connected");
    //     break;
    //   case ConnectivityResult.none:
    //     globals.isConnection = false;

    //     setState(() {});
    //     print("no connection");
    //     break;
    // }
    // print(globals.isConnection);
  }

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return !globals.isConnection || !globals.isServerConnection
        ? Positioned(
            top: 50,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15),
              width: MediaQuery.of(context).size.width * 0.7,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 0.5,
                ),
                color: Color.fromRGBO(251, 232, 232, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                // "${globals.internetStatus}",
                !globals.isConnection
                    ? "no_internet".tr().toString()
                    : "no_server".tr().toString(),
                style: TextStyle(
                    fontFamily: globals.font,
                    color: Color(0xffE31C1C),
                    fontSize: dWidth *
                        globals
                            .fontSize16, //(mediaQuery.size.width < 360) ? 14 : 16,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ))
        : Container();
  }
}
