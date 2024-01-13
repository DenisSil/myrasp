import 'package:flutter/material.dart';
import 'package:myrasp/view_model/settings_page_view_model.dart';
import 'package:provider/provider.dart';

import '/page/schedule_page/schedule_page.dart';

import '/widgets/calendar/calendar_state.dart';
import '/view_model/schedule_page_view_model.dart';
import '/view_model/search_page_view_model.dart';

import 'global_context.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => ApplicationState();
}

class ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SchedulePageViewModel()),
        ChangeNotifierProvider(create: (_) => ScheduleNotes()),
        ChangeNotifierProvider(create: (_) => CalendarDay()),
        ChangeNotifierProvider(create: (_) => SearchPageViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsPageViewModel())
      ],
      child: MaterialApp(
        navigatorKey: GlobalNavigator.navigatorKey,
        home: const Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: SchedulePage(),
        ),
      ),
    );
  }
}
