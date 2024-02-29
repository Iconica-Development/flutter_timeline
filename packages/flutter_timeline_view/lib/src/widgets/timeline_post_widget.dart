// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/tappable_image.dart';

class TimelinePostWidget extends StatefulWidget {
  const TimelinePostWidget({
    required this.userId,
    required this.options,
    required this.post,
    required this.onTap,
    required this.onTapLike,
    required this.onTapUnlike,
    required this.onPostDelete,
    required this.service,
    this.onUserTap,
    super.key,
  });

  /// The user id of the current user
  final String userId;
  final TimelineOptions options;

  final TimelinePost post;

  /// Optional max height of the post
  final VoidCallback onTap;
  final VoidCallback onTapLike;
  final VoidCallback onTapUnlike;
  final VoidCallback onPostDelete;
  final TimelineService service;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  @override
  State<TimelinePostWidget> createState() => _TimelinePostWidgetState();
}

class _TimelinePostWidgetState extends State<TimelinePostWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: widget.onTap,
      child: SizedBox(
        height: widget.post.imageUrl != null
            ? widget.options.postTheme.postWidgetHeight
            : null,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.post.creator != null)
                  InkWell(
                    onTap: widget.onUserTap != null
                        ? () =>
                            widget.onUserTap?.call(widget.post.creator!.userId)
                        : null,
                    child: Row(
                      children: [
                        if (widget.post.creator!.imageUrl != null) ...[
                          widget.options.postTheme.userAvatarBuilder?.call(
                                widget.post.creator!,
                                40,
                              ) ??
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                  widget.post.creator!.imageUrl!,
                                ),
                              ),
                        ] else ...[
                          widget.options.postTheme.anonymousAvatarBuilder?.call(
                                widget.post.creator!,
                                40,
                              ) ??
                              const CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  Icons.person,
                                ),
                              ),
                        ],
                        const SizedBox(width: 10),
                        Text(
                          widget.options.postTheme.nameBuilder
                                  ?.call(widget.post.creator) ??
                              widget.post.creator?.fullName ??
                              widget.options.translations.anonymousUser,
                          style:
                              widget.options.textStyles.postCreatorTitleStyle ??
                                  theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                if (widget.options.config.allowAllDeletion ||
                    widget.post.creator?.userId == widget.userId)
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'delete') {
                        widget.onPostDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Text(
                              widget.options.translations.deletePost,
                              style:
                                  widget.options.textStyles.deletePostStyle ??
                                      theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            widget.options.postTheme.iconTheme.deleteIcon ??
                                Icon(
                                  Icons.delete,
                                  color: widget
                                      .options.postTheme.iconTheme.iconColor,
                                ),
                          ],
                        ),
                      ),
                    ],
                    child: widget.options.postTheme.iconTheme.moreIcon ??
                        Icon(
                          Icons.more_horiz_rounded,
                          color: widget.options.postTheme.iconTheme.iconColor,
                        ),
                  ),
              ],
            ),
            // image of the post
            if (widget.post.imageUrl != null) ...[
              const SizedBox(height: 8),
              Flexible(
                flex: widget.options.postTheme.postWidgetHeight != null ? 1 : 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: widget.options.postConfig.doubleTapTolike
                      ? TappableImage(
                          likeAndDislikeIcon: widget.options.postTheme.iconTheme
                              .likeAndDislikeIconsForDoubleTap,
                          post: widget.post,
                          userId: widget.userId,
                          onLike: ({required bool liked}) async {
                            var userId = widget.userId;

                            late TimelinePost result;

                            if (!liked) {
                              result =
                                  await widget.service.postService.likePost(
                                userId,
                                widget.post,
                              );
                            } else {
                              result =
                                  await widget.service.postService.unlikePost(
                                userId,
                                widget.post,
                              );
                            }

                            return result.likedBy?.contains(userId) ?? false;
                          },
                        )
                      : CachedNetworkImage(
                          width: double.infinity,
                          imageUrl: widget.post.imageUrl!,
                          fit: BoxFit.fitWidth,
                        ),
                ),
              ),
            ],
            const SizedBox(
              height: 8,
            ),
            // post information
            if (widget.options.postTheme.iconsWithValues)
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      var userId = widget.userId;

                      var liked =
                          widget.post.likedBy?.contains(userId) ?? false;

                      if (!liked) {
                        await widget.service.postService.likePost(
                          userId,
                          widget.post,
                        );
                      } else {
                        await widget.service.postService.unlikePost(
                          userId,
                          widget.post,
                        );
                      }
                    },
                    icon: widget.options.postTheme.iconTheme.likeIcon ??
                        Icon(
                          widget.post.likedBy?.contains(widget.userId) ?? false
                              ? Icons.favorite
                              : Icons.favorite_outline_outlined,
                        ),
                    label: Text('${widget.post.likes}'),
                  ),
                  if (widget.post.reactionEnabled)
                    TextButton.icon(
                      onPressed: widget.onTap,
                      icon: widget.options.postTheme.iconTheme.commentIcon ??
                          const Icon(
                            Icons.chat_bubble_outline_outlined,
                          ),
                      label: Text('${widget.post.reaction}'),
                    ),
                ],
              )
            else
              Row(
                children: [
                  if (widget.post.likedBy?.contains(widget.userId) ??
                      false) ...[
                    InkWell(
                      onTap: widget.onTapUnlike,
                      child: Container(
                        color: Colors.transparent,
                        child: widget.options.postTheme.iconTheme.likedIcon ??
                            Icon(
                              Icons.thumb_up_rounded,
                              color:
                                  widget.options.postTheme.iconTheme.iconColor,
                              size: widget.options.postTheme.iconSize,
                            ),
                      ),
                    ),
                  ] else ...[
                    InkWell(
                      onTap: widget.onTapLike,
                      child: Container(
                        color: Colors.transparent,
                        child: widget.options.postTheme.iconTheme.likedIcon ??
                            Icon(
                              Icons.thumb_up_rounded,
                              color:
                                  widget.options.postTheme.iconTheme.iconColor,
                              size: widget.options.postTheme.iconSize,
                            ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  if (widget.post.reactionEnabled) ...[
                    Container(
                      color: Colors.transparent,
                      child: widget.options.postTheme.iconTheme.commentIcon ??
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: widget.options.postTheme.iconTheme.iconColor,
                            size: widget.options.postTheme.iconSize,
                          ),
                    ),
                  ],
                ],
              ),

            const SizedBox(
              height: 8,
            ),

            if (widget.options.postTheme.itemInfoBuilder != null) ...[
              widget.options.postTheme.itemInfoBuilder!(
                post: widget.post,
              ),
            ] else ...[
              Text(
                '${widget.post.likes} '
                '${widget.options.translations.likesTitle}',
                style: widget.options.textStyles.listPostLikeTitleAndAmount ??
                    theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  text: widget.options.postTheme.nameBuilder
                          ?.call(widget.post.creator) ??
                      widget.post.creator?.fullName ??
                      widget.options.translations.anonymousUser,
                  style: widget.options.textStyles.listCreatorNameStyle ??
                      theme.textTheme.titleSmall,
                  children: [
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: widget.post.title,
                      style: widget.options.textStyles.listPostTitleStyle ??
                          theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.options.translations.viewPost,
                style: widget.options.textStyles.viewPostStyle ??
                    theme.textTheme.bodySmall,
              ),
            ],
            if (widget.options.theme.dividerBuilder != null)
              widget.options.theme.dividerBuilder!(),
          ],
        ),
      ),
    );
  }
}
