import 'dart:isolate';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/page/settings_page/settings_page.dart';
import '/service/check_internet_service.dart';
import 'package:provider/provider.dart';

import '/widgets/card_day.dart';
import '/widgets/calendar/calendar.dart';
import '/view_model/schedule_page_view_model.dart';
import '../search_page/search_page.dart';
import 'package:gap/gap.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool internetConnectionState = true;
  var data;
  void intenetConnectionLoop() async {
    ReceivePort internetConnectionPort = ReceivePort();
    Isolate internetConnection = await Isolate.spawn(
        CheckInternetService.checkInternetContection,
        internetConnectionPort.sendPort);
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
    context.read<ScheduleNotes>().getNotes();
    context.read<SchedulePageViewModel>().getScheduleData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Consumer<SchedulePageViewModel>(builder: (context, value, child) {
      return SafeArea(
          child: internetConnectionState == true
              ? Align(
                  alignment: Alignment.topCenter,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        constraints: const BoxConstraints(
                          maxWidth: 600,
                        ),
                        child: Column(
                          children: [
                            const ScheduleSettings(),
                            value.model.data == null
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: SpinKitCircle(
                                      color: Colors.black,
                                      size: 50.0,
                                    ),
                                  )
                                : value.model.data != {}
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Text(
                                                "Расписание ${value.model.data!['type']} ${value.model.data!['name']}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              itemCount: value.model
                                                  .data!['listSubjects'].keys
                                                  .toList()
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return cardDay(value.model
                                                        .data!['listSubjects'][
                                                    value
                                                        .model
                                                        .data!['listSubjects']
                                                        .keys
                                                        .toList()[index]]!);
                                              }),
                                        ],
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.only(top: 30),
                                        child: Text('Нет данных',
                                            style: TextStyle(
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            )))
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
                ));
    });
  }
}

class ScheduleSettings extends StatelessWidget {
  const ScheduleSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SchedulePageViewModel>(
        builder: (context, value, child) => Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, right: 5),
                    child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        focusColor: Colors.grey[400],
                        onTap: () async {
                          var groupId = await Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const SearchPage(),
                              transitionDuration:
                                  const Duration(milliseconds: 250),
                              transitionsBuilder: (_, a, __, c) =>
                                  FadeTransition(opacity: a, child: c),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey[600],
                              ),
                              Text('Поиск',
                                  style: TextStyle(color: Colors.grey[600]))
                            ],
                          ),
                        )),
                  ),
                ),
                InkWell(
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
                  onTap: () async {
                    var date = value.model.date;
                    var dataDate = await showDialog(
                        context: context,
                        builder: (context) => CalendarAlert(
                              month: int.parse(date.substring(5, 7)),
                              year: int.parse(date.substring(0, 4)),
                            ));
                    if (dataDate != null) {
                      value.updateState(newDate: dataDate);
                    }
                  },
                  child: const Icon(Icons.calendar_month, size: 34),
                ),
                const Gap(20),
                InkWell(
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
                  },
                  child: const Icon(Icons.settings, size: 34),
                )
              ],
            ));
  }
}
