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
    this.doubleTapTolike = false,
    this.iconsWithValues = false,
    this.likeAndDislikeIconsForDoubleTap = const (
      Icon(
        Icons.favorite_rounded,
        color: Color(0xFFC3007A),
      ),
      null,
    ),
    this.itemInfoBuilder,
    this.dateFormat,
    this.timeFormat,
    this.buttonBuilder,
    this.textInputBuilder,
    this.dividerBuilder,
    this.userAvatarBuilder,
    this.anonymousAvatarBuilder,
    this.nameBuilder,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0),
    this.iconSize = 26,
    this.postWidgetheight,
    this.postPadding = const EdgeInsets.all(12.0),
    this.categories,
    this.categoryButtonBuilder,
    this.catergoryLabelBuilder,
  });

  /// Theming options for the timeline
  final TimelineTheme theme;

  /// The format to display the post date in
  final DateFormat? dateFormat;

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

  /// When the imageUrl is null this anonymousAvatarBuilder will be used
  /// You can use it to display a default avatarW
  final UserAvatarBuilder? anonymousAvatarBuilder;

  final String Function(TimelinePosterUserModel?)? nameBuilder;

  /// ImagePickerTheme can be used to change the UI of the
  /// Image Picker Widget to change the text/icons to your liking.
  final ImagePickerTheme imagePickerTheme;

  /// ImagePickerConfig can be used to define the
  /// size and quality for the uploaded image.
  final ImagePickerConfig imagePickerConfig;

  /// Whether to allow double tap to like
  final bool doubleTapTolike;

  /// The icons to display when double tap to like is enabled
  final (Icon?, Icon?) likeAndDislikeIconsForDoubleTap;

  /// Whether to display the icons with values
  final bool iconsWithValues;

  /// The builder for the item info, all below the like and comment buttons
  final Widget Function({required TimelinePost post})? itemInfoBuilder;

  /// The builder for the divider
  final Widget Function()? dividerBuilder;

  /// The padding between posts in the timeline
  final EdgeInsets padding;

  /// Size of icons like the comment and like icons. Dafualts to 26
  final double iconSize;

  /// Sets a predefined height for the postWidget.
  final double? postWidgetheight;

  /// Padding of each post
  final EdgeInsets postPadding;

  /// List of categories that the user can select.
  /// If this is null no categories will be shown.
  final List<String>? categories;

  /// Abilty to override the standard category selector
  final Widget Function({
    required String? categoryKey,
    required String categoryName,
    required Function onTap,
    required bool selected,
  })? categoryButtonBuilder;

  /// Ability to set an proper label for the category selectors.
  /// Default to category key.
  final String Function(String? categoryKey)? catergoryLabelBuilder;
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

typedef UserAvatarBuilder = Widget? Function(
  TimelinePosterUserModel user,
  double size,
);
