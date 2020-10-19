import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/models/ideas.dart';
import 'package:xalq_nazorati/screen/idea/idea_add_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/widget/idea-widget/idea_head_card.dart';
import 'package:xalq_nazorati/widget/idea-widget/idea_list_card_widget.dart';

class IdeaListScreen extends StatefulWidget {
  final Ideas data;
  IdeaListScreen(this.data);
  @override
  _IdeaListScreenState createState() => _IdeaListScreenState();
}

class _IdeaListScreenState extends State<IdeaListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Предложить идею",
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            IdeaHeadCard(widget.data.id, "${widget.data.title_ru}",
                "${widget.data.description_ru}", "assets/img/road.svg", true),
            Container(
              padding: EdgeInsets.only(top: 10),
              // color: Colors.black,
              height: 6 * 185.0,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (BuildContext ctx, index) {
                  return IdeaListCardWidget(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
