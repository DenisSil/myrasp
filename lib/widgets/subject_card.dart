import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/service/api_service.dart';
import '/global_context.dart';
import '/widgets/subject_bottom_sheet.dart';
import '/view_model/schedule_page_view_model.dart';

class SubjectCard extends StatefulWidget {
  Subject subjectInfo;
  SubjectCard(this.subjectInfo, {super.key});

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: GlobalNavigator.navigatorKey.currentContext!,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              builder: (context) {
                return AnimatedPadding(
                  duration: const Duration(
                    milliseconds: 150,
                  ),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SubjectBottomSheet(
                    DateFormat("MM.dd").format(widget.subjectInfo.date),
                    widget.subjectInfo.subjectName,
                  ),
                );
              });
        },
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onBackground,
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.subjectInfo.subjectName,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: Text(
                              widget.subjectInfo.teacher,
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
                            "${widget.subjectInfo.date} - ${widget.subjectInfo.subjectName}")) {
                          var currentNotes = value.model[
                              "${widget.subjectInfo.date} - ${widget.subjectInfo.subjectName}"];
                          return Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(currentNotes!.selectedColor),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.subjectInfo.timeStart,
                          ),
                          Container(
                            width: 30,
                            color: Colors.black,
                            height: 1,
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 0,
                            ),
                          ),
                          Text(
                            widget.subjectInfo.timeEnd,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              widget.subjectInfo.classroom,
                            ),
                          ),
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
