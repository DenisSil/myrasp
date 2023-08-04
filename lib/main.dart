import 'dart:ui';

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

class schedulePage extends StatefulWidget{

  @override
  State<schedulePage> createState() => _schedulePageState();
}

class _schedulePageState extends State<schedulePage> {

  bool clickCard = false;

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Column(
          children: [
            Container(
                margin: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width/3,
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
                              clickCard = clickCard == true? false: true;
                            });
                      },
                    ),
                  if (clickCard) const SubjectCard()
                  ],
                ),
            ),
          ],
        );
  }
}

class notesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
        home: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Понедельник 31.08',
                style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 20,
            )),
            Icon(Icons.keyboard_arrow_down_sharp, size: 30,),
          ],
        )
    );
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Text('14:15'),
              Container(
                width: 30,
                color: Colors.black,
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
              const Text('15:50'),
              const Padding(padding:
                EdgeInsets.only(top: 10),
                child : Text('8-421')
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('пр. Аналитическая\nгеометрия'),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text('ст.пр.Артамонова Елена\nАлександровна'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



