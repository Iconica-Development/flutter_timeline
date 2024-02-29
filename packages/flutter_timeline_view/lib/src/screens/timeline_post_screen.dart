// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_image_picker/flutter_image_picker.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/reaction_bottom.dart';
import 'package:flutter_timeline_view/src/widgets/tappable_image.dart';
import 'package:intl/intl.dart';

class TimelinePostScreen extends StatelessWidget {
  const TimelinePostScreen({
    required this.userId,
    required this.service,
    required this.options,
    required this.post,
    required this.onPostDelete,
    this.onUserTap,
    super.key,
  });

  /// The user id of the current user
  final String userId;

  /// The timeline service to fetch the post details
  final TimelineService service;

  /// Options to configure the timeline screens
  final TimelineOptions options;

  /// The post to show
  final TimelinePost post;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  final VoidCallback onPostDelete;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _TimelinePostScreen(
          userId: userId,
          service: service,
          options: options,
          post: post,
          onPostDelete: onPostDelete,
          onUserTap: onUserTap,
        ),
      );
}

class _TimelinePostScreen extends StatefulWidget {
  const _TimelinePostScreen({
    required this.userId,
    required this.service,
    required this.options,
    required this.post,
    required this.onPostDelete,
    this.onUserTap,
  });

  final String userId;

  final TimelineService service;

  final TimelineOptions options;

  final TimelinePost post;

  final Function(String userId)? onUserTap;

  final VoidCallback onPostDelete;

  @override
  State<_TimelinePostScreen> createState() => _TimelinePostScreenState();
}

class _TimelinePostScreenState extends State<_TimelinePostScreen> {
  TimelinePost? post;
  bool isLoading = true;

