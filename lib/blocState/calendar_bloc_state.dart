import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarDay extends Cubit<DateTime> {
  CalendarDay()
      : super(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));

  void setCalendarDay(DateTime setDay) => emit(setDay);
}
