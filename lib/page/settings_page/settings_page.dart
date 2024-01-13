import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:myrasp/view_model/settings_page_view_model.dart';
import 'package:myrasp/widgets/dropdown.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsPageViewModel>().loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SettingsPageViewModel>(
          builder: (context, model, child) {
            if (model.model.listGroups == null) {
              return const Align(
                alignment: Alignment.center,
                child: SpinKitCircle(
                  color: Colors.black,
                  size: 50.0,
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Gap(20),
                  Dropdown(
                    height: 45,
                    width: 200,
                    items: model.model.listGroups!,
                    changeDropdownStateFunction: (value) {
                      model.updateModel(newName: value[0], newGroup: value[1]);
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
