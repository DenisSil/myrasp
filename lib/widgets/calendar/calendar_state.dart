import 'package:flutter/material.dart';

class CalendarDay with ChangeNotifier {
  DateTime _state =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime get state => _state;

  void setCalendarDay(DateTime setDay) {
    _state = setDay;
    notifyListeners();
  }
}
