// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/default_filled_button.dart';
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
    required this.allowAllDeletion,
    this.onUserTap,
    super.key,
  });

  /// The user id of the current user
  final String userId;

  /// Allow all posts to be deleted instead of
  ///  only the posts of the current user
  final bool allowAllDeletion;

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
    var isLikedByUser = widget.post.likedBy?.contains(widget.userId) ?? false;
    return SizedBox(
      height: widget.post.imageUrl != null || widget.post.image != null
          ? widget.options.postWidgetHeight
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
                        widget.options.userAvatarBuilder?.call(
                              widget.post.creator!,
                              28,
                            ) ??
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: CachedNetworkImageProvider(
                                widget.post.creator!.imageUrl!,
                              ),
                            ),
                      ] else ...[
                        widget.options.anonymousAvatarBuilder?.call(
                              widget.post.creator!,
                              28,
                            ) ??
                            const CircleAvatar(
                              radius: 14,
                              child: Icon(
                                Icons.person,
                              ),
                            ),
                      ],
                      const SizedBox(width: 10),
                      Text(
                        widget.options.nameBuilder?.call(widget.post.creator) ??
                            widget.post.creator?.fullName ??
                            widget.options.translations.anonymousUser,
                        style: widget.options.theme.textStyles
                                .postCreatorTitleStyle ??
                            theme.textTheme.titleSmall!.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              if (widget.allowAllDeletion ||
                  widget.post.creator?.userId == widget.userId)
                PopupMenuButton(
                  onSelected: (value) async {
                    if (value == 'delete') {
                      await showPostDeletionConfirmationDialog(
                        widget.options,
                        context,
                        widget.onPostDelete,
                      );
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
                            style: widget
                                    .options.theme.textStyles.deletePostStyle ??
                                theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          widget.options.theme.deleteIcon ??
                              Icon(
                                Icons.delete,
                                color: widget.options.theme.iconColor,
                              ),
                        ],
                      ),
                    ),
                  ],
                  child: widget.options.theme.moreIcon ??
                      Icon(
                        Icons.more_horiz_rounded,
                        color: widget.options.theme.iconColor,
                      ),
                ),
            ],
          ),
          // image of the post
          if (widget.post.imageUrl != null || widget.post.image != null) ...[
            const SizedBox(height: 8),
            Flexible(
              flex: widget.options.postWidgetHeight != null ? 1 : 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: widget.options.doubleTapTolike
                    ? TappableImage(
                        likeAndDislikeIcon:
                            widget.options.likeAndDislikeIconsForDoubleTap,
                        post: widget.post,
                        userId: widget.userId,
                        onLike: ({required bool liked}) async {
                          var userId = widget.userId;

                          late TimelinePost result;

                          if (!liked) {
                            result = await widget.service.postService.likePost(
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
                    : widget.post.imageUrl != null
                        ? CachedNetworkImage(
                            width: double.infinity,
                            imageUrl: widget.post.imageUrl!,
                            fit: BoxFit.fitWidth,
                          )
                        : Image.memory(
                            width: double.infinity,
                            widget.post.image!,
                            fit: BoxFit.fitWidth,
                          ),
              ),
            ),
          ],
          const SizedBox(
            height: 8,
          ),
          // post information
          if (widget.options.iconsWithValues) ...[
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    var userId = widget.userId;

                    if (!isLikedByUser) {
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
                  icon: widget.options.theme.likeIcon ??
                      Icon(
                        isLikedByUser
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_outlined,
                        color: widget.options.theme.iconColor,
                        size: widget.options.iconSize,
                      ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text('${widget.post.likes}'),
                if (widget.post.reactionEnabled) ...[
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: widget.onTap,
                    icon: widget.options.theme.commentIcon ??
                        SvgPicture.asset(
                          'assets/Comment.svg',
                          package: 'flutter_timeline_view',
                          // ignore: deprecated_member_use
                          color: widget.options.theme.iconColor,
                          width: widget.options.iconSize,
                          height: widget.options.iconSize,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text('${widget.post.reaction}'),
                ],
              ],
            ),
          ] else ...[
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed:
                      isLikedByUser ? widget.onTapUnlike : widget.onTapLike,
                  icon: (isLikedByUser
                          ? widget.options.theme.likedIcon
                          : widget.options.theme.likeIcon) ??
                      Icon(
                        isLikedByUser
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline,
                        color: widget.options.theme.iconColor,
                        size: widget.options.iconSize,
                      ),
                ),
                const SizedBox(width: 8),
                if (widget.post.reactionEnabled) ...[
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: widget.onTap,
                    icon: widget.options.theme.commentIcon ??
                        SvgPicture.asset(
                          'assets/Comment.svg',
                          package: 'flutter_timeline_view',
                          // ignore: deprecated_member_use
                          color: widget.options.theme.iconColor,
                          width: widget.options.iconSize,
                          height: widget.options.iconSize,
                        ),
                  ),
                ],
              ],
            ),
          ],

          const SizedBox(
            height: 8,
          ),

          if (widget.options.itemInfoBuilder != null) ...[
            widget.options.itemInfoBuilder!(
              post: widget.post,
            ),
          ] else ...[
            Text(
              '${widget.post.likes} '
              '${widget.post.likes > 1 ? 
              widget.options.translations.multipleLikesTitle : 
              widget.options.translations.oneLikeTitle}',
              style:
                  widget.options.theme.textStyles.listPostLikeTitleAndAmount ??
                      theme.textTheme.titleSmall!.copyWith(
                        color: Colors.black,
                      ),
            ),
            Text.rich(
              TextSpan(
                text: widget.options.nameBuilder?.call(widget.post.creator) ??
                    widget.post.creator?.fullName ??
                    widget.options.translations.anonymousUser,
                style: widget.options.theme.textStyles.listCreatorNameStyle ??
                    theme.textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                    ),
                children: [
                  TextSpan(
                    text: widget.post.title,
                    style: widget.options.theme.textStyles.listPostTitleStyle ??
                        theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: widget.onTap,
              child: Text(
                widget.options.translations.viewPost,
                style: widget.options.theme.textStyles.viewPostStyle ??
                    theme.textTheme.titleSmall!.copyWith(
                      color: const Color(0xFF8D8D8D),
                    ),
              ),
            ),
          ],
          if (widget.options.dividerBuilder != null)
            widget.options.dividerBuilder!(),
        ],
      ),
    );
  }
}

Future<void> showPostDeletionConfirmationDialog(
  TimelineOptions options,
  BuildContext context,
  Function() onPostDelete,
) async {
  var theme = Theme.of(context);
  var result = await showDialog(
    context: context,
    builder: (BuildContext context) =>
        options.deletionDialogBuilder?.call(context) ??
        AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
          titlePadding: const EdgeInsets.only(left: 44, right: 44, top: 32),
          title: Text(
            options.translations.deleteConfirmationMessage,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DefaultFilledButton(
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                      buttonText: options.translations.deleteButton,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  options.translations.deleteCancelButton,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    decoration: TextDecoration.underline,
                    color: theme.textTheme.bodyMedium?.color!.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
  );

  if (result == true) {
    onPostDelete();
  }
}
