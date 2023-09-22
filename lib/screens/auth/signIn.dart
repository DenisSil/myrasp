import 'package:flutter/material.dart';
import '/screens/notes/notesPage.dart';

import '/backend/supabase.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {

  var _loginFieldController;
  var _passwordFieldController;

  var supabase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    supabase = SupabaseReferense();

    _loginFieldController = TextEditingController();
    _passwordFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Войти',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10),
                child: Container(
                  height: 50,
                  constraints: const BoxConstraints(
                    maxWidth: 300,
                  ),
                  child: TextField(
                    controller: _loginFieldController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffbdbdbd), width: 3),
                          ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFEEEEEE), width: 3.0),
                      ),
                    ),
                    style: const TextStyle(
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    height: 50,
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: TextField(
                      controller: _passwordFieldController,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xffbdbdbd), width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFEEEEEE), width: 3.0),
                        ),
                      ),
                      style: const TextStyle(

                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[500],
                      ),
                      onPressed: () async{
                        var user = await supabase.signIn(_loginFieldController.text,_passwordFieldController.text);
                        if(user != null){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const notesPage())
                          );
                        }
                      },
                      child: const Text('Войти',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                      )
                  ),
                ),
              )
            ],
      ),
    );
  }
}
