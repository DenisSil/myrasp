import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/view_model/schedule_page_view_model.dart';
import 'package:provider/provider.dart';

import '/view_model/search_page_view_model.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child:
                Consumer<SearchPageViewModel>(builder: (context, value, child) {
              if (value.model.groups.isEmpty) {
                return Align(
                    alignment: Alignment.center,
                    child: SpinKitCircle(
                      color: Theme.of(context).colorScheme.primary,
                      size: 50.0,
                    ));
              } else {
                return FractionallySizedBox(
                  widthFactor: 0.9,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SearchBar(),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: value.model.searchResult.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SearchItem(
                                groupName: value.model.searchResult[index][0],
                                groupId: value.model.searchResult[index][1],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}

class SearchItem extends StatelessWidget {
  final String groupName;
  final int groupId;
  const SearchItem({super.key, required this.groupName, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        context.read<SchedulePageViewModel>().updateState(
              newName: groupName,
              newGroup: groupId,
            );
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        child: Text(
          groupName,
          style: Theme.of(context).textTheme.bodyMedium,
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
    return Consumer<SearchPageViewModel>(
      builder: (context, value, child) => Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outline),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.onBackground,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                          blurRadius: 4,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText:
                            'Введите группу, аудиторию, или имя преподователя',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_controller.text != '') {
                      _controller.clear();
                      value.updateModel(searchResult: []);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
