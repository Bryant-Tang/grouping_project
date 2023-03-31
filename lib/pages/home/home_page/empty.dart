/*

**  ATTENTION  **
This is a empty test Widget, it's only used as test. Therefore, please don't delete it.

*/
import 'package:flutter/material.dart';
import 'package:grouping_project/components/card_view/event_information.dart';
import 'package:grouping_project/components/card_view/card_view_template.dart';
import 'package:grouping_project/model/event_model.dart';

class EmptyWidget extends StatelessWidget {
  EmptyWidget({super.key});

  // 假資料測試
  final EventInformationShrink testShrink = EventInformationShrink(eventModel: EventModel(),);
  final EventInformationEnlarge testEnlarge = EventInformationEnlarge(eventModel: EventModel(),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CardViewTemplate(
            detailShrink: testShrink, detailEnlarge: testEnlarge),
      ),
    );
  }
}
