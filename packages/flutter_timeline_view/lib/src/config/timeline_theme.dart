// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_view/src/config/timeline_styles.dart';

@immutable
class TimelineTheme {
  const TimelineTheme({
    this.iconColor,
    this.likeIcon,
    this.commentIcon,
    this.likedIcon,
    this.sendIcon,
    this.moreIcon,
    this.deleteIcon,
    this.textStyles = const TimelineTextStyles(),
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

  /// The icon for more actions (open delete menu)
  final Widget? moreIcon;

  /// The icon for delete action (delete post)
  final Widget? deleteIcon;

  final TimelineTextStyles textStyles;
}
