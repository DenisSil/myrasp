import 'package:flutter/material.dart';

class SearchibleDropdown extends StatefulWidget {
  Map<String, int> items;
  Function onChangedSelectedItem;
  double width;
  double height;

  SearchibleDropdown({
    super.key,
    required this.items,
    required this.height,
    required this.width,
    required this.onChangedSelectedItem,
  });

  @override
  State<SearchibleDropdown> createState() => _SearchibleDropdownState();
}

class _SearchibleDropdownState extends State<SearchibleDropdown> {
  late List<PopupMenuEntry> items = [];
  final TextEditingController _searchFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        decoration: const InputDecoration(hintText: 'Введите имя группы'),
        controller: _searchFieldController,
        onChanged: (text) {
          if (text.length <= 2) {
            items = [];
            return;
          }
          widget.items.forEach(
            (key, value) {
              if (key.toLowerCase().contains(text.toLowerCase())) {
                items.add(
                  PopupMenuItem(
                    onTap: () {
                      widget.onChangedSelectedItem([key, value]);
                      _searchFieldController.text = key;
                    },
                    value: value,
                    child: Text(
                      key,
                    ),
                  ),
                );
              }
            },
          );

          var translation =
              context.findRenderObject()?.getTransformTo(null).getTranslation();
          var offset = Offset(translation!.x, translation.y + 50);
          showMenu(
            context: context,
            constraints: BoxConstraints(
              maxHeight: 300,
              minWidth: widget.width,
            ),
            position: RelativeRect.fromLTRB(offset.dx, offset.dy, 100, 100),
            items: items,
          );
        },
      ),
    );
  }
}
