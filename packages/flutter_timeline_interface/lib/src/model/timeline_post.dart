// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/src/model/timeline_poster.dart';
import 'package:flutter_timeline_interface/src/model/timeline_reaction.dart';

/// A post of the timeline.
@immutable
class TimelinePost {
  const TimelinePost({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.category,
    required this.content,
    required this.likes,
    required this.reaction,
    required this.createdAt,
    required this.reactionEnabled,
    this.creator,
    this.likedBy,
    this.reactions,
    this.imageUrl,
  });

  /// The unique identifier of the post.
  final String id;

  /// The unique identifier of the creator of the post.
  final String creatorId;

  /// The creator of the post. If null it isn't loaded yet.
  final TimelinePosterUserModel? creator;

  /// The title of the post.
  final String title;

  /// The category of the post on which can be filtered.
  final String category;

  /// The url of the image of the post.
  final String? imageUrl;

  /// The content of the post.
  final String content;

  /// The number of likes of the post.
  final int likes;

  /// The list of users who liked the post. If null it isn't loaded yet.
  final List<String>? likedBy;

  /// The number of reaction of the post.
  final int reaction;

  /// The list of reactions of the post. If null it isn't loaded yet.
  final List<TimelinePostReaction>? reactions;

  /// Post creation date.
  final DateTime createdAt;

  /// If reacting is enabled on the post.
  final bool reactionEnabled;
}
