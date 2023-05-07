import 'package:flutter/material.dart';
import 'package:googleapis/bigquerydatatransfer/v1.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/model/data_model.dart';
import 'package:grouping_project/service/service_lib.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewModel extends ChangeNotifier {
  // late Map<DateTime, List<BaseDataModel>> _map;
  // late CalendarSource _activitySource;

  // CalendarViewModel() {
  //   _activitySource = CalendarSource(_map);
  //   debugPrint('I did it');
  // }

  // Map<DateTime, List<BaseDataModel>> get activityListMap =>
  //     _activitySource.activities;
  // CalendarSource get activitySource => _activitySource;

  // onDayTappd() {}
  // onFormatChanged() {}
  // getActivityForLabel() {}
  // getActivityForDots() {}
}

class CalendarSource extends CalendarDataSource {
  // Map<DateTime, List<BaseDataModel>> _activities = {};

  // CalendarSource(Map<DateTime, List<BaseDataModel>> source) {
  //   _activities.addEntries(source.entries);
  // }

  // Map<DateTime, List<BaseDataModel>> get activities => _activities;
}
