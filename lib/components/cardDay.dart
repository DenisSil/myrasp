import 'package:flutter/material.dart';
import '../backend/parser.dart';

import 'subjectCard.dart';

class cardDayTemplate extends StatefulWidget {

  List<Subject> dataOfDay;
  String todayDay;
  cardDayTemplate(this.dataOfDay, this.todayDay, {super.key});

  @override
  State<cardDayTemplate> createState() => _cardDayTemplateState();
}

class _cardDayTemplateState extends State<cardDayTemplate> {

  bool clickCard = false;
  double cardHeight = 60;
  double heightR(cardsCount){
    return (60+(cardsCount*140)+50).toDouble();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if(widget.dataOfDay[0].data == widget.todayDay){
        cardHeight = heightR(widget.dataOfDay.length);
        clickCard = true;
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        height: cardHeight,
        duration: const Duration(milliseconds: 500),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ]
          ),
          child: Column(
            children: [
              InkWell(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.dataOfDay[0].data} - ${widget.dataOfDay[0].dayOfTheWeek}',
                        style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 20,
                        )
                    ),
                    if (clickCard)  const Icon(Icons.keyboard_arrow_up_outlined, size: 30,)
                    else const Icon(Icons.keyboard_arrow_down_outlined, size: 30,)
                  ],
                ),
                onTap: (){
                  setState(() {

                    if(!clickCard){
                      cardHeight = heightR(widget.dataOfDay.length);
                      Future.delayed(const Duration(milliseconds: 500), () => setState((){clickCard = true;}));
                    }else{
                      clickCard = false;
                      cardHeight = 60;
                    }

                  });
                },
              ),
              if (clickCard)
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: widget.dataOfDay.length,
                    itemBuilder: (BuildContext context, int index) {
                      return subjectCard(widget.dataOfDay[index]);
                    }
                )
            ],
          ),
        )
    );
  }
}
