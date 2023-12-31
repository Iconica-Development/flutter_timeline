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
        // TODO(anyone): should posts with text have a max height?
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
                        ],
                        const SizedBox(width: 10),
                        if (post.creator!.fullName != null) ...[
                          Text(
                            post.creator!.fullName!,
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
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
                            Text(options.translations.deletePost),
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
            const SizedBox(height: 8),
            // image of the post
            if (post.imageUrl != null) ...[
              Flexible(
                flex: height != null ? 1 : 0,
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
            // post information
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  if (post.likedBy?.contains(userId) ?? false) ...[
                    InkWell(
                      onTap: onTapUnlike,
                      child: options.theme.likedIcon ??
                          Icon(
                            Icons.thumb_up_rounded,
                            color: options.theme.iconColor,
                          ),
                    ),
                  ] else ...[
                    InkWell(
                      onTap: onTapLike,
                      child: options.theme.likeIcon ??
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: options.theme.iconColor,
                          ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  if (post.reactionEnabled)
                    options.theme.commentIcon ??
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                        ),
                ],
              ),
            ),
            Text(
              '${post.likes} ${options.translations.likesTitle}',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: post.creator?.fullName ??
                    options.translations.anonymousUser,
                style: theme.textTheme.titleSmall,
                children: [
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: post.title,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              options.translations.viewPost,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
