import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myrasp/view_model/settings_page_view_model.dart';
import 'package:myrasp/widgets/dropdown.dart';
import 'package:myrasp/widgets/searchible_dropdown.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<dynamic>? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<SettingsPageViewModel>(
      builder: (context, value, child) {
        if (value.model.listGroups == null) {
          return const LinearProgressIndicator();
        }
        return Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchibleDropdown(
              width: 250,
              height: 50,
              items: value.model.listGroups!,
              onChangedSelectedItem: (value) {
                _selectedGroup = value;
              },
            ),
            const Gap(20),
            SizedBox(
              height: 45,
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.grey[500]),
                ),
                onPressed: () {
                  if (_selectedGroup == null) {
                    return;
                  }
                  value.updateModel(
                    newName: _selectedGroup![0],
                    newGroup: _selectedGroup![1],
                  );
                  value.saveSettings(_selectedGroup![0], _selectedGroup![1],
                      value.model.themeSetting);
                },
                child: const Text('Далее'),
              ),
            ),
          ],
        ));
      },
    ));
  }
}
