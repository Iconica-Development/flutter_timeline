// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_image_picker/flutter_image_picker.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_theme.dart';
import 'package:flutter_timeline_view/src/config/timeline_translations.dart';
import 'package:intl/intl.dart';

@immutable
class TimelineOptions {
  const TimelineOptions({
    this.theme = const TimelineTheme(),
    this.translations = const TimelineTranslations.empty(),
    this.imagePickerConfig = const ImagePickerConfig(),
    this.imagePickerTheme = const ImagePickerTheme(),
    this.timelinePostHeight,
    this.allowAllDeletion = false,
    this.sortCommentsAscending = true,
    this.sortPostsAscending = false,
    this.dateformat,
    this.timeFormat,
    this.buttonBuilder,
    this.textInputBuilder,
    this.userAvatarBuilder,
  });

  /// Theming options for the timeline
  final TimelineTheme theme;

  /// The format to display the post date in
  final DateFormat? dateformat;

  /// The format to display the post time in
  final DateFormat? timeFormat;

  /// Whether to sort comments ascending or descending
  final bool sortCommentsAscending;

  /// Whether to sort posts ascending or descending
  final bool sortPostsAscending;

  /// Allow all posts to be deleted instead of
  ///  only the posts of the current user
  final bool allowAllDeletion;

  /// The height of a post in the timeline
  final double? timelinePostHeight;

  final TimelineTranslations translations;

  final ButtonBuilder? buttonBuilder;

  final TextInputBuilder? textInputBuilder;

  final UserAvatarBuilder? userAvatarBuilder;

  /// ImagePickerTheme can be used to change the UI of the
  /// Image Picker Widget to change the text/icons to your liking.
  final ImagePickerTheme imagePickerTheme;

  /// ImagePickerConfig can be used to define the
  /// size and quality for the uploaded image.
  final ImagePickerConfig imagePickerConfig;
}

typedef ButtonBuilder = Widget Function(
  BuildContext context,
  VoidCallback onPressed,
  String text, {
  bool enabled,
});

typedef TextInputBuilder = Widget Function(
  TextEditingController controller,
  Widget? suffixIcon,
  String hintText,
);

typedef UserAvatarBuilder = Widget Function(
  TimelinePosterUserModel user,
  double size,
);
