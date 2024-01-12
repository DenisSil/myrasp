import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/view_model/schedule_page_view_model.dart';

class SubjectBottomSheet extends StatefulWidget {
  String date;
  String subjectName;

  SubjectBottomSheet(this.date, this.subjectName, {super.key});

  @override
  State<SubjectBottomSheet> createState() => _SubjectBottomSheetState();
}

class _SubjectBottomSheetState extends State<SubjectBottomSheet> {
  final _messageFieldController = TextEditingController();
  late ScheduleNotesData _currentNotes;
  late String _id;
  late Map<String, ScheduleNotesData> _data;
  int _selectedColor = 0xfff44336;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = "${widget.date} - ${widget.subjectName}";
    _data = context.read<ScheduleNotes>().model;
    if (_data.containsKey(_id)) {
      _currentNotes = _data[_id]!;
      _selectedColor = _currentNotes.selectedColor;
      _messageFieldController.text = _currentNotes.message;
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();

    var scheduleNotesViewModel = context.read<ScheduleNotes>();
    if (_data.containsKey(_id)) {
      if (_messageFieldController.text.isEmpty) {
        scheduleNotesViewModel.clearNotes(_id, _currentNotes.localstorageId);
      }
      return;
    }
    if (_messageFieldController.text.isNotEmpty) {
      scheduleNotesViewModel.addNotes(
          _id, _selectedColor, _messageFieldController.text);
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
                    child: Text(_id,
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
                      _selectedColor = 0xfff44336;
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xfff44336),
                      ),
                      width: _selectedColor == 0xfff44336 ? 25 : 20,
                      height: _selectedColor == 0xfff44336 ? 25 : 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () => setState(() {
                      _selectedColor = 0xff4caf50;
                    }),
                    child: Container(
                      width: _selectedColor == 0xff4caf50 ? 25 : 20,
                      height: _selectedColor == 0xff4caf50 ? 25 : 20,
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
                      _selectedColor = 0xff2196f3;
                    }),
                    child: Container(
                      width: _selectedColor == 0xff2196f3 ? 25 : 20,
                      height: _selectedColor == 0xff2196f3 ? 25 : 20,
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
                      _selectedColor = 0xffffeb3b;
                    }),
                    child: Container(
                      width: _selectedColor == 0xffffeb3b ? 25 : 20,
                      height: _selectedColor == 0xffffeb3b ? 25 : 20,
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
