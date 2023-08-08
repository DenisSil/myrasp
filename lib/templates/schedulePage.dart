
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
                      onTap: () async {
                        var selectedDate = await _selectDate(context, DateTime.parse('$date'));
                        date = selectedDate;
                        data = await getData(group, date);
                        setState(() {
                          data = data;
                        });
                      },
                      child: Icon(Icons.date_range, size: 35, color: Colors.black,),
                    ),
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
                      cardHeight = heightR(this.widget.dataOfDay.length);
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
                    itemCount: this.widget.dataOfDay.length,
                    itemBuilder: (BuildContext context, int index) {
                      return subjectCard(this.widget.dataOfDay[index]);
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


Future<String> _selectDate(BuildContext context, DateTime selectedDate) async {
  DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2024)
  );
  if (picked !=null && picked.toString().substring(0,10) != DateTime.now().toString().substring(0,10)){
    return picked.toString().substring(0,10);
  }else{
    return selectedDate.toString().substring(0,10);
  }
}