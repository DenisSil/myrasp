import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/view_model/schedule_page_view_model.dart';
import 'package:provider/provider.dart';

import '/view_model/search_page_view_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    context.read<SearchPageViewModel>().getSearchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.only(top: 10, right: 10),
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child:
              Consumer<SearchPageViewModel>(builder: (context, value, child) {
            if (value.model.groups.isEmpty) {
              return const Align(
                  alignment: Alignment.center,
                  child: SpinKitCircle(
                    color: Colors.black,
                    size: 50.0,
                  ));
            } else {
              return Column(
                children: [
                  const SearchBar(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 45),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 8),
                          itemCount: value.model.searchResult.length,
                          itemBuilder: (BuildContext context, int index) {
                            return searchItem(
                                groupName: value.model.searchResult[index][0],
                                groupId: value.model.searchResult[index][1]);
                          }),
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}

class searchItem extends StatelessWidget {
  final String groupName;
  final int groupId;
  const searchItem({super.key, required this.groupName, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        focusColor: Colors.white,
        onTap: () {
          context
              .read<SchedulePageViewModel>()
              .updateState(newName: groupName, newGroup: groupId);
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(10),
          child: Text(
            groupName,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color focusColor = Colors.grey;
    return Consumer<SearchPageViewModel>(
      builder: (context, value, child) => Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              iconSize: 30,
              splashRadius: 5),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border: Border.all(color: focusColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (search) {
                        if (search.length >= 2) {
                          value.updateSearchData(search);
                        } else {
                          if (value.model.searchResult.isNotEmpty) {
                            value.clearSearchData();
                          }
                        }
                      },
                      controller: _controller,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText:
                            'Введите группу, аудиторию, или имя преподователя',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_controller.text != '') {
                        _controller.clear();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.clear),
                    iconSize: 25,
                    splashRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
