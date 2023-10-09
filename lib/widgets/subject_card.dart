import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../backend/parser.dart';
import '../backend/global_context.dart';
import '/widgets/subject_bottom_sheet.dart';
import '../blocState/schedule_notes_bloc_state.dart';

class subjectCard extends StatefulWidget {
  Subject subjectInfo;

  subjectCard(this.subjectInfo, {super.key});

  @override
  State<subjectCard> createState() => _subjectCardState();
}

class _subjectCardState extends State<subjectCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              context: GlobalNavigator.navigatorKey.currentContext!,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12))),
              builder: (context) {
                return SubjectBottomSheet(
                    widget.subjectInfo.data, widget.subjectInfo.subjectName);
              });
          // GlobalNavigator.navigatorKey!.currentContext!(new SnackBar(content: new Text('123')));
        },
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 4), // changes position of shadow
                      ),
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.subjectInfo.subjectName}',
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              '${widget.subjectInfo.teacher}',
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: BlocBuilder<ScheduleNotes,
                              Map<String, ScheduleNotesData>>(
                          builder: (context, state) {
                        if (state.containsKey(
                            "${widget.subjectInfo.data} - ${widget.subjectInfo.subjectName}")) {
                          var currentNotes = state[
                              "${widget.subjectInfo.data} - ${widget.subjectInfo.subjectName}"];
                          return Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(currentNotes!.selectedColor),
                            ),
                          );
                        } else {
                          return Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                          );
                        }
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Text('${widget.subjectInfo.timeStart}'),
                          Container(
                            width: 30,
                            color: Colors.black,
                            height: 1,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                          ),
                          Text('${widget.subjectInfo.timeEnd}'),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('${widget.subjectInfo.classroom}'))
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
