import 'package:flutter/material.dart';
import 'package:myrasp/service/api_service.dart';
import 'package:myrasp/service/settings_service.dart';

class SettingsPageViewModel with ChangeNotifier {
  SettingsPageState _model = SettingsPageState();
  SettingsService settingsService = SettingsService();
  APIService apiService = APIService();

  SettingsPageState get model => _model;

  SettingsPageViewModel() {
    init();
  }

  void init() {
    loadSettings();
    loadGroups();
  }

  void loadSettings() async {
    var data = await settingsService.getSettings();
    if (data.isEmpty) {
      return;
    }
    updateModel(
        newGroup: data['group'] ?? _model.group,
        newName: data['name'] ?? _model.name,
        newThemeSettings: data['isDarkMode'] ?? _model.themeSetting);
  }

  void loadGroups() async {
    Map<String, int> data = await apiService.getGroupForSettings();
    updateModel(newListGroups: data);
  }

  void saveSettings(String name, int group, bool isDarkMode) {
    settingsService.saveSettings(name, group, isDarkMode);
  }

  void updateModel(
      {String? newName,
      int? newGroup,
      Map<String, int>? newListGroups,
      bool? newThemeSettings}) {
    _model = _model.copyWith(
      newGroup: newGroup ?? _model.group,
      newName: newName ?? _model.name,
      newListGroups: newListGroups ?? _model.listGroups,
      newThemeSetting: newThemeSettings ?? _model.themeSetting,
    );
    notifyListeners();
  }
}

class SettingsPageState {
  final String? _name;
  final int? _group;
  final Map<String, int>? _listGroups;
  final bool? _themeSetting;

  SettingsPageState([
    this._name,
    this._group,
    this._listGroups,
    this._themeSetting,
  ]);

  String? get name => _name;
  int? get group => _group;
  Map<String, int>? get listGroups => _listGroups;
  bool get themeSetting => _themeSetting ?? false;

  SettingsPageState copyWith(
      {String? newName,
      int? newGroup,
      Map<String, int>? newListGroups,
      bool? newThemeSetting}) {
    return SettingsPageState(
      newName ?? _name,
      newGroup ?? _group,
      newListGroups ?? _listGroups,
      newThemeSetting ?? _themeSetting,
    );
  }
}
