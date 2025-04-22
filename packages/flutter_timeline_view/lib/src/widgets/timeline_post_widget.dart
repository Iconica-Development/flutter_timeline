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
    var isLikedByUser = widget.post.likedBy?.contains(widget.userId) ?? false;

    return SizedBox(
      height: widget.post.imageUrl != null || widget.post.image != null
          ? widget.options.postWidgetHeight
          : null,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostHeader(
            service: widget.service,
            options: widget.options,
            userId: widget.userId,
            post: widget.post,
            allowDeletion: widget.allowAllDeletion ||
                widget.post.creator?.userId == widget.userId,
            onUserTap: widget.onUserTap,
            onPostDelete: widget.onPostDelete,
          ),
          if (widget.post.imageUrl != null || widget.post.image != null) ...[
            const SizedBox(height: 8.0),
            _PostImage(
              service: widget.service,
              options: widget.options,
              userId: widget.userId,
              post: widget.post,
            ),
          ],
          const SizedBox(height: 8.0),
          _PostLikeAndReactionsInformation(
            service: widget.service,
            options: widget.options,
            userId: widget.userId,
            post: widget.post,
            isLikedByUser: isLikedByUser,
            onTapComment: widget.onTap,
          ),
          const SizedBox(height: 8.0),
          if (widget.options.itemInfoBuilder != null) ...[
            widget.options.itemInfoBuilder!(post: widget.post),
          ] else ...[
            _PostInfo(
              options: widget.options,
              post: widget.post,
              onTap: widget.onTap,
            ),
          ],
          if (widget.options.dividerBuilder != null) ...[
            widget.options.dividerBuilder!(),
          ],
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.service,
    required this.options,
    required this.userId,
    required this.post,
    required this.allowDeletion,
    required this.onUserTap,
    required this.onPostDelete,
  });

  final TimelineService service;
  final TimelineOptions options;
  final String userId;
  final TimelinePost post;
  final bool allowDeletion;
  final void Function(String userId)? onUserTap;
  final VoidCallback onPostDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      children: [
        if (post.creator != null) ...[
          InkWell(
            onTap: onUserTap != null
                ? () => onUserTap?.call(post.creator!.userId)
                : null,
            child: Row(
              children: [
                if (post.creator!.imageUrl != null) ...[
                  options.userAvatarBuilder?.call(
                        post.creator!,
                        28,
                      ) ??
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: CachedNetworkImageProvider(
                          post.creator!.imageUrl!,
                        ),
                      ),
                ] else ...[
                  options.anonymousAvatarBuilder?.call(
                        post.creator!,
                        28,
                      ) ??
                      const CircleAvatar(
                        radius: 14,
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                ],
                const SizedBox(width: 10.0),
                Text(
                  options.nameBuilder?.call(post.creator) ??
                      post.creator?.fullName ??
                      options.translations.anonymousUser,
                  style: options.theme.textStyles.listPostCreatorTitleStyle ??
                      theme.textTheme.titleSmall!.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
        const Spacer(),
        if (allowDeletion) ...[
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'delete') {
                await showPostDeletionConfirmationDialog(
                  options,
                  context,
                  onPostDelete,
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Text(
                      options.translations.deletePost,
                      style: options.theme.textStyles.deletePostStyle ??
                          theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8.0),
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
      ],
    );
  }
}

class _PostLikeAndReactionsInformation extends StatelessWidget {
  const _PostLikeAndReactionsInformation({
    required this.service,
    required this.options,
    required this.userId,
    required this.post,
    required this.isLikedByUser,
    required this.onTapComment,
  });

  final TimelineService service;
  final TimelineOptions options;
  final String userId;
  final TimelinePost post;
  final bool isLikedByUser;
  final VoidCallback onTapComment;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () async {
              if (!isLikedByUser) {
                await service.postService.likePost(
                  userId,
                  post,
                );
              } else {
                await service.postService.unlikePost(
                  userId,
                  post,
                );
              }
            },
            icon: options.theme.likeIcon ??
                Icon(
                  isLikedByUser
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_outlined,
                  color: options.theme.iconColor,
                  size: options.iconSize,
                ),
          ),
          const SizedBox(width: 4.0),
          if (options.iconsWithValues) ...[
            Text('${post.likes}'),
          ],
          if (post.reactionEnabled) ...[
            const SizedBox(width: 8.0),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onTapComment,
              icon: options.theme.commentIcon ??
                  SvgPicture.asset(
                    'assets/Comment.svg',
                    package: 'flutter_timeline_view',
                    // ignore: deprecated_member_use
                    color: options.theme.iconColor,
                    width: options.iconSize,
                    height: options.iconSize,
                  ),
            ),
            if (options.iconsWithValues) ...[
              const SizedBox(width: 4.0),
              Text('${post.reaction}'),
            ],
          ],
        ],
      );
}

class _PostImage extends StatelessWidget {
  const _PostImage({
    required this.options,
    required this.service,
    required this.userId,
    required this.post,
  });

  final TimelineOptions options;
  final TimelineService service;
  final String userId;
  final TimelinePost post;

  @override
  Widget build(BuildContext context) => Flexible(
        flex: options.postWidgetHeight != null ? 1 : 0,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: options.doubleTapTolike
              ? TappableImage(
                  likeAndDislikeIcon: options.likeAndDislikeIconsForDoubleTap,
                  post: post,
                  userId: userId,
                  onLike: ({required bool liked}) async {
                    TimelinePost result;

                    if (!liked) {
                      result = await service.postService.likePost(
                        userId,
                        post,
                      );
                    } else {
                      result = await service.postService.unlikePost(
                        userId,
                        post,
                      );
                    }

                    return result.likedBy?.contains(userId) ?? false;
                  },
                )
              : post.imageUrl != null
                  ? CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: post.imageUrl!,
                      fit: BoxFit.fitWidth,
                    )
                  : Image.memory(
                      width: double.infinity,
                      post.image!,
                      fit: BoxFit.fitWidth,
                    ),
        ),
      );
}

class _PostInfo extends StatelessWidget {
  const _PostInfo({
    required this.options,
    required this.post,
    required this.onTap,
  });

  final TimelineOptions options;
  final TimelinePost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        _PostLikeCountText(
          post: post,
          options: options,
        ),
        const SizedBox(height: 4.0),
        Row(
          children: [
            Text(
              options.nameBuilder?.call(post.creator) ??
                  post.creator?.fullName ??
                  options.translations.anonymousUser,
              style: options.theme.textStyles.listCreatorNameStyle ??
                  theme.textTheme.titleSmall!.copyWith(
                    color: Colors.black,
                  ),
            ),
            const SizedBox(width: 4.0),
            Text(
              post.title,
              style: options.theme.textStyles.listPostTitleStyle ??
                  theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        InkWell(
          onTap: onTap,
          child: Text(
            options.translations.viewPost,
            style: options.theme.textStyles.viewPostStyle ??
                theme.textTheme.titleSmall!.copyWith(
                  color: const Color(0xFF8D8D8D),
                ),
          ),
        ),
      ],
    );
  }
}

class _PostLikeCountText extends StatelessWidget {
  const _PostLikeCountText({
    required this.post,
    required this.options,
  });

  final TimelineOptions options;
  final TimelinePost post;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var likeTranslation = post.likes > 1
        ? options.translations.multipleLikesTitle
        : options.translations.oneLikeTitle;

    return Text(
      '${post.likes} '
      '$likeTranslation',
      style: options.theme.textStyles.listPostLikeTitleAndAmount ??
          theme.textTheme.titleSmall!.copyWith(
            color: Colors.black,
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
