import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/parser.dart';
import '/backend/global_context.dart';
import '/widgets/subject_bottom_sheet.dart';
import '/screens/schedule_page/schedule_page_view_model.dart';

class subjectCard extends StatefulWidget {
  Subject subjectInfo;
  subjectCard(this.subjectInfo, {super.key});

  @override
  State<subjectCard> createState() => _subjectCardState();
}

class _subjectCardState extends State<subjectCard> {
  var subjectKey = GlobalKey();

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
          //returns null:
          final cardContext = subjectKey.currentContext;
          // final context = subjectKey.currentContext!;
          //Error: The getter 'context' was called on null.
          print(cardContext!.size!.height);

          showModalBottomSheet(
              isScrollControlled: true,
              context: GlobalNavigator.navigatorKey.currentContext!,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12))),
              builder: (context) {
                return AnimatedPadding(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SubjectBottomSheet(widget.subjectInfo.data,
                        widget.subjectInfo.subjectName));
              });
        },
        child: Column(
          key: subjectKey,
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
                      child: Consumer<ScheduleNotes>(
                          builder: (context, value, child) {
                        if (value.model.containsKey(
                            "${widget.subjectInfo.data} - ${widget.subjectInfo.subjectName}")) {
                          var currentNotes = value.model[
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
