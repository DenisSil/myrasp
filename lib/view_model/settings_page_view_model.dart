import 'package:flutter/material.dart';
import 'package:myrasp/service/api_service.dart';
import 'package:myrasp/service/settings_service.dart';

class SettingsPageViewModel with ChangeNotifier {
  SettingsPageState _model = SettingsPageState();
  SettingsService settingsService = SettingsService();
  APIService apiService = APIService();

  SettingsPageState get model => _model;

  void loadSettings() async {
    var data = await settingsService.getSettings();
    if (data.isEmpty) {
      return;
    }
    updateModel(
        newGroup: data['group'] ?? _model.group,
        newName: data['name'] ?? _model.name);
  }

  void loadGroups() async {
    Map<String, int> data = await apiService.getGroupForSettings();
    updateModel(newListGroups: data);
  }

  void saveSettings(String name, int group) {
    settingsService.saveSettings(name, group);
  }

  void updateModel(
      {String? newName, int? newGroup, Map<String, int>? newListGroups}) {
    _model = _model.copyWith(
        newGroup: newGroup ?? _model.group,
        newName: newName ?? _model.name,
        newListGroups: newListGroups ?? _model.listGroups);
    notifyListeners();
  }
}

class SettingsPageState {
  final String? _name;
  final int? _group;
  final Map<String, int>? _listGroups;

  SettingsPageState([this._name = '', this._group = 0, this._listGroups]);

  String get name => _name ?? '';
  int get group => _group ?? 0;
  Map<String, int>? get listGroups => _listGroups;

  SettingsPageState copyWith(
      {String? newName, int? newGroup, Map<String, int>? newListGroups}) {
    return SettingsPageState(
        newName ?? _name, newGroup ?? _group, newListGroups ?? _listGroups);
  }
}
