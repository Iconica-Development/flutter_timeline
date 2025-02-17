import 'package:example/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:intl/date_symbol_data_local.dart';

void main(List<String> args) {
  initializeDateFormatting();

  runApp(const MyApp());
}

var timelineService = TimelineService();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const FlutterTimelineUserstory(
        currentUserId: "1",
      ),
    );
  }
}
