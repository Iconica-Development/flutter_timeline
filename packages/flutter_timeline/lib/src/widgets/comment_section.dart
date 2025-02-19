import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";

class CommentSection extends StatefulWidget {
  const CommentSection({
    required this.options,
    required this.post,
    required this.currentUserId,
    required this.timelineService,
    super.key,
  });
  final TimelineOptions options;
  final TimelinePost post;
  final String currentUserId;
  final TimelineService timelineService;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          widget.options.translations.commentsTitle,
          style: theme.textTheme.titleSmall!.copyWith(color: Colors.black),
        ),
        const SizedBox(
          height: 4,
        ),
        for (TimelinePostReaction reaction in widget.post.reactions ?? []) ...[
          Builder(
            builder: (context) => const SizedBox(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.options.userAvatarBuilder.call(reaction.creator, 24),
                    const SizedBox(width: 8),
                    widget.options.userNameBuilder.call(
                      reaction.creator,
                      widget.options.translations.anonymousUser,
                      context,
                    ),
                    const SizedBox(width: 8),
                    if (reaction.imageUrl != null) ...[
                      CachedNetworkImage(
                        imageUrl: reaction.imageUrl!,
                      ),
                    ] else ...[
                      Flexible(
                        child: Text(
                          reaction.reaction ?? "",
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  var reactionIsLikedByCurrentUser =
                      reaction.likedBy?.contains(widget.currentUserId) ?? false;
                  return IconButton(
                    iconSize: 14,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      reactionIsLikedByCurrentUser
                          ? widget.options.likedIcon
                          : widget.options.likeIcon,
                    ),
                    onPressed: () async {
                      if (reactionIsLikedByCurrentUser) {
                        await widget.timelineService.unlikePostReaction(
                          widget.post,
                          reaction,
                          widget.currentUserId,
                        );
                      } else {
                        await widget.timelineService.likePostReaction(
                          widget.post,
                          reaction,
                          widget.currentUserId,
                        );
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ],
    );
  }
}
