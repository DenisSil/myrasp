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
      padding: const EdgeInsets.only(top:5, left: 10, right: 10, bottom: 5),
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
      child: Row(
          children: [
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${subjectInfo.subjectName}', softWrap: true,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),

                      child: Text('${subjectInfo.teacher}',
                          softWrap: true,
                        style: const TextStyle(
                          fontSize: 13,
                        ),),
                    ),
                  ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
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
            ),
          ],
        ),
    );
  }
}