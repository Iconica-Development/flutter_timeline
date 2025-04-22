import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    required this.service,
    required this.options,
    required this.userId,
    required this.post,
    required this.allowDeletion,
    required this.onUserTap,
    required this.onPostDelete,
    super.key,
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
                        backgroundImage:
                            CachedNetworkImageProvider(post.creator!.imageUrl!),
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
