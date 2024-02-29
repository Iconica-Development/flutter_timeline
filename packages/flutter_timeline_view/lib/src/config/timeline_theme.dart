// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class TimelineTheme {
  const TimelineTheme({
    this.dividerBuilder,
    this.pagePadding = const EdgeInsets.all(20),
  });

  /// The builder for the divider
  final Widget Function()? dividerBuilder;

  final EdgeInsets pagePadding;
}
