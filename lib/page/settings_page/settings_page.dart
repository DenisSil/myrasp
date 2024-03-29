import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:myrasp/view_model/settings_page_view_model.dart';
import 'package:myrasp/widgets/searchible_dropdown.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<dynamic>? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SettingsPageViewModel>(
          builder: (context, model, child) {
            if (model.model.listGroups == null) {
              return Align(
                alignment: Alignment.center,
                child: SpinKitCircle(
                  color: Theme.of(context).colorScheme.primary,
                  size: 50.0,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      alignment: Alignment.centerLeft,
                      splashRadius: 1,
                      iconSize: 30,
                      onPressed: () {
                        if (_selectedGroup != null) {
                          model.saveSettings(_selectedGroup![0],
                              _selectedGroup![1], model.model.themeSetting);
                        }
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Gap(20),
                    SearchibleDropdown(
                      width: 250,
                      height: 50,
                      items: model.model.listGroups!,
                      onChangedSelectedItem: (value) {
                        _selectedGroup = value;
                      },
                    ),
                    Switch(
                        activeColor: Colors.white,
                        value: model.model.themeSetting,
                        onChanged: (value) {
                          model.updateModel(newThemeSettings: value);
                        })
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
