import 'package:localstore/localstore.dart';


class Notes{

  final String id;
  String message;

  Notes({
    required this.id,
    required this.message
  });

  void delete_notes(){
    var db = Localstore.instance;
    db.collection('notes').doc(id).delete();
  }
}