// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable
class FirebaseTimelineOptions {
  const FirebaseTimelineOptions({
    this.usersCollectionName = 'users',
    this.timelineCollectionName = 'timeline',
    this.allTimelineCategories = const [],
  });

  final String usersCollectionName;
  final String timelineCollectionName;
  final List<String> allTimelineCategories;
}
