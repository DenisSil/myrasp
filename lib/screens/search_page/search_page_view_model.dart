import 'package:flutter/material.dart';

class SearchPageViewModel with ChangeNotifier {
  SearchPageState _model = SearchPageState({}, []);

  SearchPageState get model => _model;

  void updateModel({
    Map<String, int>?  groups,
    List<dynamic>? searchResult,
  }) {
    _model = _model.copyWith(
      groups: groups?? _model._groups,
      searchResult: searchResult?? _model._searchResult
    );
    notifyListeners();
  }
}

class SearchPageState{
  Map<String, int>  _groups;
  List<dynamic> _searchResult;

  SearchPageState(this._groups, this._searchResult);
  
  Map<String, int>  get groups => _groups;
  List<dynamic> get searchResult => _searchResult;

  SearchPageState copyWith({
    Map<String, int>?  groups,
    List<dynamic>? searchResult,
  }) {
    return SearchPageState(groups ?? _groups, searchResult ?? _searchResult);
  }
}
