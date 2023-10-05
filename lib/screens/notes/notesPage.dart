import 'package:flutter/material.dart';
import '/backend/supabase.dart';
import 'package:provider/provider.dart';
import '/backend/User.dart';
class notesPage extends StatefulWidget{


  const notesPage({super.key});

  @override
  State<notesPage> createState() => _notesPageState();
}

class _notesPageState extends State<notesPage> {

  var supabase;

  @override
  initState(){
    super.initState();
    supabase = SupabaseReferense();
  }

  List<String> notes = [];
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(top:50),
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child:Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        splashColor: Colors.white,
                        hoverColor: Colors.white,
                        highlightColor: Colors.white,
                        onPressed: () async{
                            Provider.of<GetUser>(context, listen: false).cleanUser();
                            supabase.userOut();
                        },
                        icon: const Icon(Icons.exit_to_app),
                        iconSize: 20,
                      )
                    ],
                  ),
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
            )
      ),
    );
  }
}