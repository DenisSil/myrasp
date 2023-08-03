import 'package:flutter/material.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
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
      body: <Widget>[
        schedulePage(),
        notesPage(),
      ][currentPageIndex],
    );
  }
}

class schedulePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  MaterialApp(
        home: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width/3,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 0,
                        offset: const Offset(1, 2), // changes position of shadow
                      ),
                    ]
                ),
                child: InkWell(
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text('Понедельник 31.08',
                                style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 20,
                                )
                            ),
                            Icon(Icons.keyboard_arrow_down_sharp, size: 30,),
                        ],
                    ),
                  onTap: (){
                      print('нажал');
                  },
                )
              ),
          ],

        )
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