import 'package:flutter_bloc/flutter_bloc.dart';

class SearchState extends Cubit<Map<String, int>?> {
  SearchState() : super(null);

  void setSearchState(Map<String, int>? setData) => emit(setData);
}
