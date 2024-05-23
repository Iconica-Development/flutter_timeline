import 'package:flutter/material.dart';

/// This class contains the paddings used in the timeline options
class TimelinePaddingOptions {
  const TimelinePaddingOptions({
    this.mainPadding =
        const EdgeInsets.only(left: 12.0, top: 24.0, right: 12.0, bottom: 12.0),
    this.postPadding =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
    this.postOverviewButtonBottomPadding = 30.0,
    this.categoryButtonTextPadding,
  });

  /// The padding between posts in the timeline
  final EdgeInsets mainPadding;

  /// The padding of each post
  final EdgeInsets postPadding;

  /// The bottom padding of the button on the post overview screen
  final double postOverviewButtonBottomPadding;

  /// The padding between the icon and the text in the category button
  final double? categoryButtonTextPadding;
}
