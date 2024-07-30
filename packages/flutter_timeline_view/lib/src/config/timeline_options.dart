// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_picker/flutter_image_picker.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_paddings.dart';
import 'package:flutter_timeline_view/src/config/timeline_theme.dart';
import 'package:flutter_timeline_view/src/config/timeline_translations.dart';
import 'package:intl/intl.dart';

class TimelineOptions {
  const TimelineOptions({
    this.theme = const TimelineTheme(),
    this.translations = const TimelineTranslations.empty(),
    this.paddings = const TimelinePaddingOptions(),
    this.imagePickerConfig = const ImagePickerConfig(),
    this.imagePickerTheme,
    this.timelinePostHeight,
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
    this.iconSize = 24,
    this.postWidgetHeight,
    this.filterOptions = const FilterOptions(),
    this.categoriesOptions = const CategoriesOptions(),
    this.requireImageForPost = false,
    this.minTitleLength,
    this.maxTitleLength,
    this.minContentLength,
    this.maxContentLength,
    this.categorySelectorButtonBuilder,
    this.postOverviewButtonBuilder,
    this.deletionDialogBuilder,
    this.listHeaderBuilder,
    this.titleInputDecoration,
    this.contentInputDecoration,
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
  final bool? sortPostsAscending;

  /// The height of a post in the timeline
  final double? timelinePostHeight;

  /// Class that contains all the translations used in the timeline
  final TimelineTranslations translations;

  /// Class that contains all the paddings used in the timeline
  final TimelinePaddingOptions paddings;

  final ButtonBuilder? buttonBuilder;

  final TextInputBuilder? textInputBuilder;

  final UserAvatarBuilder? userAvatarBuilder;

  /// When the imageUrl is null this anonymousAvatarBuilder will be used
  /// You can use it to display a default avatarW
  final UserAvatarBuilder? anonymousAvatarBuilder;

  final String Function(TimelinePosterUserModel?)? nameBuilder;

  /// ImagePickerTheme can be used to change the UI of the
  /// Image Picker Widget to change the text/icons to your liking.
  final ImagePickerTheme? imagePickerTheme;

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

  /// Size of icons like the comment and like icons. Dafualts to 26
  final double iconSize;

  /// Sets a predefined height for the postWidget.
  final double? postWidgetHeight;

  /// Options for filtering
  final FilterOptions filterOptions;

  /// Options for using the category selector.
  final CategoriesOptions categoriesOptions;

  /// Require image for post
  final bool requireImageForPost;

  /// Minimum length of the title
  final int? minTitleLength;

  /// Maximum length of the title
  final int? maxTitleLength;

  /// Minimum length of the post content
  final int? minContentLength;

  /// Maximum length of the post content
  final int? maxContentLength;

  /// Builder for the category selector button
  /// on the timeline category selection screen
  final Widget Function(
    BuildContext context,
    Function() onPressed,
    String text,
  )? categorySelectorButtonBuilder;

  /// This widgetbuilder is placed at the top of the list of posts and can be
  ///  used to add custom elements
  final Widget Function(BuildContext context, String? category)?
      listHeaderBuilder;

  /// Builder for the post overview button
  /// on the timeline post overview screen
  final Widget Function(
    BuildContext context,
    Function() onPressed,
    String text,
  )? postOverviewButtonBuilder;

  /// Optional builder to override the default alertdialog for post deletion
  /// It should pop the navigator with true to delete the post and
  /// false to cancel deletion
  final WidgetBuilder? deletionDialogBuilder;

  /// inputdecoration for the title textfield
  final InputDecoration? titleInputDecoration;

  /// inputdecoration for the content textfield
  final InputDecoration? contentInputDecoration;
}

List<TimelineCategory> _getDefaultCategories(context) => [
      const TimelineCategory(
        key: null,
        title: 'All',
      ),
      const TimelineCategory(
        key: 'Category',
        title: 'Category',
      ),
      const TimelineCategory(
        key: 'Category with two lines',
        title: 'Category with two lines',
      ),
    ];

class CategoriesOptions {
  const CategoriesOptions({
    this.categoriesBuilder = _getDefaultCategories,
    this.categoryButtonBuilder,
    this.categorySelectorHorizontalPadding,
  });

  /// List of categories that the user can select.
  /// If this is null no categories will be shown.
  final List<TimelineCategory> Function(BuildContext context)?
      categoriesBuilder;

  /// Abilty to override the standard category selector
  final Widget Function(
    TimelineCategory category,
    Function() onTap,
    // ignore: avoid_positional_boolean_parameters
    bool selected,
    bool isOnTop,
  )? categoryButtonBuilder;

  /// Overides the standard horizontal padding of the whole category selector.
  final double? categorySelectorHorizontalPadding;

  TimelineCategory? getCategoryByKey(
    BuildContext context,
    String? key,
  ) {
    if (categoriesBuilder == null) {
      return null;
    }

    return categoriesBuilder!
        .call(context)
        .firstWhereOrNull((category) => category.key == key);
  }
}

class FilterOptions {
  const FilterOptions({
    this.initialFilterWord,
    this.searchBarBuilder,
    this.onFilterEnabledChange,
  });

  /// Set a value to search through posts. When set the searchbar is shown.
  /// If null no searchbar is shown.
  final String? initialFilterWord;

  // Possibilty to override the standard search bar.
  final Widget Function(
    Future<List<TimelinePost>> Function(
      String filterWord,
    ) search,
  )? searchBarBuilder;

  final void Function({required bool filterEnabled})? onFilterEnabledChange;
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
