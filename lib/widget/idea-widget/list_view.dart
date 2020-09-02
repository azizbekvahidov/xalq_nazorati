import 'package:flutter/material.dart';
import 'package:xalq_nazorati/models/ideas.dart';
import 'package:xalq_nazorati/widget/idea-widget/list_view_item.dart';

class IdeaList extends StatelessWidget {
  List<Ideas> _idea = [
    Ideas(
      "id1",
      "test.png",
      "15.06.2020",
      "Махбуба Адылова",
      "Детская плошадка",
      1250,
      "Алмазарский район",
    ),
    Ideas(
      "id2",
      "test.png",
      "15.06.2020",
      "Махбуба Адылова",
      "Детская плошадка",
      200,
      "Алмазарский район",
    ),
    Ideas(
      "id3",
      "test.png",
      "15.06.2020",
      "Махбуба Адылова",
      "Детская плошадка",
      700,
      "Алмазарский район",
    ),
    Ideas(
      "id4",
      "test.png",
      "15.06.2020",
      "Махбуба Адылова",
      "Детская плошадка",
      650,
      "Алмазарский район",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, i) {
        return IdeaViewItem(
          id: _idea[i].id,
          title: _idea[i].title,
          img: _idea[i].img,
          owner: _idea[i].owner,
          like: _idea[i].like,
          publishingDate: _idea[i].publishDate,
          region: _idea[i].region,
        );
      },
      itemCount: _idea.length,
    );
  }
}
