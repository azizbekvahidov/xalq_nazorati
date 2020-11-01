import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mrz_scanner/flutter_mrz_scanner.dart';
import 'package:flutter_svg/svg.dart';
import '../../widget/app_bar/custom_appBar.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  MRZController controller;

  bool isParsed = false;

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Text(
                  "How_to_know_pnfl".tr().toString(),
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Container(
                      child: SvgPicture.asset("assets/img/Passport.svg")),
                ),
                FlatButton(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "clese".tr().toString(),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            ),
          );
        });
  }

  void _onControllerCreated(MRZController controller) {
    this.controller = controller;

    controller.onParsed = (result) async {
      if (!isParsed) {
        isParsed = true;
        controller.stopPreview();
        Navigator.pop(context, result);
      }
    };
    controller.onError = (error) => {
          showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                      content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Error!'),
                      RaisedButton(
                        child: const Text('ok'),
                        onPressed: () {
                          isParsed = false;
                          return Navigator.pop(context, true);
                        },
                      ),
                    ],
                  )))
        };
    controller.startPreview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(children: [
          MRZScanner(onControllerCreated: _onControllerCreated),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomAppBar(
              title: 'pnfl_scan'.tr().toString(),
              textColor: Colors.white,
              backgroundColor: Colors.transparent,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5)),
            ),
            Padding(
              padding: const EdgeInsets.all(38),
              child: Text("camera_put_data_right".tr().toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .apply(color: Colors.white)),
            )
          ])
        ]),
      ),
    );
  }
}
