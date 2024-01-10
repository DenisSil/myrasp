import 'package:flutter/material.dart';
import 'screens/search_page/search_page_view_model.dart';
import 'package:provider/provider.dart';

import 'screens/schedule_page/schedule_page.dart';
import 'widgets/calendar/calendar_state.dart';
import 'screens/schedule_page/schedule_page_view_model.dart';

import 'backend/global_context.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyRasp());
}

class MyRasp extends StatefulWidget {
  const MyRasp({super.key});

  @override
  State<MyRasp> createState() => MyRaspState();
}

class MyRaspState extends State<MyRasp> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SchedulePageViewModel()),
        ChangeNotifierProvider(create: (_) => ScheduleNotes()),
        ChangeNotifierProvider(create: (_) => CalendarDay()),
        ChangeNotifierProvider(create: (_) => SearchPageViewModel())
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
