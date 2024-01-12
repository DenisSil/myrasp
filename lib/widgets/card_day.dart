import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../service/api_secvice.dart';
import 'subject_card.dart';

class cardDay extends StatefulWidget {
  List<Subject> _dataOfDay;
  cardDay(this._dataOfDay, {super.key});

  @override
  State<cardDay> createState() => _cardDayState();
}

class _cardDayState extends State<cardDay> {
  bool _clickCard = false;
  late String _todayDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var dateTimeFormat = DateFormat('MM.dd');
    _todayDay = dateTimeFormat.format(DateTime.now());

    if (widget._dataOfDay[0].data == _todayDay) {
      _clickCard = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ]),
        child: AnimatedSize(
          alignment: Alignment.topCenter,
          duration: const Duration(milliseconds: 300),
          child: Column(
            children: [
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${widget._dataOfDay[0].data} - ${widget._dataOfDay[0].dayOfTheWeek}',
                        style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 20,
                        )),
                    if (_clickCard)
                      const Icon(
                        Icons.keyboard_arrow_up_outlined,
                        size: 30,
                      )
                    else
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 30,
                      )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _clickCard = !_clickCard;
                  });
                },
              ),
              if (_clickCard)
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 8),
                        itemCount: widget._dataOfDay.length,
                        itemBuilder: (BuildContext context, int index) {
                          return subjectCard(widget._dataOfDay[index]);
                        }))
            ],
          ),
        ));
  }
}
