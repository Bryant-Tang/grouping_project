import 'package:flutter/material.dart';

class TitleDateOfEventVM extends ChangeNotifier {
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(days: 1));

  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;

  set startTime(DateTime newStart) {
    _startTime = newStart;
    notifyListeners();
  } 

  set endTime(DateTime newEnd) {
    _endTime = newEnd;
    notifyListeners();
  }

  
}