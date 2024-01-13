import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/view_model/schedule_page_view_model.dart';
import 'calendar_state.dart';

class CalendarAlert extends StatefulWidget {
  int year;
  int month;
  CalendarAlert({super.key, required this.year, required this.month});

  @override
  State<CalendarAlert> createState() => _CalendarAlertState();
}

class _CalendarAlertState extends State<CalendarAlert> {
  late int _currentMonth;
  late int _currentYear;
  final _monthNameList = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь'
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.month;
    _currentYear = widget.year;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        width: 300,
        height: 430,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_currentMonth == 1) {
                          _currentMonth = 12;
                          _currentYear--;
                        } else {
                          _currentMonth--;
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_back)),
                Text(_monthNameList[_currentMonth - 1]),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_currentMonth == 12) {
                          _currentMonth = 1;
                          _currentYear++;
                        } else {
                          _currentMonth++;
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_forward)),
              ],
            ),
            Expanded(
              child: GridView.count(
                  shrinkWrap: false,
                  crossAxisCount: 7,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.9,
                  children: generateCalendarDays(_currentYear, _currentMonth)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Consumer<CalendarDay>(
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(DateFormat('dd.MM.yyyy').format(value.state)),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9000)),
                          onPressed: () {
                            Navigator.pop(context, value.state);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Ok'),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<Widget> generateCalendarDays(int year, int month) {
  // генерирует список дней календаря на выбранный месяц
  List<Widget> list = [];
  DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
  DateTime lastDayOfPerMonth = DateTime(year, month, 0);
  var listdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  for (int i = 0; i < 7; i++) {
    list.add(Center(child: Text(listdays[i])));
  }
  var day = DateTime(year, month, 1);

  list.addAll(List<Widget>.generate(
    day.weekday - 1,
    (int index) => Center(
        child: Text('${lastDayOfPerMonth.day - index}',
            style: const TextStyle(color: Colors.grey))),
  ).reversed);
  for (int i = 1; i < lastDayOfMonth.day + 1; i++) {
    list.add(Consumer<CalendarDay>(
        builder: (context, value, child) => calendarDay(
            calendarText: '$i',
            date: DateTime(year, month, i),
            isSelectedDay: DateTime(year, month, i) == value.state)));
  }
  list.addAll(List<Widget>.generate(
      49 - list.length,
      (int index) => Center(
          child: Text('${index + 1}',
              style: const TextStyle(color: Colors.grey)))));

  return list;
}

class calendarDay extends StatefulWidget {
  String calendarText;

  DateTime date;
  bool isSelectedDay;
  calendarDay(
      {super.key,
      required this.calendarText,
      required this.date,
      required this.isSelectedDay});

  @override
  State<calendarDay> createState() => _calendarDayState();
}

class _calendarDayState extends State<calendarDay> {
  List<ScheduleNotesData> notesOfDay = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var scheduleNotesData =
        Provider.of<ScheduleNotes>(context, listen: false).model;
    var date =
        "${widget.date.month > 9 ? widget.date.month : "0${widget.date.month}"}.${widget.date.day > 9 ? widget.date.day : "0${widget.date.day}"}";

    for (var scheduleNotesId in scheduleNotesData.keys) {
      if (scheduleNotesId.contains(date)) {
        notesOfDay.add(scheduleNotesData[scheduleNotesId]!);
        break;
      }
    }

    if (notesOfDay.isNotEmpty) {
      setState(() {
        notesOfDay = notesOfDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        hoverColor: Colors.blue,
        onTap: () => context.read<CalendarDay>().setCalendarDay(widget.date),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isSelectedDay == true ? Colors.amber : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 1,
                offset: Offset(1, 1),
              )
            ],
          ),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(widget.calendarText),
                notesOfDay.isEmpty
                    ? const SizedBox(
                        height: 1,
                        width: 1,
                      )
                    : Container(
                        width: 5,
                        height: 5,
                        color: Colors.red,
                      )
              ])),
        ),
      ),
    );
  }
}
