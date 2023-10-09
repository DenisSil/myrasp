import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocState/calendar_bloc_state.dart';

class CalendarAlert extends StatefulWidget {
  int year;
  int month;

  CalendarAlert({super.key, required this.year, required this.month});

  @override
  State<CalendarAlert> createState() => _CalendarAlertState();
}

class _CalendarAlertState extends State<CalendarAlert> {
  var currentMonth;
  var currentYear;
  var monthNameList = [
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
    // TODO: implement initState
    super.initState();
    currentMonth = widget.month;
    currentYear = widget.year;
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
                        if (currentMonth == 1) {
                          currentMonth = 12;
                          currentYear--;
                        } else {
                          currentMonth--;
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_back)),
                Text(monthNameList[currentMonth - 1]),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (currentMonth == 12) {
                          currentMonth = 1;
                          currentYear++;
                        } else {
                          currentMonth++;
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_forward)),
              ],
            ),
            Expanded(
              child: GridView.count(
                shrinkWrap: false,
                // убрать скролл
                crossAxisCount: 7,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.9,
                children: generateCalendarDays(currentYear, currentMonth),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: BlocBuilder<CalendarDay, DateTime>(
                builder: (context, state) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                        '${state.day > 9 ? state.day : "0${state.day}"}.${state.month > 9 ? state.month : "0${state.month}"}.${state.year}'),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9000)),
                          onPressed: () {
                            Navigator.pop(context,
                                '${state.year}-${state.month > 9 ? state.month : "0${state.month}"}-${state.day > 9 ? state.day : "0${state.day}"}');
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
    list.add(BlocBuilder<CalendarDay, DateTime>(
        builder: (context, state) => calendarDay(
            calendarText: '$i',
            date: DateTime(year, month, i),
            isSelectedDay: DateTime(year, month, i) == state)));
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
          child: Center(child: Text(widget.calendarText)),
        ),
      ),
    );
  }
}
