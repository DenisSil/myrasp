import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';

class ScheduleNotes extends Cubit<Map<String, ScheduleNotesData>> {
  ScheduleNotes() : super({});

  void addNotes(String id, ScheduleNotesData notesData) {
    state[id] = notesData;
  }

  void setScheduleNotes(Map<String, ScheduleNotesData> localStoreData) =>
      emit(localStoreData);

  Map<String, ScheduleNotesData> readData() => state;

  void clearNotes(String id, String localstorageId) {
    state.remove(id);
    var db = Localstore.instance;
    db.collection('notes').doc(localstorageId).delete();
  }
}

class ScheduleNotesData {
  String id;
  String localstorageId;
  int selectedColor;
  String message;

  ScheduleNotesData(
      this.id, this.localstorageId, this.selectedColor, this.message);

  void changeMessage(String message) {
    this.message = message;
  }

  void changeColor(int color) {
    selectedColor = color;
  }
}
