import 'package:flutter/material.dart';
import 'dart:isolate';

import '../parser.dart';

import 'templates/schedulePage.dart';
import 'templates/notesPage.dart';
import 'templates/InternetConnectionIsFalse.dart';

void main() => runApp(const DonstuRasp());


class DonstuRasp extends StatefulWidget {

  const DonstuRasp({super.key});

  @override
  State<DonstuRasp> createState() => DonstuRaspState();
}

class DonstuRaspState extends State<DonstuRasp> {

  int currentPageIndex = 0;
  bool internetConnectionState = true;

  void intenetConnectionLoop() async{
    ReceivePort internetConnectionPort = ReceivePort();
    Isolate internetConnection = await Isolate.spawn(checkInternetContection, internetConnectionPort.sendPort);
    internetConnectionPort.listen((message) {
      setState(() {
        internetConnectionState = message; 
      });  
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    intenetConnectionLoop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
          children: const <Widget>[
            schedulePage(),
            notesPage(),
          ],
        )
      ),
    );
  }
}








