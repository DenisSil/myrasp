
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../parser.dart';
import 'searchPage.dart';

class schedulePage extends StatefulWidget {

  const schedulePage({super.key});

  @override
  State<schedulePage> createState() => _schedulePageState();
}

class _schedulePageState extends State<schedulePage> {

  var data = {};
  int group = 43732;
  String date = DateTime.now().toString().substring(0,10);

  @override
  initState() {
    super.initState();
    getData(group, date).then((value) => data = value);
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return data == {}? const Center(
      child: SpinKitFadingCircle(
        color:Colors.black,
        size: 40,
      ),
    )
    : Align(
      alignment: Alignment.topCenter,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              children: [

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, left: 20, right: 5),
                        child:
                        InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          focusColor: Colors.grey[400],
                          onTap: ()async{
                            var groupId = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const searchPage(),
                              ),
                            );
                            if (groupId != null){
                              setState(() {
                                data = {};
                              });
                              group = groupId;
                              data = await getData(group, date);
                              setState(() {
                                data = data;
                              });
                            }
                            },
                          child:
                          Container(
                            decoration:
                            BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: const EdgeInsets.only(top:10,bottom: 10, left: 10),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey[600],),
                                Text('Поиск',
                                    style: TextStyle(
                                        color: Colors.grey[600]
                                    )
                                )
                              ],
                            ),
                          )
                        ),
                      ),
                    ),
                    InkWell(
                      hoverColor: Colors.white,
                      onTap:() async {
                        var dataDate = await showDialog(context: context, builder: (context) => Alert(month: int.parse(date.substring(5,7)),year: int.parse(date.substring(0,4)),));
                        if (dataDate  != null){
                          date = '${dataDate.year}-${dataDate.month > 9? dataDate.month: "0${dataDate.month}"}-${dataDate.day > 9? dataDate.day: "0${dataDate.day}"}';
                          data = await getData(group, date);
                          setState(() {
                            data = data;
                          });
                        }
                      },
                      child: const Icon(Icons.calendar_month, size: 34),
                    )
                  ],
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: data.keys.toList().length,
                    itemBuilder: (BuildContext context, int index) {
                      return cardDayTemplate( data[data.keys.toList()[index]]);
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class cardDayTemplate extends StatefulWidget {

  List<Subject> dataOfDay;
  cardDayTemplate(this.dataOfDay, {super.key});

  @override
  State<cardDayTemplate> createState() => _cardDayTemplateState();
}

class _cardDayTemplateState extends State<cardDayTemplate> {

  bool clickCard = false;
  double cardHeight = 60;
  double heightR(cardsCount){
    return (60+(cardsCount*145)+20).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        height: cardHeight,
        duration: const Duration(milliseconds: 500),
        child: Container(
          margin: const EdgeInsets.only(top: 10, left: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ]
          ),
          child: Column(
            children: [
              InkWell(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${this.widget.dataOfDay[0].data} - ${this.widget.dataOfDay[0].dayOfTheWeek}',
                        style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 20,
                        )
                    ),
                    if (clickCard)  const Icon(Icons.keyboard_arrow_up_outlined, size: 30,)
                    else const Icon(Icons.keyboard_arrow_down_outlined, size: 30,)
                  ],
                ),
                onTap: (){
                  setState(() {

                    if(!clickCard){
                      cardHeight = heightR(widget.dataOfDay.length);
                      Future.delayed(const Duration(milliseconds: 500), () => setState((){clickCard = true;}));
                    }else{
                      clickCard = false;
                      cardHeight = 60;
                    }

                  });
                },
              ),
              if (clickCard)
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: widget.dataOfDay.length,
                    itemBuilder: (BuildContext context, int index) {
                      return subjectCard(widget.dataOfDay[index]);
                    }
                )
            ],
          ),
        )
    );
  }
}



Widget subjectCard(Subject subjectInfo) {
  return subjectCardTemplate(subjectInfo);

}

class subjectCardTemplate extends StatelessWidget {

  Subject subjectInfo;
  subjectCardTemplate(this.subjectInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ]
      ),
      child:  Row(
        children: [
          Column(
            children: [
              Text('${subjectInfo.timeStart}'),
              Container(
                width: 30,
                color: Colors.black,
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
              Text('${subjectInfo.timeEnd}'),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child : Text('${subjectInfo.classroom}')
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${subjectInfo.subjectName}', softWrap: true),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text('${subjectInfo.teacher}', softWrap: true),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Alert extends StatefulWidget {

  int year;
  int month;
  Alert({super.key, required this.year, required this.month});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {

  DateTime date = DateTime.now();
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
                children: generate(setDate, currentYear, currentMonth),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context, date);
                      },
                    child: const Text('Ok')),
              ),
            )
          ],
        ),
      ),
    );
  }
}




List<Widget> generate(dynamic func, int year, int month){
  List<Widget> list = [];
  DateTime lastDayOfMonth = DateTime(year, month+1, 0);

  var listdays = ['Пн','Вт','Ср','Чт','Пт','Сб','Вс'];
  for(int i = 0;i < 7; i++){
    list.add(Center(child: Text(listdays[i])));
  }
  var day = DateTime(year, month, 1);
  var days = List<Widget>.generate(day.weekday-1, (int index) => const Center(child: Text('')));
  list.addAll(days);
  for(int i = 1;i < lastDayOfMonth.day+1; i++){
    list.add(calendarDay(calendarText: '$i', function: func, date: DateTime(year, month, i),));
  }

  return list;
}


class calendarDay extends StatefulWidget {
  
  String calendarText;
  dynamic function;
  DateTime date;
  calendarDay({super.key, required this.calendarText, required this.function, required this.date});

  @override
  State<calendarDay> createState() => _calendarDayState();
}

class _calendarDayState extends State<calendarDay> {

  bool clickDay = false;

  @override
  Widget build(BuildContext context) {

    return Material(
      child: InkWell(
        onTap: (){
          widget.function(widget.date);
          setState(() {
            clickDay = true;
          });
        },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: clickDay == false? Colors.white: Colors.grey,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 1,
                  offset: Offset(1, 1)
              )
            ],
          ),
          child: Center(child:Text(widget.calendarText)),
        ),
      ),
    );
  }
}

