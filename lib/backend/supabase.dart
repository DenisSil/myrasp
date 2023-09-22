import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> supabaseInit() async{
  await Supabase.initialize(
    url: 'https://xzlirxjfzhaiqrxfyyag.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6bGlyeGpmemhhaXFyeGZ5eWFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ4ODQ3MjUsImV4cCI6MjAxMDQ2MDcyNX0.lsK-uFVGRhJKfPoy5FegtIYz-Y2i97Yhf3o9vZ8KQ-U',
  );
}


class SupabaseReferense{

  var supabaseReferense;


  SupabaseReferense(){
    supabaseReferense = Supabase.instance.client;
  }

  Future<dynamic> getUserData() async{

    final data = await supabaseReferense
        .from('users')
        .select('id');

    return data;
  }

  Future<dynamic> signIn(String email, String password) async{
    try {
      final user = await supabaseReferense.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return user;
    }catch (e){
      return null;
    }
  }

  dynamic getUser(){
    return supabaseReferense.auth.currentUser;
  }

}