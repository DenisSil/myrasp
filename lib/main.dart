import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/schedule/schedule_page.dart';
import 'blocState/calendar_bloc_state.dart';
import 'blocState/search_page_bloc_state.dart';
import 'blocState/schedule_notes_bloc_state.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarDay>(
          create: (_) => CalendarDay(),
        ),
        BlocProvider<SearchState>(create: (_) => SearchState()),
        BlocProvider<ScheduleNotes>(create: (_) => ScheduleNotes()),
      ],
      child: MaterialApp(
        navigatorKey: GlobalNavigator.navigatorKey,
        home: const Scaffold(
          backgroundColor: Colors.white,
          body: schedulePage(),
        ),
      ),
    );
  }
}
