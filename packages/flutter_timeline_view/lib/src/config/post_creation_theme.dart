// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';

class TimelinePostCreationTheme {
  const TimelinePostCreationTheme({
    this.buttonBuilder,
    this.textInputBuilder,
    this.pagePadding = const EdgeInsets.all(20),
  });

  final ButtonBuilder? buttonBuilder;

  final TextInputBuilder? textInputBuilder;

  final EdgeInsets pagePadding;
}
