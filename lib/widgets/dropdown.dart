import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Dropdown extends StatefulWidget {
  String? selectedItem;
  Map<String, int> items;
  double height;
  double width;
  Function changeDropdownStateFunction;

  Dropdown(
      {required this.items,
      this.selectedItem,
      required this.changeDropdownStateFunction,
      this.width = double.infinity,
      this.height = 46,
      super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  bool menuOpen = false;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        onMenuStateChange: (value) {
          setState(() {
            menuOpen = !menuOpen;
          });
        },
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(),
              child: Text(
                widget.selectedItem == null ? 'Любой' : widget.selectedItem!,
                overflow: TextOverflow.ellipsis,
              ),
            )),
          ],
        ),
        items: widget.items.keys
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
            widget.changeDropdownStateFunction(widget.items[value]);
          });
        },
        buttonStyleData: ButtonStyleData(
          height: widget.height,
          width: widget.width,
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFFEDEFF6),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: menuOpen == false
              ? const Icon(
                  Icons.keyboard_arrow_down,
                )
              : const Icon(
                  Icons.keyboard_arrow_up,
                ),
          iconSize: 20,
          iconEnabledColor: const Color(0xff6E7494),
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFFEDEFF6),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
