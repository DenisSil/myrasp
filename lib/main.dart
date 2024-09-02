import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstore/localstore.dart';
import 'package:myrasp/page/start%20page/start_page.dart';
import 'package:myrasp/view_model/settings_page_view_model.dart';
import 'package:provider/provider.dart';

import '/page/schedule_page/schedule_page.dart';

import '/widgets/calendar/calendar_state.dart';
import '/view_model/schedule_page_view_model.dart';
import '/view_model/search_page_view_model.dart';

import 'global_context.dart';
import 'package:json_theme/json_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final lightThemeString =
      await rootBundle.loadString('assets/theme/light_theme.json');
  final darkThemeString =
      await rootBundle.loadString('assets/theme/dark_theme.json');
  final lightThemeJson = jsonDecode(lightThemeString);
  final darkThemeJson = jsonDecode(darkThemeString);
  final ligthTheme = ThemeDecoder.decodeThemeData(lightThemeJson)!;
  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;

  runApp(Application(
    lightTheme: ligthTheme,
    darkTheme: darkTheme,
  ));
}

class Application extends StatefulWidget {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  const Application({
    super.key,
    required this.lightTheme,
    required this.darkTheme,
  });

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
        ChangeNotifierProvider(create: (_) => SettingsPageViewModel()),
        ChangeNotifierProxyProvider<SettingsPageViewModel,
                SchedulePageViewModel>(
            create: (_) => SchedulePageViewModel(),
            update: (_, myModel, myNotifier) => myNotifier!.update(myModel))
      ],
      child: Consumer<SettingsPageViewModel>(
        builder: (context, value, child) {
          return MaterialApp(
            navigatorKey: GlobalNavigator.navigatorKey,
            theme:
                value.model.themeSetting ? widget.darkTheme : widget.lightTheme,
            home: Scaffold(
              resizeToAvoidBottomInset: true,
              body: value.model.group == null
                  ? const StartPage()
                  : const SchedulePage(),
            ),
          );
        },
      ),
    );
  }
}
