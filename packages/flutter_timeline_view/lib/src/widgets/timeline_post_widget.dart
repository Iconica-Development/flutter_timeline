// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';

class TimelinePostWidget extends StatelessWidget {
  const TimelinePostWidget({
    required this.userId,
    required this.options,
    required this.post,
    required this.height,
    required this.onTap,
    required this.onTapLike,
    required this.onTapUnlike,
    required this.onPostDelete,
    this.onUserTap,
    super.key,
  });

  /// The user id of the current user
  final String userId;
  final TimelineOptions options;

  final TimelinePost post;

  /// Optional max height of the post
  final double? height;
  final VoidCallback onTap;
  final VoidCallback onTapLike;
  final VoidCallback onTapUnlike;
  final VoidCallback onPostDelete;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: post.imageUrl != null ? height : null,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (post.creator != null)
                  InkWell(
                    onTap: onUserTap != null
                        ? () => onUserTap?.call(post.creator!.userId)
                        : null,
                    child: Row(
                      children: [
                        if (post.creator!.imageUrl != null) ...[
                          options.userAvatarBuilder?.call(
                                post.creator!,
                                40,
                              ) ??
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                  post.creator!.imageUrl!,
                                ),
                              ),
                        ] else ...[
                          options.anonymousAvatarBuilder?.call(
                                post.creator!,
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
                          options.nameBuilder?.call(post.creator) ??
                              post.creator?.fullName ??
                              options.translations.anonymousUser,
                          style:
                              options.theme.textStyles.postCreatorTitleStyle ??
                                  theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                if (options.allowAllDeletion || post.creator?.userId == userId)
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'delete') {
                        onPostDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Text(
                              options.translations.deletePost,
                              style: options.theme.textStyles.deletePostStyle ??
                                  theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            options.theme.deleteIcon ??
                                Icon(
                                  Icons.delete,
                                  color: options.theme.iconColor,
                                ),
                          ],
                        ),
                      ),
                    ],
                    child: options.theme.moreIcon ??
                        Icon(
                          Icons.more_horiz_rounded,
                          color: options.theme.iconColor,
                        ),
                  ),
              ],
            ),
            // image of the post
            if (post.imageUrl != null) ...[
              const SizedBox(height: 8),
              Flexible(
                flex: height != null ? 1 : 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: post.imageUrl!,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
            const SizedBox(
              height: 8,
            ),
            // post information
            Row(
              children: [
                if (post.likedBy?.contains(userId) ?? false) ...[
                  InkWell(
                    onTap: onTapUnlike,
                    child: Container(
                      color: Colors.transparent,
                      child: options.theme.likedIcon ??
                          Icon(
                            Icons.thumb_up_rounded,
                            color: options.theme.iconColor,
                            size: options.iconSize,
                          ),
                    ),
                  ),
                ] else ...[
                  InkWell(
                    onTap: onTapLike,
                    child: Container(
                      color: Colors.transparent,
                      child: options.theme.likeIcon ??
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: options.theme.iconColor,
                            size: options.iconSize,
                          ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                if (post.reactionEnabled)
                  options.theme.commentIcon ??
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: options.theme.iconColor,
                        size: options.iconSize,
                      ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),

            Text(
              '${post.likes} ${options.translations.likesTitle}',
              style: options.theme.textStyles.listPostLikeTitleAndAmount ??
                  theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: options.nameBuilder?.call(post.creator) ??
                    post.creator?.fullName ??
                    options.translations.anonymousUser,
                style: options.theme.textStyles.listCreatorNameStyle ??
                    theme.textTheme.titleSmall,
                children: [
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: post.title,
                    style: options.theme.textStyles.listPostTitleStyle ??
                        theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              options.translations.viewPost,
              style: options.theme.textStyles.viewPostStyle ??
                  theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
