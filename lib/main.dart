import 'dart:io';
import 'dart:ui';
import 'parser.dart';
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyRasp());

class MyRasp extends StatelessWidget {
  const MyRasp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyApp());
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
      body: Center( child:<Widget>[
        schedulePage(),
        notesPage(),
      ][currentPageIndex],
      )
    );
  }
}

class schedulePage extends StatefulWidget {

  @override
  State<schedulePage> createState() => _schedulePageState();
}

class _schedulePageState extends State<schedulePage> {
  
  bool clickCard = false;
  double cardHeight = 70;
  var data;

  void getSubjects() async {
    data = await getData(43732, '2023-04-13');
  }

  double heightR(){
    return (70+(data[data.keys.toList()[0]].length*145)).toDouble();
  }

  @override
  initState() {
    super.initState();
    getSubjects();
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
              children: [
          AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          height: cardHeight,
          duration: const Duration(milliseconds: 500),
          child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
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
                                    const Text('Понедельник 31.08',
                                        style: TextStyle(
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
                                    cardHeight = heightR();
                                    Future.delayed(const Duration(milliseconds: 500), () => setState((){clickCard = true;}));
                                  }else{
                                    clickCard = false;
                                    cardHeight = 70;
                                  }

                                });
                          },
                        ),
                      if (clickCard)
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 8),
                            itemCount: data[data.keys.toList()[0]].length,
                            itemBuilder: (BuildContext context, int index) {
                              print(data[data.keys.toList()[0]][index].subjectName);
                            return subjectCard(data[data.keys.toList()[0]][index]);
            }
        )
                      ],
                    ),
                )
          ),
              ],
            ),
      ),
    );
  }
}

class notesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Text('123');
  }
}

Widget subjectCard(Subject subjectInfo) {
    return subjectCardTemplate(subjectInfo);

}
class subjectCardTemplate extends StatelessWidget {

  Subject subjectInfo;
  subjectCardTemplate(this.subjectInfo);

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${subjectInfo.subjectName}'),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text('${subjectInfo.teacher}'),
                          ),
                        ],
                      ),
                  )
              ],
          ),
    );
  }
}



