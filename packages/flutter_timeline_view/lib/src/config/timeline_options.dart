// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_picker/flutter_image_picker.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';
import 'package:flutter_timeline_view/src/config/post_config.dart';
import 'package:flutter_timeline_view/src/config/post_creation_config.dart';
import 'package:flutter_timeline_view/src/config/post_creation_theme.dart';
import 'package:flutter_timeline_view/src/config/post_theme.dart';
import 'package:flutter_timeline_view/src/config/timeline_config.dart';
import 'package:flutter_timeline_view/src/config/timeline_theme.dart';

class TimelineOptions {
  const TimelineOptions({
    this.textStyles = const TimelineTextStyles(),
    this.translations = const TimelineTranslations.empty(),
    this.imagePickerConfig = const ImagePickerConfig(),
    this.imagePickerTheme = const ImagePickerTheme(),
    this.filterOptions = const FilterOptions(),
    this.categoriesOptions = const CategoriesOptions(),
    this.postTheme = const TimelinePostTheme(),
    this.config = const TimelineConfig(),
    this.postConfig = const TimelinePostConfig(),
    this.theme = const TimelineTheme(),
    this.postCreationTheme = const TimelinePostCreationTheme(),
    this.postCreationConfig = const TimelinePostCreationConfig(),
  });

  /// Parameter to set all textstyles within timeline
  final TimelineTextStyles textStyles;

  final TimelineTranslations translations;

  /// ImagePickerTheme can be used to change the UI of the
  /// Image Picker Widget to change the text/icons to your liking.
  final ImagePickerTheme imagePickerTheme;

  /// ImagePickerConfig can be used to define the
  /// size and quality for the uploaded image.
  final ImagePickerConfig imagePickerConfig;

  /// Options for filtering
  final FilterOptions filterOptions;

  /// Options for using the category selector.
  final CategoriesOptions categoriesOptions;

  final TimelineConfig config;
  final TimelineTheme theme;

  final TimelinePostConfig postConfig;
  final TimelinePostTheme postTheme;

  final TimelinePostCreationTheme postCreationTheme;
  final TimelinePostCreationConfig postCreationConfig;
}

class CategoriesOptions {
  const CategoriesOptions({
    this.categoriesBuilder,
    this.categoryButtonBuilder,
    this.categorySelectorHorizontalPadding,
  });

  /// List of categories that the user can select.
  /// If this is null no categories will be shown.
  final List<TimelineCategory> Function(BuildContext context)?
      categoriesBuilder;

  /// Abilty to override the standard category selector
  final Widget Function({
    required String? categoryKey,
    required String categoryName,
    required Function onTap,
    required bool selected,
  })? categoryButtonBuilder;

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
