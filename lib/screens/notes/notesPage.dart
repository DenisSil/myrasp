import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import '/backend/Notes.dart';

class notesPage extends StatefulWidget{

  const notesPage({super.key});

  @override
  State<notesPage> createState() => _notesPageState();
}

class _notesPageState extends State<notesPage> {

  List<Notes> notes = [];

  @override
  initState(){
    super.initState();

    final db = Localstore.instance;

    db.collection('notes').get().then((value){
      if(value != null){
        value.forEach((key, value) {
          notes.add(Notes(id: value['id'], message: value['message']));
        });
        setState(() {
          notes = notes;
        });
      }
    });

  }


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
                                    Text( notes[index].message,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        )
                                    ),
                                    IconButton(onPressed: (){
                                      notes[index].delete_notes();
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
                          final db = Localstore.instance;
                          final id = db.collection('notes').doc().id;
                          db.collection('notes').doc(id).set({
                            'id':id,
                            'message': _controller.text
                          });
                          setState(() {
                            notes.add(Notes(id:id,message: _controller.text));
                          });
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