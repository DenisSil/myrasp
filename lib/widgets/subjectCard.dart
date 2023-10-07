import 'package:flutter/material.dart';
import '../backend/parser.dart';
Widget subjectCard(Subject subjectInfo) {
  return subjectCardTemplate(subjectInfo);

}

class subjectCardTemplate extends StatefulWidget {

  Subject subjectInfo;
  subjectCardTemplate(this.subjectInfo, {super.key});

  @override
  State<subjectCardTemplate> createState() => _subjectCardTemplateState();
}

class _subjectCardTemplateState extends State<subjectCardTemplate> {

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {



    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ]
              ),
              child :Row(
                  children: [
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.subjectInfo.subjectName}', softWrap: true,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),

                              child: Text('${widget.subjectInfo.teacher}',
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
                          Text('${widget.subjectInfo.timeStart}'),
                          Container(
                            width: 30,
                            color: Colors.black,
                            height: 1,
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                          ),
                          Text('${widget.subjectInfo.timeEnd}'),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child : Text('${widget.subjectInfo.classroom}')
                          )
                        ],
                      ),
                    ),
                  ],
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      isSelected = true;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected == true? Colors.green: Colors.white,
                      border: Border.all(color: Colors.green),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8))
                    ),
                    child: Center(
                      child: Text(
                          'Добавить',
                          style: TextStyle(
                            color: isSelected == true? Colors.white: Colors.green
                          )
                      )
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}