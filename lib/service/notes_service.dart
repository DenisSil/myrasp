import 'package:localstore/localstore.dart';
import '/view_model/schedule_page_view_model.dart';

class NotesService {
  final Localstore _db = Localstore.instance;

  Future<Map<String, ScheduleNotesData>> getNotes() async {
    Map<String, ScheduleNotesData> notes = {};

    var responce = await _db.collection('notes').get();
    if (responce != null) {
      responce.forEach((key, value) {
        notes[value['id']] = (ScheduleNotesData(value['id'],
            value['localstorageId'], value['color'], value['message']));
      });
    }
    return notes;
  }

  String saveNotes(
    String id,
    int selectedColor,
    String message,
  ) {
    final localstorageId = _db.collection('notes').doc().id;

    _db.collection('notes').doc(localstorageId).set({
      'id': id,
      'localstorageId': localstorageId,
      'color': selectedColor,
      'message': message
    });
    return localstorageId;
  }

  void clearNotes(String notesId) {
    _db.collection('notes').doc(notesId).delete();
  }
}
