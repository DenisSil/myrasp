import 'package:flutter/material.dart';
import 'package:myrasp/backend/supabase.dart';
import 'package:myrasp/screens/auth/signIn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class notesPage extends StatefulWidget{
  const notesPage({super.key});

  @override
  State<notesPage> createState() => _notesPageState();
}

class _notesPageState extends State<notesPage> {


  @override
  initState(){
    super.initState();
  }

  List<String> notes = [];
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(top:50),
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
      ),
    );
  }
}