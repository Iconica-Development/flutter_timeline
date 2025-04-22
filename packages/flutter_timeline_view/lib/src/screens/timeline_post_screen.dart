// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/post_components/header.dart';
import 'package:flutter_timeline_view/src/widgets/post_components/image.dart';
import 'package:flutter_timeline_view/src/widgets/post_components/info.dart';
import 'package:flutter_timeline_view/src/widgets/reaction_bottom.dart';
import 'package:intl/intl.dart';

class TimelinePostScreen extends StatefulWidget {
  const TimelinePostScreen({
    required this.userId,
    required this.service,
    required this.options,
    required this.post,
    required this.onPostDelete,
    this.allowAllDeletion = false,
    this.isOverviewScreen = false,
    this.onUserTap,
    super.key,
  });

  /// The user id of the current user
  final String userId;

  /// Allow all posts to be deleted instead of
  ///  only the posts of the current user
  final bool allowAllDeletion;

  /// The timeline service to fetch the post details
  final TimelineService service;

  /// Options to configure the timeline screens
  final TimelineOptions options;

  /// The post to show
  final TimelinePost post;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  final VoidCallback onPostDelete;

  final bool? isOverviewScreen;

  @override
  State<TimelinePostScreen> createState() => _TimelinePostScreenState();
}

