import 'package:flutter/material.dart';

@immutable
class TimelinePostReaction {
  const TimelinePostReaction({
    required this.id,
    required this.postId,
    required this.creatorId,
    required this.reaction,
    required this.createdAt,
  });

  /// The unique identifier of the reaction.
  final String id;

  /// The unique identifier of the post on which the reaction is.
  final String postId;

  /// The unique identifier of the creator of the reaction.
  final String creatorId;

  /// The reactiontext
  final String reaction;

  /// Reaction creation date.
  final DateTime createdAt;
}
