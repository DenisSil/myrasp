import 'parser.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'searchPage.dart';


void main() => runApp(const MyRasp());

class MyRasp extends StatelessWidget {
  const MyRasp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: MyApp()
    );
  }
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 70,
        indicatorColor: Colors.orange[500],
          backgroundColor: Colors.orange[400],
          onDestinationSelected: (int index) {
              setState(() {
                  currentPageIndex = index;
              });
          },

        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.list),
            label: '',

          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_sharp),
            label: '',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children:<Widget>[
          schedulePage(),
          notesPage(),
        ],
      )
    );
  }
}

class schedulePage extends StatefulWidget {

  const schedulePage({super.key});

  @override
  State<schedulePage> createState() => _schedulePageState();
}

class _schedulePageState extends State<schedulePage> {

  var data = {};
  int group = 43732;

  @override
  initState() {
    super.initState();
    getData(group).then((value) => data = value);
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return data == {}? const Center(
      child: SpinKitFadingCircle(
        color:Colors.black,
        size: 40,
      ),
    )
    : Align(
      alignment: Alignment.topCenter,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child:
                  InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    focusColor: Colors.grey[400],
                    onTap: ()async{
                      var groupId = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const searchPage(),
                        ),
                      );
                      if (groupId != null){

                        data = {};
                        group = groupId;
                        data = await getData(group);
                        setState(() {
                          data = data;
                        });
                      }
                      },
                    child:
                    Container(
                      decoration:
                      BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[600],),
                          Text('Поиск',
                              style: TextStyle(
                                  color: Colors.grey[600]
                              )
                          )
                        ],
                      ),
                    )
                  ),
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: data.keys.toList().length,
                    itemBuilder: (BuildContext context, int index) {
                      return cardDayTemplate( data[data.keys.toList()[index]]);
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Widget cardDayTemplate(List<Subject> dataOfDay) {
  return cardDay(dataOfDay);
}

class cardDay extends StatefulWidget {

  List<Subject> dataOfDay;
  cardDay(this.dataOfDay, {super.key});

  @override
  State<cardDay> createState() => _cardDayState();
}

class _cardDayState extends State<cardDay> {

  bool clickCard = false;
  double cardHeight = 60;
  double heightR(cardsCount){
    return (60+(cardsCount*145)+20).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        height: cardHeight,
        duration: const Duration(milliseconds: 500),
        child: Container(
          margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
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
                    Text('${this.widget.dataOfDay[0].data} - ${this.widget.dataOfDay[0].dayOfTheWeek}',
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
                      cardHeight = heightR(this.widget.dataOfDay.length);
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
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: this.widget.dataOfDay.length,
                    itemBuilder: (BuildContext context, int index) {
                      return subjectCard(this.widget.dataOfDay[index]);
                    }
                )
            ],
          ),
        )
    );
  }
}


class notesPage extends StatefulWidget{
  const notesPage({super.key});

  @override
  State<notesPage> createState() => _notesPageState();
}

class _notesPageState extends State<notesPage> {

  List<String> notes = [];
  final TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child:Column(
          children: [
            Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.only(top:5, bottom: 5),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black))
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Text( notes[index],
                                style: const TextStyle(
                                fontSize: 16,
                              )
                            ),
                            IconButton(onPressed: (){
                                  setState(() {
                                    notes.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.clear),
                                iconSize: 20,
                            splashRadius: 20,)
                      ])
                  );
                }
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black)
              )
            ),
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: TextField(
              controller: _controller,
              onSubmitted: (value){
                setState(() {
                  notes.add(value);
                  _controller.clear();
                });
              },
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '',
              ),
            ),
          )
        ],
      ),
      )
    );
  }
}

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



