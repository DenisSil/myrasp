import 'package:flutter/material.dart';
import 'package:myrasp/screens/auth/signIn.dart';
import '/screens/notes/notesPage.dart';
import 'backend/supabase.dart';
import 'package:provider/provider.dart';
import 'screens/schedule/schedulePage.dart';
import 'backend/User.dart';




void main() async{
  await supabaseInit();
  runApp(
      ChangeNotifierProvider(
        create: (context) => GetUser(),
          builder: (context, provider) => MyRasp()
      )
  );
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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Provider.of<GetUser>(context, listen: false).addUser(SupabaseReferense().getUser()));


  }

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
          body: Consumer<GetUser>(
              builder:(context, notifier, child) {
                return IndexedStack(
                  index: currentPageIndex,
                  children: <Widget>[
                    const schedulePage(),
                    notifier.user == null? const signIn(): const notesPage()
                  ],
                );
              }
      ),
      )
    );
  }
}








