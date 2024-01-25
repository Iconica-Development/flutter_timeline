// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

@immutable
class TimelineUserStoryConfiguration {
  const TimelineUserStoryConfiguration({
    required this.categoriesBuilder,
    required this.optionsBuilder,
    required this.userId,
    required this.service,
    required this.userService,
    this.mainPageBuilder,
    this.postScreenBuilder,
    this.postCreationScreenBuilder,
    this.postSelectionScreenBuilder,
    this.onUserTap,
  });

  final String userId;

  final Function(BuildContext context, String userId)? onUserTap;

  final Widget Function(BuildContext context, Widget filterBar, Widget child)?
      mainPageBuilder;

  final Widget Function(
    BuildContext context,
    Widget child,
    TimelineCategory category,
  )? postScreenBuilder;

  final Widget Function(BuildContext context, Widget child)?
      postCreationScreenBuilder;

  final Widget Function(BuildContext context, Widget child)?
      postSelectionScreenBuilder;

  final TimelineService service;

  final TimelineUserService userService;

  final TimelineOptions Function(BuildContext context) optionsBuilder;

  final List<TimelineCategory> Function(BuildContext context) categoriesBuilder;
}
