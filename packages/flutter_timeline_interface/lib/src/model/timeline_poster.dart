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

  factory TimelinePosterUserModel.fromJson(
    Map<String, dynamic> json,
    String userId,
  ) =>
      TimelinePosterUserModel(
        userId: userId,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        imageUrl: json['image_url'] as String?,
      );

  final String userId;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'image_url': imageUrl,
      };

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
