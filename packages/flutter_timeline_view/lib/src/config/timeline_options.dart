// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_image_picker/flutter_image_picker.dart';
import 'package:flutter_timeline_view/src/config/timeline_translations.dart';
import 'package:intl/intl.dart';

@immutable
class TimelineOptions {
  const TimelineOptions({
    this.translations = const TimelineTranslations(),
    this.imagePickerConfig = const ImagePickerConfig(),
    this.imagePickerTheme = const ImagePickerTheme(),
    this.dateformat,
    this.buttonBuilder,
    this.textInputBuilder,
  });

  /// The format to display the post time in
  final DateFormat? dateformat;

  final TimelineTranslations translations;

  final ButtonBuilder? buttonBuilder;

  final TextInputBuilder? textInputBuilder;

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
