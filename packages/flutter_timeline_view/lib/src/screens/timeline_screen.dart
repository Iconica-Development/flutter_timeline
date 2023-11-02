import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({
    required this.posts,
    this.controller,
    this.timelineCategoryFilter,
    this.timelinePostHeight = 100.0,
    super.key,
  });

  final ScrollController? controller;

  final String? timelineCategoryFilter;

  final double timelinePostHeight;

  final List<TimelinePost> posts;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) => const Placeholder();
}
