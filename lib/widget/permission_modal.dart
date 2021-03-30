import 'package:flutter/material.dart';
import 'package:system_settings/system_settings.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class PermissionModal extends StatelessWidget {
  const PermissionModal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "warning".tr().toString(),
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: dWidth * globals.fontSize20,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "permission_text".tr().toString(),
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: dWidth * globals.fontSize16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: FlatButton(
                    child: Container(
                        // width: dWidth,
                        // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                        // decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(25),
                        // color: Theme.of(context).primaryColor,
                        // border: Border.all(
                        //   style: BorderStyle.solid,
                        //   color: Theme.of(context).primaryColor,
                        //   width: 1,
                        // ),
                        // ),
                        child: Center(
                      child: Text(
                        "cancel".tr().toString(),
                        style: TextStyle(
                          fontSize: dWidth * globals.fontSize16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.pop(context, true);
                    },
                  ),
                ),
                Container(
                  child: FlatButton(
                    child: Container(
                        // width: dWidth,
                        // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                        // decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(25),
                        // color: Theme.of(context).primaryColor,
                        // border: Border.all(
                        //   style: BorderStyle.solid,
                        //   color: Theme.of(context).primaryColor,
                        //   width: 1,
                        // ),
                        // ),
                        child: Center(
                      child: Text(
                        "go_settings".tr().toString(),
                        style: TextStyle(
                          fontSize: dWidth * globals.fontSize16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                    onPressed: () {
                      SystemSettings.app();
                      // Navigator.pop(context, true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
