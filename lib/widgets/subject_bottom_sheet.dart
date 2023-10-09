import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';

import '../blocState/schedule_notes_bloc_state.dart';

class SubjectBottomSheet extends StatefulWidget {
  String date;
  String subjectName;

  SubjectBottomSheet(this.date, this.subjectName, {super.key});

  @override
  State<SubjectBottomSheet> createState() => _SubjectBottomSheetState();
}

class _SubjectBottomSheetState extends State<SubjectBottomSheet> {
  final _messageFieldController = TextEditingController();
  var currentNotes;
  var id;
  var selectedColor = 0xfff44336;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = "${widget.date} - ${widget.subjectName}";
    var data = context.read<ScheduleNotes>().readData();
    if (data.containsKey(id)) {
      currentNotes = data[id];
      selectedColor = currentNotes!.selectedColor;
      _messageFieldController.text = currentNotes!.message;
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();

    if (_messageFieldController.text.isEmpty && currentNotes != null) {
      context
          .read<ScheduleNotes>()
          .clearNotes(currentNotes.id, currentNotes.localstorageId);
    } else {
      if (_messageFieldController.text.isNotEmpty) {
        final db = Localstore.instance;
        final localstorageId = db.collection('notes').doc().id;
        var addedNotes = ScheduleNotesData(
            id, localstorageId, selectedColor, _messageFieldController.text);
        context.read<ScheduleNotes>().addNotes(id, addedNotes);

        db.collection('notes').doc(localstorageId).set({
          'id': addedNotes.id,
          'localstorageId': addedNotes.localstorageId,
          'color': addedNotes.selectedColor,
          'message': addedNotes.message
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 300,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Flexible(
                    child: Text(id,
                        softWrap: true,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () => setState(() {
                      selectedColor = 0xfff44336;
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xfff44336),
                      ),
                      width: selectedColor == 0xfff44336 ? 25 : 20,
                      height: selectedColor == 0xfff44336 ? 25 : 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () => setState(() {
                      selectedColor = 0xff4caf50;
                    }),
                    child: Container(
                      width: selectedColor == 0xff4caf50 ? 25 : 20,
                      height: selectedColor == 0xff4caf50 ? 25 : 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xff4caf50),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () => setState(() {
                      selectedColor = 0xff2196f3;
                    }),
                    child: Container(
                      width: selectedColor == 0xff2196f3 ? 25 : 20,
                      height: selectedColor == 0xff2196f3 ? 25 : 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xff2196f3),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () => setState(() {
                      selectedColor = 0xffffeb3b;
                    }),
                    child: Container(
                      width: selectedColor == 0xffffeb3b ? 25 : 20,
                      height: selectedColor == 0xffffeb3b ? 25 : 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffffeb3b),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 50,
              ),
              child: TextField(
                controller: _messageFieldController,
                maxLines: 30,
                cursorColor: Colors.orangeAccent,
                decoration: const InputDecoration.collapsed(
                  hintText: "Сюда можно писать текст",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
