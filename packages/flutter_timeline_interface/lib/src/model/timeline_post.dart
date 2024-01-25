// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';

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
    required this.content,
    required this.likes,
    required this.reaction,
    required this.createdAt,
    required this.reactionEnabled,
    this.category,
    this.creator,
    this.likedBy,
    this.reactions,
    this.imageUrl,
    this.image,
    this.data = const {},
  });

  factory TimelinePost.fromJson(String id, Map<String, dynamic> json) =>
      TimelinePost(
        id: id,
        creatorId: json['creator_id'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        imageUrl: json['image_url'] as String?,
        content: json['content'] as String,
        likes: json['likes'] as int,
        likedBy: (json['liked_by'] as List<dynamic>?)?.cast<String>() ?? [],
        reaction: json['reaction'] as int,
        reactions: (json['reactions'] as List<dynamic>?)
            ?.map(
              (e) => TimelinePostReaction.fromJson(
                (e as Map).keys.first,
                id,
                e.values.first as Map<String, dynamic>,
              ),
            )
            .toList(),
        createdAt: DateTime.parse(json['created_at'] as String),
        reactionEnabled: json['reaction_enabled'] as bool,
        data: json['data'] ?? {},
      );

  /// The unique identifier of the post.
  final String id;

  /// The unique identifier of the creator of the post.
  final String creatorId;

  /// The creator of the post. If null it isn't loaded yet.
  final TimelinePosterUserModel? creator;

  /// The title of the post.
  final String title;

  /// The category of the post on which can be filtered.
  final String? category;

  /// The url of the image of the post.
  final String? imageUrl;

  /// The image of the post used for uploading.
  final Uint8List? image;

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

  /// Option to add extra data to a timelinepost that won't be shown anywhere
  final Map<String, dynamic> data;

  TimelinePost copyWith({
    String? id,
    String? creatorId,
    TimelinePosterUserModel? creator,
    String? title,
    String? category,
    String? imageUrl,
    Uint8List? image,
    String? content,
    int? likes,
    List<String>? likedBy,
    int? reaction,
    List<TimelinePostReaction>? reactions,
    DateTime? createdAt,
    bool? reactionEnabled,
    Map<String, dynamic>? data,
  }) =>
      TimelinePost(
        id: id ?? this.id,
        creatorId: creatorId ?? this.creatorId,
        creator: creator ?? this.creator,
        title: title ?? this.title,
        category: category ?? this.category,
        imageUrl: imageUrl ?? this.imageUrl,
        image: image ?? this.image,
        content: content ?? this.content,
        likes: likes ?? this.likes,
        likedBy: likedBy ?? this.likedBy,
        reaction: reaction ?? this.reaction,
        reactions: reactions ?? this.reactions,
        createdAt: createdAt ?? this.createdAt,
        reactionEnabled: reactionEnabled ?? this.reactionEnabled,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() => {
        'creator_id': creatorId,
        'title': title,
        'category': category,
        'image_url': imageUrl,
        'content': content,
        'likes': likes,
        'liked_by': likedBy,
        'reaction': reaction,
        // reactions is a list of maps so we need to convert it to a map
        'reactions': reactions?.map((e) => e.toJson()).toList() ?? [],
        'created_at': createdAt.toIso8601String(),
        'reaction_enabled': reactionEnabled,
        'data': data,
      };
}
