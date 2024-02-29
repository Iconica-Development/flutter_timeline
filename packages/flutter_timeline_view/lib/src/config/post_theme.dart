// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';
import 'package:intl/intl.dart';

class TimelinePostTheme {
  const TimelinePostTheme({
    this.timelinePostHeight,
    this.iconsWithValues = false,
    this.itemInfoBuilder,
    this.dateFormat,
    this.timeFormat,
    this.userAvatarBuilder,
    this.anonymousAvatarBuilder,
    this.nameBuilder,
    this.iconSize = 26,
    this.postWidgetHeight,
    this.postPadding = const EdgeInsets.all(12.0),
    this.pagePadding = const EdgeInsets.all(20),
    this.iconTheme = const IconTimelineTheme(),
  });

  /// The height of a post in the timeline
  final double? timelinePostHeight;

  /// Whether to display the icons with values
  final bool iconsWithValues;

  /// The builder for the item info, all below the like and comment buttons
  final Widget Function({required TimelinePost post})? itemInfoBuilder;

  /// The format to display the post date in
  final DateFormat? dateFormat;

  /// The format to display the post time in
  final DateFormat? timeFormat;

  final UserAvatarBuilder? userAvatarBuilder;

  /// When the imageUrl is null this anonymousAvatarBuilder will be used
  /// You can use it to display a default avatarW
  final UserAvatarBuilder? anonymousAvatarBuilder;

  final String Function(TimelinePosterUserModel?)? nameBuilder;

  /// Size of icons like the comment and like icons. Dafualts to 26
  final double iconSize;

  /// Sets a predefined height for the postWidget.
  final double? postWidgetHeight;

  /// Padding of each post
  final EdgeInsets postPadding;

  final EdgeInsets pagePadding;

  /// Theming options for the icons within timeline
  final IconTimelineTheme iconTheme;
}
