// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable
class TimelinePosterUserModel {
  const TimelinePosterUserModel({
    required this.userId,
    this.firstName,
    this.lastName,
    this.imageUrl,
  });

  final String userId;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;

  String? get fullName {
    var fullName = '';

    if (firstName != null && lastName != null) {
      fullName += '$firstName $lastName';
    } else if (firstName != null) {
      fullName += firstName!;
    } else if (lastName != null) {
      fullName += lastName!;
    }

    return fullName == '' ? null : fullName;
  }
}
