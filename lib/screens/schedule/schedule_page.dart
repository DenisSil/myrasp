import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstore/localstore.dart';

import '/widgets/card_day.dart';
import '/widgets/calendar.dart';
import '/blocState/schedule_notes_bloc_state.dart';
import '/backend/parser.dart';
import 'search_page.dart';

class schedulePage extends StatefulWidget {
  const schedulePage({super.key});

  @override
  State<schedulePage> createState() => _schedulePageState();
}

class _schedulePageState extends State<schedulePage> {
  var data;
  String searchType = "idGroup";
  String name = "ВКБ34";
  int group = 50884;
  bool internetConnectionState = true;
  String date = DateTime.now().toString().substring(0, 10);

  void intenetConnectionLoop() async {
    ReceivePort internetConnectionPort = ReceivePort();
    Isolate internetConnection = await Isolate.spawn(
        checkInternetContection, internetConnectionPort.sendPort);
    internetConnectionPort.listen((message) {
      setState(() {
        internetConnectionState = message;
      });
    });
  }

  @override
  initState() {
    super.initState();
    intenetConnectionLoop();
    data = getData(group, date);

    Map<String, ScheduleNotesData> notes = {};

    var db = Localstore.instance;
    db.collection('notes').get().then((value) {
      if (value != null) {
        value.forEach((key, value) {
          notes[value['id']] = (ScheduleNotesData(value['id'],
              value['localstorageId'], value['color'], value['message']));
        });
        print(notes);
        context.read<ScheduleNotes>().setScheduleNotes(notes);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return internetConnectionState == true
        ? Align(
            alignment: Alignment.topCenter,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, right: 5),
                              child: InkWell(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  focusColor: Colors.grey[400],
                                  onTap: () async {
                                    var groupId =
                                        await Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            const searchPage(),
                                        transitionDuration:
                                            const Duration(milliseconds: 250),
                                        transitionsBuilder: (_, a, __, c) =>
                                            FadeTransition(
                                                opacity: a, child: c),
                                      ),
                                    );
                                    if (groupId != null) {
                                      group = groupId;
                                      if (internetConnectionState == true) {
                                        setState(() {
                                          data = getData(group, date);
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.search,
                                          color: Colors.grey[600],
                                        ),
                                        Text('Поиск',
                                            style: TextStyle(
                                                color: Colors.grey[600]))
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          InkWell(
                            hoverColor: Colors.white,
                            highlightColor: Colors.white,
                            onTap: () async {
                              var dataDate = await showDialog(
                                  context: context,
                                  builder: (context) => CalendarAlert(
                                        month: int.parse(date.substring(5, 7)),
                                        year: int.parse(date.substring(0, 4)),
                                      ));
                              if (dataDate != null) {
                                date = dataDate;
                                if (internetConnectionState == true) {
                                  setState(() {
                                    data = getData(group, date);
                                  });
                                }
                              }
                            },
                            child: const Icon(Icons.calendar_month, size: 34),
                          )
                        ],
                      ),
                      FutureBuilder(
                          future:
                              data, // a previously-obtained Future<String> or null
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: SpinKitCircle(
                                  color: Colors.black,
                                  size: 50.0,
                                ),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              var type;

                              switch (snapshot.data!['type']) {
                                case "idGroup":
                                  type = "группы";
                                case "idAudLine":
                                  type = "аудитории";
                                case "idTeacher":
                                  type = "преподавателя";
                              }

                              return snapshot.data != null
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Text(
                                              "Расписание $type ${snapshot.data!['name']}",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            itemCount: snapshot
                                                .data!['listSubjects'].keys
                                                .toList()
                                                .length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return cardDay(
                                                  snapshot.data!['listSubjects']
                                                      [snapshot
                                                          .data!['listSubjects']
                                                          .keys
                                                          .toList()[index]]!);
                                            }),
                                      ],
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.only(top: 30),
                                      child: Text('нет данных',
                                          style: TextStyle(
                                            color: Colors.black,
                                            decoration: TextDecoration.none,
                                            fontSize: 20,
                                          )));
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else {
                              return const Text('Нет данных');
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          )
        : const Center(
            child: Text('Нет интернета',
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 20,
                )),
          );
  }
}
