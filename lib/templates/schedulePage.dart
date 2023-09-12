import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '/parser.dart';

import '/components/cardDay.dart';
import '/components/calendar.dart';

import 'searchPage.dart';


class schedulePage extends StatefulWidget {

  const schedulePage({super.key});

  @override
  State<schedulePage> createState() => _schedulePageState();
}

class _schedulePageState extends State<schedulePage> {

  var data;
  int group = 50884;
  String date = DateTime.now().toString().substring(0,10);

  @override
  initState() {
    super.initState();
    data = getData(group, date);
    
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Align(
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
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const searchPage(),
                                transitionDuration: const Duration(milliseconds: 250),
                                transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                              ),
                            );
                            if (groupId != null){
                              group = groupId;
                              setState(() {
                                data = getData(group,date);
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
                      highlightColor: Colors.white,
                      onTap:() async {
                        var dataDate = await showDialog(context: context, builder: (context) => Alert(month: int.parse(date.substring(5,7)),year: int.parse(date.substring(0,4)),day: int.parse(date.substring(8,))));
                        if (dataDate  != null){
                          date = '${dataDate.year}-${dataDate.month > 9? dataDate.month: "0${dataDate.month}"}-${dataDate.day > 9? dataDate.day: "0${dataDate.day}"}';
                          setState(() {
                            data = getData(group,date);
                          });
                        }
                      },
                      child: const Icon(Icons.calendar_month, size: 34),
                    )
                  ],
                ),

                FutureBuilder(
                  future: data, // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<Map<String,List<Subject>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: SpinKitCircle(
                            color: Colors.black,
                            size: 50.0,
                          ),
                        );
                      }else if(snapshot.connectionState == ConnectionState.done){
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 8),
                          itemCount: snapshot.data!.keys
                              .toList()
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                          return cardDayTemplate(snapshot.data![snapshot.data!.keys
                              .toList()[index]]!);
                          }
                        );

                    }else if (snapshot.hasError){
                        return Text(snapshot.error.toString());
                    }else{
                        return Text('Нет данных');
                      }
                  }
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}