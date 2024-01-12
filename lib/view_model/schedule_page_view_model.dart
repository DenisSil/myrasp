import 'package:flutter/material.dart';

import '/service/notes_service.dart';
import '/service/api_secvice.dart';

class ScheduleNotes with ChangeNotifier {
  Map<String, ScheduleNotesData> _model = {};
  NotesService notesService = NotesService();

  Map<String, ScheduleNotesData> get model => _model;

  void getNotes() async {
    var localstoreData = await notesService.getNotes();
    setScheduleNotes(localstoreData);
  }

  void addNotes(String id, int selectedColor, String message) async {
    String localstorageId = notesService.saveNotes(id, selectedColor, message);
    ScheduleNotesData newNotes =
        ScheduleNotesData(id, localstorageId, selectedColor, message);
    _model[id] = newNotes;
  }

  void setScheduleNotes(Map<String, ScheduleNotesData> data) {
    _model = data;
    notifyListeners();
  }

  void clearNotes(String id, String localstorageId) {
    _model.remove(id);
    notesService.clearNotes(localstorageId);
    notifyListeners();
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

class SchedulePageState {
  String _searchType;
  String _name;
  int _group;
  String _date;
  Map<String, dynamic>? _data;

  SchedulePageState(
      this._searchType, this._name, this._group, this._date, this._data);

  String get searchType => _searchType;
  int get group => _group;
  String get name => _name;
  String get date => _date;
  Map<String, dynamic>? get data => _data;

  static String dateToString(DateTime date) {
    return date.toString().substring(0, 10);
  }

  SchedulePageState copyWith({
    String? searchType,
    String? name,
    int? group,
    String? date,
    Map<String, dynamic>? data,
  }) {
    return SchedulePageState(searchType ?? _searchType, name ?? _name,
        group ?? _group, date ?? _date, data ?? _data);
  }
}

class SchedulePageViewModel with ChangeNotifier {
  var _model = SchedulePageState(
      "idGroup", "ВКБ34", 50884, dateToString(DateTime.now()), null);
  APIService apiService = APIService();

  SchedulePageState get model => _model;

  static String dateToString(DateTime date) {
    return date.toString().substring(0, 10);
  }

  void getScheduleData() async {
    var data = await apiService.getScheduleData(_model.group, _model.date);
    _model = _model.copyWith(data: data);
    notifyListeners();
  }

  void updateState({
    String? newName,
    int? newGroup,
    String? newSearchType,
    DateTime? newDate,
  }) {
    _model = _model.copyWith(
      name: newName ?? _model.name,
      group: newGroup ?? _model.group,
      searchType: newSearchType ?? _model.searchType,
      date: newDate == null ? _model.date : dateToString(newDate),
    );

    if (newGroup != null || newDate != null) {
      getScheduleData();
    }

    notifyListeners();
  }
}
