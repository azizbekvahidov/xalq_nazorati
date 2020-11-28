import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xalq_nazorati/methods/to_file.dart';
import 'package:xalq_nazorati/widget/problems/pdf_view.dart';

class PdfWidget extends StatefulWidget {
  final String fileName;
  final String date;
  PdfWidget(this.fileName, this.date);
  @override
  _PdfWidgetState createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  // ToFile to_file = ToFile();

  @override
  Widget build(BuildContext context) {
    String _fileName = widget.fileName.split("/").last;
    String ext = widget.fileName.split(".").last;
    String uri = "${globals.site_link}${widget.fileName}";
    // File file = File.fromUri(Uri.parse(uri));
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              var route;
              route = PdfView(fileName: widget.fileName);
              return route;
            },
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 20,
            child: Image.asset("assets/img/pdf.png"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "problem_passport".tr().toString(),
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${widget.date}  0,3 MB",
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
