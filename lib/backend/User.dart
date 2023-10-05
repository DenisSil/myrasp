import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetUser extends ChangeNotifier{

  var _user;


  User? get user => _user;

  void addUser(currentUser){
    _user = currentUser;
    notifyListeners();
  }

  void cleanUser(){
    _user = null;
    notifyListeners();
  }

}