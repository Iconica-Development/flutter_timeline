// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable
class TimelineTheme {
  const TimelineTheme({
    this.iconColor,
    this.likeIcon,
    this.commentIcon,
    this.likedIcon,
    this.sendIcon,
  });

  final Color? iconColor;

  /// The icon to display when the post is not yet liked
  final Widget? likeIcon;

  /// The icon to display to indicate that a post has comments enabled
  final Widget? commentIcon;

  /// The icon to display when the post is liked
  final Widget? likedIcon;

  /// The icon to display to submit a comment
  final Widget? sendIcon;
}
