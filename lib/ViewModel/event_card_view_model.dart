import 'package:flutter/material.dart';
import 'package:grouping_project/model/model_lib.dart';

class EventCardViewModel extends ChangeNotifier {
  late EventModel eventModel;

  EventCardViewModel(EventModel? event) {
    eventModel = event ?? EventModel();
  }

  String get id => eventModel.id ?? '0';
  String get group => eventModel.ownerName;
  String get title => eventModel.title ?? 'unknown';
  String get descript => eventModel.introduction ?? 'unknown';
  DateTime get startTime => eventModel.startTime ?? DateTime.now();
  DateTime get endTime => eventModel.endTime ?? DateTime.now().add(const Duration(days: 1));
  List<String> get contributorIds => eventModel.contributorIds ?? [];
  Color get color => Color(eventModel.color);

  void updateEvent(TextEditingController titleCrtl, TextEditingController descriptCrtl) async {
    await DataController().upload(
        uploadData: EventModel(
            id: id,
            title: titleCrtl.text,
            introduction: descriptCrtl.text,
            startTime: startTime,
            endTime: endTime,
            contributorIds: contributorIds));
  }

  void removeEvent() async {
    await DataController().remove(removeData: eventModel);
  }

}