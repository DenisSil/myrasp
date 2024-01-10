import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myrasp/backend/parser.dart';
import 'package:myrasp/widgets/dropdown.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var groups;

  @override
  void initState() {
    super.initState();

    getGroupForSettings().then((value) {
      groups = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: groups == null
          ? Container(color: Colors.red)
          : Column(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back)),
                const Gap(20),
                SizedBox(
                    height: 45,
                    width: 100,
                    child: Dropdown(
                        items: groups,
                        changeDropdownStateFunction: (value) {
                          print(value);
                        })),
              ],
            ),
    ));
  }
}