class _TimelinePostScreenState extends State<TimelinePostScreen> {
  TimelinePost? post;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadPostDetails();
    });
  }

  Future<void> loadPostDetails() async {
    try {
      var loadedPost =
          await widget.service.postService.fetchPostDetails(widget.post);
      setState(() {
        post = loadedPost;
        isLoading = false;
      });
    } on Exception catch (_) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updatePost(TimelinePost newPost) {
    setState(() {
      post = newPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var dateFormat = widget.options.dateFormat ??
        DateFormat(
          "dd/MM/yyyy 'at' HH:mm",
          Localizations.localeOf(context).languageCode,
        );
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    if (this.post == null) {
      return Center(
        child: Text(
          widget.options.translations.postLoadingError,
          style: widget.options.theme.textStyles.errorTextStyle,
        ),
      );
    }
    var post = this.post!;
    post.reactions?.sort(
      (a, b) => widget.options.sortCommentsAscending
          ? a.createdAt.compareTo(b.createdAt)
          : b.createdAt.compareTo(a.createdAt),
    );
    var isLikedByUser = post.likedBy?.contains(widget.userId) ?? false;

    var textInputBuilder = widget.options.textInputBuilder ??
        (controller, suffixIcon, hintText) => TextField(
              style: theme.textTheme.bodyMedium,
              textCapitalization: TextCapitalization.sentences,
              controller: controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                hintText: widget.options.translations.writeComment,
                hintStyle: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.textTheme.bodyMedium!.color!.withOpacity(0.5),
                ),
                fillColor: Colors.white,
                filled: true,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: suffixIcon,
              ),
            );

    return Stack(
      children: [
        RefreshIndicator.adaptive(
          onRefresh: () async {
            updatePost(
              await widget.service.postService.fetchPostDetails(
                await widget.service.postService.fetchPost(
                  post,
                ),
              ),
            );
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: widget.options.paddings.postPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostHeader(
                    service: widget.service,
                    options: widget.options,
                    userId: widget.userId,
                    post: widget.post,
                    allowDeletion: !(widget.isOverviewScreen ?? false) &&
                        (widget.allowAllDeletion ||
                            post.creator?.userId == widget.userId),
                    onUserTap: widget.onUserTap,
                    onPostDelete: widget.onPostDelete,
                  ),
                  if (post.imageUrl != null || post.image != null) ...[
                    const SizedBox(height: 8.0),
                    PostImage(
                      options: widget.options,
                      service: widget.service,
                      userId: widget.userId,
                      post: widget.post,
                      flexible: false,
                      onUpdatePost: loadPostDetails,
                    ),
                  ],
                  const SizedBox(height: 8.0),
                  // post information
                  _PostLikeAndReactionsInformation(
                    options: widget.options,
                    post: widget.post,
                    isLikedByUser: isLikedByUser,
                    onLikePressed: () async {
                      if (widget.isOverviewScreen ?? false) return;
                      if (isLikedByUser) {
                        updatePost(
                          await widget.service.postService.unlikePost(
                            widget.userId,
                            post,
                          ),
                        );
                        setState(() {});
                      } else {
                        updatePost(
                          await widget.service.postService.likePost(
                            widget.userId,
                            post,
                          ),
                        );
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  if (widget.isOverviewScreen != null
                      ? !widget.isOverviewScreen!
                      : false) ...[
                    Text(
                      // ignore: lines_longer_than_80_chars
                      '${post.likes} ${post.likes > 1 ? widget.options.translations.multipleLikesTitle : widget.options.translations.oneLikeTitle}',
                      style: widget.options.theme.textStyles
                              .postLikeTitleAndAmount ??
                          theme.textTheme.titleSmall
                              ?.copyWith(color: Colors.black),
                    ),
                  ],
                  PostTitle(
                    options: widget.options,
                    post: post,
                    isForList: false,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    post.content,
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '${dateFormat.format(post.createdAt)} ',
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  if (post.reactionEnabled && widget.isOverviewScreen != null
                      ? !widget.isOverviewScreen!
                      : false) ...[
                    _CommentSection(
                      options: widget.options,
                      userId: widget.userId,
                      post: widget.post,
                      dateFormat: dateFormat,
                      onReactionLostPress: (
                        LongPressStartDetails details, {
                        required TimelinePostReaction reaction,
                      }) async {
                        if (reaction.creatorId == widget.userId ||
                            widget.allowAllDeletion) {
                          var overlay = Overlay.of(context)
                              .context
                              .findRenderObject()! as RenderBox;
                          var position = RelativeRect.fromRect(
                            Rect.fromPoints(
                              details.globalPosition,
                              details.globalPosition,
                            ),
                            Offset.zero & overlay.size,
                          );
                          // Show popup menu for deletion
                          var value = await showMenu<String>(
                            context: context,
                            position: position,
                            items: [
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text(
                                  widget.options.translations.deleteReaction,
                                ),
                              ),
                            ],
                          );
                          if (value == 'delete') {
                            // Call service to delete reaction
                            updatePost(
                              await widget.service.postService
                                  .deletePostReaction(post, reaction.id),
                            );
                          }
                        }
                      },
                      onLikeReaction: (TimelinePostReaction reaction) async {
                        if (isLikedByUser) {
                          updatePost(
                            await widget.service.postService.unlikeReaction(
                              widget.userId,
                              post,
                              reaction.id,
                            ),
                          );
                          setState(() {});
                        } else {
                          updatePost(
                            await widget.service.postService.likeReaction(
                              widget.userId,
                              post,
                              reaction.id,
                            ),
                          );
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 120),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (post.reactionEnabled && !(widget.isOverviewScreen ?? false))
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: theme.scaffoldBackgroundColor,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: SafeArea(
                bottom: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: post.creator!.imageUrl != null
                          ? widget.options.userAvatarBuilder?.call(
                                post.creator!,
                                28,
                              ) ??
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: CachedNetworkImageProvider(
                                  post.creator!.imageUrl!,
                                ),
                              )
                          : widget.options.anonymousAvatarBuilder?.call(
                                post.creator!,
                                28,
                              ) ??
                              const CircleAvatar(
                                radius: 14,
                                child: Icon(
                                  Icons.person,
                                ),
                              ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 16,
                          top: 8,
                          bottom: 8,
                        ),
                        child: ReactionBottom(
                          messageInputBuilder: textInputBuilder,
                          onReactionSubmit: (reaction) async => updatePost(
                            await widget.service.postService.reactToPost(
                              post,
                              TimelinePostReaction(
                                id: '',
                                postId: post.id,
                                reaction: reaction,
                                creatorId: widget.userId,
                                createdAt: DateTime.now(),
                              ),
                            ),
                          ),
                          translations: widget.options.translations,
                          iconColor: widget.options.theme.iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PostLikeAndReactionsInformation extends StatelessWidget {
  const _PostLikeAndReactionsInformation({
    required this.options,
    required this.post,
    required this.isLikedByUser,
    required this.onLikePressed,
  });

  final TimelineOptions options;
  final TimelinePost post;
  final bool isLikedByUser;
  final VoidCallback onLikePressed;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onLikePressed,
            icon: isLikedByUser
                ? options.theme.likedIcon ??
                    Icon(
                      Icons.favorite_rounded,
                      color: options.theme.iconColor,
                      size: options.iconSize,
                    )
                : options.theme.likeIcon ??
                    Icon(
                      Icons.favorite_outline_outlined,
                      color: options.theme.iconColor,
                      size: options.iconSize,
                    ),
          ),
          const SizedBox(width: 8.0),
          if (post.reactionEnabled)
            options.theme.commentIcon ??
                SvgPicture.asset(
                  'assets/Comment.svg',
                  package: 'flutter_timeline_view',
                  // ignore: deprecated_member_use
                  color: options.theme.iconColor,
                  width: options.iconSize,
                  height: options.iconSize,
                ),
        ],
      );
}

class _CommentSection extends StatelessWidget {
  const _CommentSection({
    required this.options,
    required this.userId,
    required this.post,
    required this.dateFormat,
    required this.onReactionLostPress,
    required this.onLikeReaction,
  });

  final TimelineOptions options;
  final String userId;
  final TimelinePost post;
  final DateFormat dateFormat;

  final void Function(
    LongPressStartDetails details, {
    required TimelinePostReaction reaction,
  }) onReactionLostPress;
  final void Function(TimelinePostReaction reaction) onLikeReaction;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        Text(
          options.translations.commentsTitleOnPost,
          style: theme.textTheme.titleSmall!.copyWith(color: Colors.black),
        ),
        for (var reaction in post.reactions ?? <TimelinePostReaction>[]) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onLongPressStart: (details) async {
              onReactionLostPress(details, reaction: reaction);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reaction.creator?.imageUrl != null &&
                    reaction.creator!.imageUrl!.isNotEmpty) ...[
                  options.userAvatarBuilder?.call(
                        reaction.creator!,
                        14,
                      ) ??
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: CachedNetworkImageProvider(
                          reaction.creator!.imageUrl!,
                        ),
                      ),
                ] else ...[
                  options.anonymousAvatarBuilder?.call(
                        reaction.creator!,
                        14,
                      ) ??
                      const CircleAvatar(
                        radius: 14,
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                ],
                const SizedBox(width: 10),
                if (reaction.imageUrl != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          options.nameBuilder?.call(reaction.creator) ??
                              reaction.creator?.fullName ??
                              options.translations.anonymousUser,
                          style: theme.textTheme.titleSmall!
                              .copyWith(color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl: reaction.imageUrl!,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: options.nameBuilder?.call(reaction.creator) ??
                            reaction.creator?.fullName ??
                            options.translations.anonymousUser,
                        style: theme.textTheme.titleSmall!
                            .copyWith(color: Colors.black),
                        children: [
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: reaction.reaction ?? '',
                            style: theme.textTheme.bodySmall,
                          ),
                          const TextSpan(text: '\n'),
                          TextSpan(
                            text: dateFormat.format(reaction.createdAt),
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: theme.textTheme.labelSmall!.color!
                                  .withOpacity(0.5),
                              letterSpacing: 0.5,
                            ),
                          ),

                          // text should go to new line
                        ],
                      ),
                    ),
                  ),
                ],
                Builder(
                  builder: (context) {
                    var isLikedByUser =
                        reaction.likedBy?.contains(userId) ?? false;
                    return IconButton(
                      padding: const EdgeInsets.only(left: 12),
                      constraints: const BoxConstraints(),
                      onPressed: () => onLikeReaction(reaction),
                      icon: isLikedByUser
                          ? options.theme.likedIcon ??
                              Icon(
                                Icons.favorite_rounded,
                                color: options.theme.iconColor,
                                size: 14,
                              )
                          : options.theme.likeIcon ??
                              Icon(
                                Icons.favorite_outline_outlined,
                                color: options.theme.iconColor,
                                size: 14,
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (post.reactions?.isEmpty ?? true) ...[
          Text(
            options.translations.firstComment,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
