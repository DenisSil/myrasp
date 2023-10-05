import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '/screens/notes/notesPage.dart';
import '/backend/supabase.dart';
import '/backend/User.dart';


class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {

  var _loginFieldController;
  var _passwordFieldController;
  bool isLoading = false;
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
                    cursorColor: Colors.orange[500],
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
                      cursorColor: Colors.orange[500],
                      obscureText: true,
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
                  child: Consumer<GetUser>(
                    builder: (context, notifier, child){
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[500],
                        ),
                        onPressed: () async{
                            setState(() {
                              isLoading = true;
                            });
                            var res = await supabase.signIn(_loginFieldController.text,_passwordFieldController.text);
                            if(res != null){
                              notifier.addUser(res.user);
                            }
                            setState(() {
                              isLoading = false;
                            });
                        },
                        child: isLoading == false? const Text('Войти',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                        ):  const SpinKitFadingCircle(
                          color: Colors.white,
                          size: 40.0,
                        )
                      );
                    }
                  ),
                ),
              )
            ],
      ),
    );
  }
}
