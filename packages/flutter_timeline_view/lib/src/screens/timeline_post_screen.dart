// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_picker/flutter_image_picker.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/reaction_bottom.dart';
import 'package:intl/intl.dart';

class TimelinePostScreen extends StatefulWidget {
  const TimelinePostScreen({
    required this.userId,
    required this.service,
    required this.userService,
    required this.options,
    required this.post,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    super.key,
  });

  /// The user id of the current user
  final String userId;

  /// The timeline service to fetch the post details
  final TimelineService service;

  /// The user service to fetch the profile picture of the user
  final TimelineUserService userService;

  /// Options to configure the timeline screens
  final TimelineOptions options;

  /// The post to show
  final TimelinePost post;

  /// The padding around the screen
  final EdgeInsets padding;

  @override
  State<TimelinePostScreen> createState() => _TimelinePostScreenState();
}

class _TimelinePostScreenState extends State<TimelinePostScreen> {
  TimelinePost? post;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(loadPostDetails());
  }

  Future<void> loadPostDetails() async {
    try {
      // Assuming fetchPostDetails is an async function returning a TimelinePost
      var loadedPost = await widget.service.fetchPostDetails(widget.post);
      setState(() {
        post = loadedPost;
        isLoading = false;
      });
    } on Exception catch (e) {
      // Handle any errors here
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
    var dateFormat = widget.options.dateformat ??
        DateFormat('dd/MM/yyyy', Localizations.localeOf(context).languageCode);
    var timeFormat = widget.options.timeFormat ?? DateFormat('HH:mm');
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (this.post == null) {
      return Center(
        child: Text(widget.options.translations.postLoadingError),
      );
    }
    var post = this.post!;
    post.reactions?.sort(
      (a, b) => widget.options.sortCommentsAscending
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt),
    );

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.creator != null)
                  Row(
                    children: [
                      if (post.creator!.imageUrl != null) ...[
                        widget.options.userAvatarBuilder?.call(
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

                      // three small dots at the end
                      const Spacer(),
                      const Icon(Icons.more_horiz),
                    ],
                  ),
                const SizedBox(height: 8),
                // image of the post
                if (post.imageUrl != null) ...[
                  CachedNetworkImage(
                    imageUrl: post.imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                ],
                // post information
                Row(
                  children: [
                    // like icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up_rounded),
                    ),
                    // comment icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${post.likes} ${widget.options.translations.likesTitle}',
                  style: theme.textTheme.titleSmall,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      post.creator?.fullName ?? '',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post.title,
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
                Text(
                  post.content,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${dateFormat.format(post.createdAt)} '
                  '${widget.options.translations.postAt} '
                  '${timeFormat.format(post.createdAt)}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                if (post.reactionEnabled) ...[
                  Text(
                    widget.options.translations.commentsTitle,
                    style: theme.textTheme.displaySmall,
                  ),
                  for (var reaction
                      in post.reactions ?? <TimelinePostReaction>[]) ...[
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: reaction.imageUrl != null
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        if (reaction.creator?.imageUrl != null &&
                            reaction.creator!.imageUrl!.isNotEmpty) ...[
                          widget.options.userAvatarBuilder?.call(
                                reaction.creator!,
                                25,
                              ) ??
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                  reaction.creator!.imageUrl!,
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
                                  reaction.creator?.fullName ??
                                      widget.options.translations.anonymousUser,
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
                                text: reaction.creator?.fullName ??
                                    widget.options.translations.anonymousUser,
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
                  ],
                  const SizedBox(height: 120),
                ],
              ],
            ),
          ),
        ),
        if (post.reactionEnabled)
          Align(
            alignment: Alignment.bottomCenter,
            child: ReactionBottom(
              messageInputBuilder: widget.options.textInputBuilder!,
              onPressSelectImage: () async {
                // open the image picker
                var result = await showModalBottomSheet<Uint8List?>(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.black,
                    child: ImagePicker(
                      imagePickerConfig: widget.options.imagePickerConfig,
                      imagePickerTheme: widget.options.imagePickerTheme,
                    ),
                  ),
                );
                if (result != null) {
                  updatePost(
                    await widget.service.reactToPost(
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
                await widget.service.reactToPost(
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
      ],
    );
  }
}
