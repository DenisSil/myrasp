import 'package:flutter/material.dart';


class Alert extends StatefulWidget {

  int year;
  int month;
  int day;
  Alert({super.key, required this.year, required this.month, required this.day});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {

  var date;
  var currentMonth;
  var currentYear;
  var monthNameList = ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'];
  void setDate(value){
    setState(() {
      date = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentMonth = widget.month;
    currentYear = widget.year;
    date = DateTime(widget.year, widget.month, widget.day);
  }
  @override
  Widget build(BuildContext context) {


    return Dialog(
      alignment: Alignment.center,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        width: 300,
        height: 410,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: (){
                      setState(() {
                        if (currentMonth == 1){
                          currentMonth = 12;
                          currentYear--;
                        }else{
                          currentMonth--;
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_back)
                ),
                Text(monthNameList[currentMonth-1]),
                IconButton(
                    onPressed: (){
                      setState(() {
                        if (currentMonth == 12){
                          currentMonth = 1;
                          currentYear++;
                        }else{
                          currentMonth++;
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_forward)
                ),
              ],
            ),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 7,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.9,
                children: generate(setDate, currentYear, currentMonth, date),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${date.year}.${date.month > 9? date.month: "0${date.month}"}.${date.day > 9? date.day: "0${date.day}"}'),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9000)
                        ),

                        onPressed: (){
                          Navigator.pop(context, date);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Ok'),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}




List<Widget> generate(dynamic func, int year, int month, DateTime selectedDay){
  List<Widget> list = [];
  DateTime lastDayOfMonth = DateTime(year, month+1, 0);
  DateTime lastDayOfPerMonth = DateTime(year, month, 0);
  var listdays = ['Пн','Вт','Ср','Чт','Пт','Сб','Вс'];
  for(int i = 0;i < 7; i++){
    list.add(Center(child: Text(listdays[i])));
  }
  var day = DateTime(year, month, 1);

  list.addAll(
      List<Widget>.generate(day.weekday-1, (int index) =>
          Center(
              child: Text(
                  '${lastDayOfPerMonth.day - index}',
                  style: const TextStyle(
                      color: Colors.grey
                  )
              )
          )
      ).reversed
  );
  for(int i = 1;i < lastDayOfMonth.day+1; i++){
    list.add(calendarDay(calendarText: '$i', function: func, date: DateTime(year, month, i),  isSelectedDay: DateTime(year, month, i) == selectedDay));
  }
  list.addAll(
      List<Widget>.generate(49 - list.length, (int index) =>
          Center(
              child: Text(
                  '${index+1}',
                  style: const TextStyle(
                      color: Colors.grey
                  )
              )
          )
      )
  );

  return list;
}


class calendarDay extends StatefulWidget {

  String calendarText;
  dynamic function;
  DateTime date;
  bool isSelectedDay;
  calendarDay({super.key, required this.calendarText, required this.function, required this.date, required this.isSelectedDay});

  @override
  State<calendarDay> createState() => _calendarDayState();
}

class _calendarDayState extends State<calendarDay> {

  Color? color = Colors.white;

  @override
  Widget build(BuildContext context) {

    return Material(
      child: InkWell(
        hoverColor: Colors.blue,
        onTap: (){
          widget.function(widget.date);
        },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: MouseRegion(
          onHover: (e){
            setState(() {
              color = Colors.grey[300];
            });
          },
          onExit: (e){
            setState(() {
              color = Colors.white;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.isSelectedDay == true? Colors.amber:color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 1,
                  offset: Offset(1, 1),

                )
              ],
            ),
            child: Center(child:Text(widget.calendarText)),
          ),
        ),
      ),
    );
  }
}
