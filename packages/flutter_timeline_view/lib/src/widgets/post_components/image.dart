import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';
import 'package:flutter_timeline_view/flutter_timeline_view.dart';
import 'package:flutter_timeline_view/src/widgets/tappable_image.dart';

class PostImage extends StatelessWidget {
  const PostImage({
    required this.options,
    required this.service,
    required this.userId,
    required this.post,
    this.flexible = true,
    this.onUpdatePost,
    super.key,
  });

  final TimelineOptions options;
  final TimelineService service;
  final String userId;
  final TimelinePost post;
  final bool flexible;

  final VoidCallback? onUpdatePost;

  @override
  Widget build(BuildContext context) {
    var body = ClipRRect(
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

                onUpdatePost?.call();

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
    );

    if (!flexible) return body;

    return Flexible(
      flex: options.postWidgetHeight != null ? 1 : 0,
      child: body,
    );
  }
}
