import 'package:flutter/material.dart';

@immutable
class TimelineCategory {
  const TimelineCategory({
    required this.name,
    required this.title,
    required this.icon,
    this.canCreate = true,
    this.canView = true,
  });
  final String name;
  final String title;
  final Widget icon;
  final bool canCreate;
  final bool canView;
}
