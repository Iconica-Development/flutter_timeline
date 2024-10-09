import "package:timeline_repository_interface/src/models/timeline_user.dart";

class TimelinePostReaction {
  const TimelinePostReaction({
    required this.id,
    required this.postId,
    required this.creatorId,
    required this.createdAt,
    this.reaction,
    this.imageUrl,
    this.creator,
    this.createdAtString,
    this.likedBy,
  });

  factory TimelinePostReaction.fromJson(
    String id,
    String postId,
    Map<String, dynamic> json,
  ) =>
      TimelinePostReaction(
        id: id,
        postId: postId,
        creatorId: json["creator_id"] as String,
        reaction: json["reaction"] as String?,
        imageUrl: json["image_url"] as String?,
        createdAt: DateTime.parse(json["created_at"] as String),
        createdAtString: json["created_at"] as String,
        likedBy: (json["liked_by"] as List<dynamic>?)?.cast<String>() ?? [],
      );

  /// The unique identifier of the reaction.
  final String id;

  /// The unique identifier of the post on which the reaction is.
  final String postId;

  /// The unique identifier of the creator of the reaction.
  final String creatorId;

  /// The creator of the post. If null it isn't loaded yet.
  final TimelineUser? creator;

  /// The reaction text if the creator sent one
  final String? reaction;

  /// The url of the image if the creator sent one
  final String? imageUrl;

  /// Reaction creation date.
  final DateTime createdAt;

  /// Reaction creation date as String with microseconds.
  final String? createdAtString;

  final List<String>? likedBy;

  TimelinePostReaction copyWith({
    String? id,
    String? postId,
    String? creatorId,
    TimelineUser? creator,
    String? reaction,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? likedBy,
  }) =>
      TimelinePostReaction(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        creatorId: creatorId ?? this.creatorId,
        creator: creator ?? this.creator,
        reaction: reaction ?? this.reaction,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        likedBy: likedBy ?? this.likedBy,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        id: {
          "creator_id": creatorId,
          "reaction": reaction,
          "image_url": imageUrl,
          "created_at": createdAt.toIso8601String(),
          "liked_by": likedBy,
        },
      };

  Map<String, dynamic> toJsonWithMicroseconds() => <String, dynamic>{
        id: {
          "creator_id": creatorId,
          "reaction": reaction,
          "image_url": imageUrl,
          "created_at": createdAtString,
          "liked_by": likedBy,
        },
      };
}
