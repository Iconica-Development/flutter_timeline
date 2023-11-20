// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/src/model/timeline_poster.dart';

@immutable
class TimelinePostReaction {
  const TimelinePostReaction({
    required this.id,
    required this.postId,
    required this.creatorId,
    required this.createdAt,
    this.reaction,
    this.imageUrl,
    this.creator,
  });

  /// The unique identifier of the reaction.
  final String id;

  /// The unique identifier of the post on which the reaction is.
  final String postId;

  /// The unique identifier of the creator of the reaction.
  final String creatorId;

  /// The creator of the post. If null it isn't loaded yet.
  final TimelinePosterUserModel? creator;

  /// The reaction text if the creator sent one
  final String? reaction;

  /// The url of the image if the creator sent one
  final String? imageUrl;

  /// Reaction creation date.
  final DateTime createdAt;
}
