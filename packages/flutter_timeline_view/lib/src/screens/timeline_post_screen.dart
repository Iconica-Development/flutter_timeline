// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';
import 'package:flutter_timeline_view/src/widgets/reaction_bottom.dart';
import 'package:intl/intl.dart';

class TimelinePostScreen extends StatelessWidget {
  const TimelinePostScreen({
    required this.options,
    required this.post,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    super.key,
  });

  final TimelineOptions options;

  final TimelinePost post;

  /// The padding around the screen
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var dateFormat = options.dateformat ??
        DateFormat('dd/MM/yyyy', Localizations.localeOf(context).languageCode);
    var timeFormat = options.timeFormat ?? DateFormat('HH:mm');
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.creator != null)
                  Row(
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
                  '${post.likes} ${options.translations.likesTitle}',
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
                  '${options.translations.postAt} '
                  '${timeFormat.format(post.createdAt)}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),

                Text(
                  options.translations.commentsTitle,
                  style: theme.textTheme.displaySmall,
                ),
                for (var reaction
                    in post.reactions ?? <TimelinePostReaction>[]) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (reaction.creator?.imageUrl != null &&
                          reaction.creator!.imageUrl!.isNotEmpty) ...[
                        options.userAvatarBuilder?.call(
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
                      if (reaction.creator?.fullName != null) ...[
                        Text(
                          reaction.creator!.fullName!,
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                      const SizedBox(width: 10),
                      // TODO(anyone): show image if the user send one
                      Expanded(
                        child: Text(
                          reaction.reaction ?? '',
                          style: theme.textTheme.bodyMedium,
                          // text should go to new line
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ReactionBottom(
            messageInputBuilder: options.textInputBuilder!,
            onPressSelectImage: () async {},
            onReactionSubmit: (reaction) async {},
            translations: options.translations,
            iconColor: options.theme.iconColor,
          ),
        ),
      ],
    );
  }
}
