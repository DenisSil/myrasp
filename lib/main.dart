

import 'package:flutter/material.dart';
import '/screens/notes/notesPage.dart';

import 'backend/supabase.dart';


import 'screens/schedule/schedulePage.dart';
import 'screens/auth/signIn.dart';


void main() {
  supabaseInit();
  runApp(const MyRasp());
}

class MyRasp extends StatefulWidget {

  const MyRasp({super.key});

  @override
  State<MyRasp> createState() => MyRaspState();
}

class MyRaspState extends State<MyRasp> {

  int currentPageIndex = 0;
  var user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), (){
      setState(() {
        user = SupabaseReferense().getUser();
      });
    });


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








