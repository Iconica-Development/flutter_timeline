// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable
class IconTimelineTheme {
  const IconTimelineTheme({
    this.iconColor,
    this.likeIcon,
    this.commentIcon,
    this.likedIcon,
    this.sendIcon,
    this.moreIcon,
    this.deleteIcon,
    this.likeAndDislikeIconsForDoubleTap = const (
      Icon(
        Icons.favorite_rounded,
        color: Color(0xFFC3007A),
      ),
      null,
    ),
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

  /// The icons to display when double tap to like is enabled
  final (Icon?, Icon?) likeAndDislikeIconsForDoubleTap;
}
