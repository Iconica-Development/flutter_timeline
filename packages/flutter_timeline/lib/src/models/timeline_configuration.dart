// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

@immutable
class TimelineUserStoryConfiguration {
  const TimelineUserStoryConfiguration({
    required this.userId,
    required this.service,
    required this.userService,
    required this.optionsBuilder,
    this.openPageBuilder,
    this.onPostTap,
    this.onUserTap,
    this.onPostDelete,
    this.filterEnabled = false,
    this.postWidgetBuilder,
  });

  final String userId;

  final TimelineService service;

  final TimelineUserService userService;

  final TimelineOptions Function(BuildContext context) optionsBuilder;

  final Function(BuildContext context, String userId)? onUserTap;

  final Function(BuildContext context, Widget child)? openPageBuilder;

  final Function(BuildContext context, TimelinePost post)? onPostTap;

  final Widget Function(BuildContext context, TimelinePost post)? onPostDelete;

  final bool filterEnabled;

  final Widget Function(TimelinePost post)? postWidgetBuilder;
}
