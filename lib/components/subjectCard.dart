import 'package:flutter/material.dart';

import '/parser.dart';

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