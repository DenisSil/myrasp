import 'package:flutter/material.dart';
import '/service/api_secvice.dart';

class SearchPageViewModel with ChangeNotifier {
  SearchPageState _model = SearchPageState({}, []);
  APIService apiService = APIService();

  SearchPageState get model => _model;

  void getSearchData() async {
    var data = await apiService.getSearchData();
    if (data == null) {
      return;
    }
    updateModel(groups: data);
  }

  void updateSearchData(String search) {
    var searchRes = [];
    _model.groups.keys.toList().forEach((group) {
      if (group.toString().toLowerCase().contains(search.toLowerCase())) {
        searchRes.add([group, _model.groups[group]]);
      }
    });
    updateModel(searchResult: searchRes);
  }

  void clearSearchData() {
    updateModel(searchResult: []);
  }

  void updateModel({
    Map<String, int>? groups,
    List<dynamic>? searchResult,
  }) {
    _model = _model.copyWith(
        groups: groups ?? _model._groups,
        searchResult: searchResult ?? _model._searchResult);
    notifyListeners();
  }
}

class SearchPageState {
  Map<String, int> _groups;
  List<dynamic> _searchResult;

  SearchPageState(this._groups, this._searchResult);

  Map<String, int> get groups => _groups;
  List<dynamic> get searchResult => _searchResult;

  SearchPageState copyWith({
    Map<String, int>? groups,
    List<dynamic>? searchResult,
  }) {
    return SearchPageState(groups ?? _groups, searchResult ?? _searchResult);
  }
}
