import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '/backend/parser.dart';
import '/blocState/search_page_bloc_state.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  final TextEditingController _controller = TextEditingController();

  var groups;
  var futureSearchFunc;
  List<List<dynamic>> searchResult = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureSearchFunc = getDataForSearch();
    if (context.read<SearchState>().state == null) {
      getDataForSearch().then((value) {
        context.read<SearchState>().setSearchState(value);
        setState(() {
          groups = context.read<SearchState>().state;
        });
      });
    } else {
      setState(() {
        groups = context.read<SearchState>().state;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? focusColor = Colors.grey;

    return Scaffold(
        body: Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.only(top: 10, right: 10),
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: groups == null
                    ? const Align(
                        alignment: Alignment.center,
                        child: SpinKitCircle(
                          color: Colors.black,
                          size: 50.0,
                        ))
                    : Column(
                        children: [
                          Row(
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        onChanged: (search) {
                                          if (search.length >= 2) {
                                            searchResult = [];
                                            groups.keys
                                                .toList()
                                                .forEach((group) {
                                              if (group
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                      search.toLowerCase())) {
                                                searchResult.add(
                                                    [group, groups[group]]);
                                              }
                                            });
                                            setState(() {
                                              searchResult = searchResult;
                                            });
                                          } else {
                                            setState(() {
                                              searchResult = [];
                                            });
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
                                        splashRadius: 5)
                                  ],
                                ),
                              )),
                            ],
                          ),
                          Expanded(
                              child: Container(
                            margin: const EdgeInsets.only(left: 45),
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 8),
                                itemCount: searchResult.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return searchItem(
                                      groupName: searchResult[index][0],
                                      groupId: searchResult[index][1]);
                                }),
                          ))
                        ],
                      ))));
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
            Navigator.pop(context, groupId);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(10),
            child: Text(groupName, style: TextStyle(color: Colors.grey[600])),
          )),
    );
  }
}
