import 'package:flutter/material.dart';

import 'package:localstore/localstore.dart';
import 'package:myrasp/backend/parser.dart';

class ScheduleNotes with ChangeNotifier {
  Map<String, ScheduleNotesData> _model = {};

  void addNotes(String id, ScheduleNotesData notesData) {
    _model[id] = notesData;
  }

  void setScheduleNotes(Map<String, ScheduleNotesData> localStoreData) =>
      _model = localStoreData;

  Map<String, ScheduleNotesData> get model => _model;

  void clearNotes(String id, String localstorageId) {
    _model.remove(id);
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

class SchedulePageState {
  String _searchType;
  String _name;
  int _group;
  String _date;
  Future<Map<String, dynamic>?> _data;

  SchedulePageState(
      this._searchType, this._name, this._group, this._date, this._data);

  String get searchType => _searchType;
  int get group => _group;
  String get name => _name;
  String get date => _date;
  Future<Map<String, dynamic>?> get data => _data;

  static String dateToString(DateTime date) {
    return date.toString().substring(0, 10);
  }

  SchedulePageState copyWith({
    String? searchType,
    String? name,
    int? group,
    String? date,
    Future<Map<String, dynamic>?>? data,
  }) {
    return SchedulePageState(searchType ?? _searchType, name ?? _name,
        group ?? _group, date ?? _date, data ?? data!);
  }
}

class SchedulePageViewModel with ChangeNotifier {
  var _model = SchedulePageState("idGroup", "ВКБ34", 50884,
      dateToString(DateTime.now()), getData(50884, "ВКБ34"));

  SchedulePageState get model => _model;

  static String dateToString(DateTime date) {
    return date.toString().substring(0, 10);
  }

  void updateState(
      {String? newName,
      int? newGroup,
      String? newSearchType,
      DateTime? newDate}) {
    var newData;
    if (newDate != null || newGroup != null) {
      newData = getData(newGroup ?? _model.group,
          newDate == null ? _model.date : dateToString(newDate));
    }

    _model = _model.copyWith(
        name: newName ?? _model.name,
        group: newGroup ?? _model.group,
        searchType: newSearchType ?? _model.searchType,
        date: newDate == null ? _model.date : dateToString(newDate),
        data: newData ?? _model.data);
    notifyListeners();
  }
}
