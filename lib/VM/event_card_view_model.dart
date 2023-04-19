import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';

class EventCardViewModel extends ChangeNotifier {
  late EventModel eventModel;

  EventCardViewModel(EventModel? event) {
    eventModel = event ?? EventModel();
  }

  String get id => eventModel.id ?? '0';
  String get group => eventModel.ownerName;
  String get title => eventModel.title;
  String get descript => eventModel.introduction;
  DateTime get startTime => eventModel.startTime;
  DateTime get endTime => eventModel.endTime;
  List<String> get contributorIds => eventModel.contributorIds;
  Color get color => Color(eventModel.color);

  void updateEvent(TextEditingController titleCrtl, TextEditingController descriptCrtl, DateTime startTime, DateTime endTime, List<String> contributorIds) async {

    // await DataController().upload(
    //     uploadData: EventModel(
    //         id: id,
    //         title: titleCrtl.text,
    //         introduction: descriptCrtl.text,
    //         startTime: startTime,
    //         endTime: endTime,
    //         contributorIds: contributorIds));
  }

  void removeEvent() async {
    // await DataController().remove(removeData: eventModel);
  }

}
