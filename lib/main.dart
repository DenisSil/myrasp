import 'package:flutter/material.dart';
import '/screens/notes/notesPage.dart';
import 'screens/schedule/schedulePage.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyRasp());
}

class MyRasp extends StatefulWidget {

  const MyRasp({super.key});

  @override
  State<MyRasp> createState() => MyRaspState();
}

class MyRaspState extends State<MyRasp> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
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
                  children:const <Widget>[
                    schedulePage(),
                    notesPage()
                  ],
                )
      ),
    );
  }
}








