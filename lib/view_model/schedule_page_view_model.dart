import 'package:flutter/material.dart';
import 'package:myrasp/view_model/settings_page_view_model.dart';
import 'package:provider/provider.dart';

import '/service/notes_service.dart';
import '/service/api_service.dart';

class ScheduleNotes with ChangeNotifier {
  Map<String, ScheduleNotesData> _model = {};
  NotesService notesService = NotesService();

  Map<String, ScheduleNotesData> get model => _model;

  ScheduleNotes() {
    init();
  }

  void init() {
    getNotes();
  }

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
  final String? _name;
  final int? _group;
  final String _date;
  final Map<String, dynamic>? _data;

  SchedulePageState(this._date, [this._name, this._group, this._data]);

  int? get group => _group;
  String? get name => _name;
  String get date => _date;
  Map<String, dynamic>? get data => _data;

  static String dateToString(DateTime date) {
    return date.toString().substring(0, 10);
  }

  SchedulePageState copyWith({
    String? name,
    int? group,
    String? date,
    Map<String, dynamic>? data,
  }) {
    return SchedulePageState(
        date ?? _date, name ?? _name!, group ?? _group!, data ?? _data);
  }
}

class SchedulePageViewModel with ChangeNotifier {
  late SchedulePageState _model =
      SchedulePageState(dateToString(DateTime.now()));
  APIService apiService = APIService();

  SchedulePageState get model => _model;

  static String dateToString(DateTime date) {
    return date.toString().substring(0, 10);
  }

  SchedulePageViewModel update(SettingsPageViewModel settings) {
    updateState(
        newName: settings.model.name,
        newGroup: settings.model.group,
        newDate: null);
    return this;
  }

  SchedulePageViewModel() {
    init();
  }

  void init() async {
    if (_model.name == null) {
      return;
    }
    getScheduleData();
  }

  void getScheduleData() async {
    var data = await apiService.getScheduleData(_model.group!, _model.date);
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
      date: newDate == null ? _model.date : dateToString(newDate),
    );

    notifyListeners();

    if (newGroup != null || newDate != null) {
      getScheduleData();
    }
  }
}