  late var textInputBuilder =
      widget.options.postCreationTheme.textInputBuilder ??
          (controller, suffixIcon, hintText) => TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  suffixIcon: suffixIcon,
                ),
              );

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
    } on Exception catch (e) {
      debugPrint('Error loading post: $e');
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
    var dateFormat = widget.options.postTheme.dateFormat ??
        DateFormat('dd/MM/yyyy', Localizations.localeOf(context).languageCode);
    var timeFormat = widget.options.postTheme.timeFormat ?? DateFormat('HH:mm');

    if (isLoading) {
      const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (this.post == null) {
      return Center(
        child: Text(
          widget.options.translations.postLoadingError,
          style: widget.options.textStyles.errorTextStyle,
        ),
      );
    }
    var post = this.post!;
    post.reactions?.sort(
      (a, b) => widget.options.config.sortCommentsAscending
          ? a.createdAt.compareTo(b.createdAt)
          : b.createdAt.compareTo(a.createdAt),
    );

    return Stack(
      children: [
        RefreshIndicator(
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
              padding: widget.options.postTheme.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (post.creator != null)
                        InkWell(
                          onTap: widget.onUserTap != null
                              ? () =>
                                  widget.onUserTap?.call(post.creator!.userId)
                              : null,
                          child: Row(
                            children: [
                              if (post.creator!.imageUrl != null) ...[
                                widget.options.postTheme.userAvatarBuilder
                                        ?.call(
                                      post.creator!,
                                      40,
                                    ) ??
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        post.creator!.imageUrl!,
                                      ),
                                    ),
                              ] else ...[
                                widget.options.postTheme.anonymousAvatarBuilder
                                        ?.call(
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
                                widget.options.postTheme.nameBuilder
                                        ?.call(post.creator) ??
                                    post.creator?.fullName ??
                                    widget.options.translations.anonymousUser,
                                style: widget.options.textStyles
                                        .postCreatorTitleStyle ??
                                    theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      if (widget.options.config.allowAllDeletion ||
                          post.creator?.userId == widget.userId)
                        PopupMenuButton(
                          onSelected: (value) => widget.onPostDelete(),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Text(
                                    widget.options.translations.deletePost,
                                    style: widget.options.textStyles
                                            .deletePostStyle ??
                                        theme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(width: 8),
                                  widget.options.postTheme.iconTheme
                                          .deleteIcon ??
                                      Icon(
                                        Icons.delete,
                                        color: widget.options.postTheme
                                            .iconTheme.iconColor,
                                      ),
                                ],
                              ),
                            ),
                          ],
                          child: widget.options.postTheme.iconTheme.moreIcon ??
                              Icon(
                                Icons.more_horiz_rounded,
                                color: widget
                                    .options.postTheme.iconTheme.iconColor,
                              ),
                        ),
                    ],
                  ),
                  // image of the post
                  if (post.imageUrl != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: widget.options.postConfig.doubleTapTolike
                          ? TappableImage(
                              likeAndDislikeIcon: widget.options.postTheme
                                  .iconTheme.likeAndDislikeIconsForDoubleTap,
                              post: post,
                              userId: widget.userId,
                              onLike: ({required bool liked}) async {
                                var userId = widget.userId;

                                late TimelinePost result;

                                if (!liked) {
                                  result =
                                      await widget.service.postService.likePost(
                                    userId,
                                    post,
                                  );
                                } else {
                                  result = await widget.service.postService
                                      .unlikePost(
                                    userId,
                                    post,
                                  );
                                }

                                await loadPostDetails();

                                return result.likedBy?.contains(userId) ??
                                    false;
                              },
                            )
                          : CachedNetworkImage(
                              width: double.infinity,
                              imageUrl: post.imageUrl!,
                              fit: BoxFit.fitHeight,
                            ),
                    ),
                  ],
                  const SizedBox(
                    height: 8,
                  ),
                  // post information
                  Row(
                    children: [
                      if (post.likedBy?.contains(widget.userId) ?? false) ...[
                        InkWell(
                          onTap: () async {
                            updatePost(
                              await widget.service.postService.unlikePost(
                                widget.userId,
                                post,
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child:
                                widget.options.postTheme.iconTheme.likedIcon ??
                                    Icon(
                                      Icons.thumb_up_rounded,
                                      color: widget.options.postTheme.iconTheme
                                          .iconColor,
                                    ),
                          ),
                        ),
                      ] else ...[
                        InkWell(
                          onTap: () async {
                            updatePost(
                              await widget.service.postService.likePost(
                                widget.userId,
                                post,
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child:
                                widget.options.postTheme.iconTheme.likeIcon ??
                                    Icon(
                                      Icons.thumb_up_alt_outlined,
                                      color: widget.options.postTheme.iconTheme
                                          .iconColor,
                                      size: widget.options.postTheme.iconSize,
                                    ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      if (post.reactionEnabled)
                        widget.options.postTheme.iconTheme.commentIcon ??
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color:
                                  widget.options.postTheme.iconTheme.iconColor,
                              size: widget.options.postTheme.iconSize,
                            ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${post.likes} ${widget.options.translations.likesTitle}',
                    style: widget.options.textStyles.postLikeTitleAndAmount ??
                        theme.textTheme.titleSmall
                            ?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      text: widget.options.postTheme.nameBuilder
                              ?.call(post.creator) ??
                          post.creator?.fullName ??
                          widget.options.translations.anonymousUser,
                      style: widget.options.textStyles.postCreatorNameStyle ??
                          theme.textTheme.titleSmall,
                      children: [
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: post.title,
                          style: widget.options.textStyles.postTitleStyle ??
                              theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Html(
                    data: post.content,
                    style: {
                      'body': Style(
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      '#': Style(
                        maxLines: 3,
                        textOverflow: TextOverflow.ellipsis,
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      'H1': Style(
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      'H2': Style(
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      'H3': Style(
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dateFormat.format(post.createdAt)} '
                    '${widget.options.translations.postAt} '
                    '${timeFormat.format(post.createdAt)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  if (post.reactionEnabled) ...[
                    Text(
                      widget.options.translations.commentsTitle,
                      style: theme.textTheme.displaySmall,
                    ),
                    for (var reaction
                        in post.reactions ?? <TimelinePostReaction>[]) ...[
                      const SizedBox(height: 16),
                      GestureDetector(
                        onLongPressStart: (details) async {
                          if (reaction.creatorId == widget.userId ||
                              widget.options.config.allowAllDeletion) {
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
                        child: Row(
                          crossAxisAlignment: reaction.imageUrl != null
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          children: [
                            if (reaction.creator?.imageUrl != null &&
                                reaction.creator!.imageUrl!.isNotEmpty) ...[
                              widget.options.postTheme.userAvatarBuilder?.call(
                                    reaction.creator!,
                                    25,
                                  ) ??
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: CachedNetworkImageProvider(
                                      reaction.creator!.imageUrl!,
                                    ),
                                  ),
                            ] else ...[
                              widget.options.postTheme.anonymousAvatarBuilder
                                      ?.call(
                                    reaction.creator!,
                                    25,
                                  ) ??
                                  const CircleAvatar(
                                    radius: 20,
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
                                      widget.options.postTheme.nameBuilder
                                              ?.call(post.creator) ??
                                          reaction.creator?.fullName ??
                                          widget.options.translations
                                              .anonymousUser,
                                      style: theme.textTheme.titleSmall,
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
                                    text: widget.options.postTheme.nameBuilder
                                            ?.call(post.creator) ??
                                        reaction.creator?.fullName ??
                                        widget
                                            .options.translations.anonymousUser,
                                    style: theme.textTheme.titleSmall,
                                    children: [
                                      const TextSpan(text: '  '),
                                      TextSpan(
                                        text: reaction.reaction ?? '',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      // text should go to new line
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (post.reactions?.isEmpty ?? true) ...[
                      const SizedBox(height: 16),
                      Text(
                        widget.options.translations.firstComment,
                      ),
                    ],
                    const SizedBox(height: 120),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (post.reactionEnabled)
          Align(
            alignment: Alignment.bottomCenter,
            child: ReactionBottom(
              messageInputBuilder: textInputBuilder,
              onPressSelectImage: () async {
                // open the image picker
                var result = await showModalBottomSheet<Uint8List?>(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(8.0),
                    color: theme.colorScheme.background,
                    child: ImagePicker(
                      config: widget.options.imagePickerConfig,
                      theme: widget.options.imagePickerTheme,
                    ),
                  ),
                );
                if (result != null) {
                  updatePost(
                    await widget.service.postService.reactToPost(
                      post,
                      TimelinePostReaction(
                        id: '',
                        postId: post.id,
                        creatorId: widget.userId,
                        createdAt: DateTime.now(),
                      ),
                      image: result,
                    ),
                  );
                }
              },
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
              iconColor: widget.options.postTheme.iconTheme.iconColor,
            ),
          ),
      ],
    );
  }
}
