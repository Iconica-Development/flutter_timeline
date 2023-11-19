import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/src/config/timeline_options.dart';

class TimelinePostWidget extends StatelessWidget {
  const TimelinePostWidget({
    required this.options,
    required this.post,
    required this.height,
    this.onTap,
    super.key,
  });

  final TimelineOptions options;

  final TimelinePost post;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: double.infinity,
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
              Flexible(
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
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
              options.translations.viewPost,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
