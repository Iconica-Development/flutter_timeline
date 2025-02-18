import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";

class TimelinePostWidget extends StatefulWidget {
  const TimelinePostWidget({
    required this.post,
    required this.timelineService,
    required this.options,
    required this.currentUserId,
    required this.onTapPost,
    required this.onTapComments,
    this.isInDetailView = false,
    this.isInPostOverview = false,
    super.key,
  });

  final TimelinePost post;
  final TimelineService timelineService;
  final TimelineOptions options;
  final String currentUserId;
  final Function(TimelinePost post) onTapPost;
  final bool isInDetailView;
  final Function(TimelinePost post) onTapComments;
  final bool isInPostOverview;

  @override
  State<TimelinePostWidget> createState() => _TimelinePostWidgetState();
}

class _TimelinePostWidgetState extends State<TimelinePostWidget> {
  bool imageError = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var translations = widget.options.translations;
    var user = widget.post.creator;
    var options = widget.options;
    var post = widget.post;
    var isLikedByCurrentUser =
        widget.post.likedBy?.contains(widget.currentUserId) ?? false;
    var likesTitle = widget.post.likes == 1
        ? translations.oneLikeTitle
        : translations.multipleLikesTitle;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: widget.isInDetailView ? 100 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  options.userAvatarBuilder.call(user, 24),
                  const SizedBox(width: 8),
                  options.userNameBuilder
                      .call(user, options.translations.anonymousUser, context),
                ],
              ),
              if (post.creatorId == widget.currentUserId &&
                  !widget.isInPostOverview)
                MoreOptionsButton(
                  timelineService: widget.timelineService,
                  options: options,
                  post: post,
                ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          if (post.imageUrl != null || post.image != null) ...[
            if (options.doubleTapToLike) ...[
              TappableImage(
                post: post,
                onLike: () async {
                  if (isLikedByCurrentUser) {
                    widget.options.onTapUnlike ??
                        widget.timelineService.unlikePost(
                          widget.post.id,
                          widget.currentUserId,
                        );
                    setState(() {});
                    return true;
                  } else {
                    widget.options.onTapLike ??
                        widget.timelineService.likePost(
                          widget.post.id,
                          widget.currentUserId,
                        );
                    setState(() {});
                    return false;
                  }
                },
                userId: widget.currentUserId,
                likeAndDislikeIcon: (
                  Icon(options.likeIcon),
                  Icon(options.likedIcon)
                ),
              ),
            ] else ...[
              if (post.imageUrl != null)
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: imageError
                        ? DecorationImage(
                            image: options.placeholderImageAssetUrl != null
                                ? AssetImage(
                                    options.placeholderImageAssetUrl!,
                                  )
                                : const AssetImage(
                                    "assets/error_image.png",
                                    package: "flutter_timeline",
                                  ),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            onError: (exception, stackTrace) {
                              setState(() {
                                imageError = true;
                              });
                            },
                            image: CachedNetworkImageProvider(
                              widget.post.imageUrl!,
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              if (post.image != null)
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: MemoryImage(widget.post.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ],
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Builder(
                builder: (context) {
                  var postIsLikedByCurrentUser =
                      post.likedBy?.contains(widget.currentUserId) ?? false;
                  return IconButton(
                    iconSize: options.iconSize,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      postIsLikedByCurrentUser
                          ? widget.options.likedIcon
                          : widget.options.likeIcon,
                    ),
                    onPressed: () async {
                      if (postIsLikedByCurrentUser) {
                        await widget.timelineService.unlikePost(
                          post.id,
                          widget.currentUserId,
                        );
                      } else {
                        await widget.timelineService.likePost(
                          widget.post.id,
                          widget.currentUserId,
                        );
                      }
                      setState(() {});
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
              if (post.reactionEnabled) ...[
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    options.commentIcon,
                    size: options.iconSize,
                    color: options.iconColor,
                  ),
                  onPressed: () {
                    widget.onTapComments(widget.post);
                  },
                ),
              ],
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          if (!widget.isInPostOverview) ...[
            Text(
              "${widget.post.likes} $likesTitle",
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.black,
              ),
            ),
          ],
          Row(
            children: [
              options.userNameBuilder.call(
                user,
                options.translations.anonymousUser,
                context,
              ),
              const SizedBox(width: 4),
              Text(
                widget.post.title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          if (widget.isInDetailView) ...[
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.post.content,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.black,
              ),
            ),
            Text(
              widget.options.dateFormat(context).format(widget.post.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            if (widget.post.reactionEnabled)
              if (!widget.isInPostOverview)
                CommentSection(
                  options: options,
                  post: post,
                  currentUserId: widget.currentUserId,
                  timelineService: widget.timelineService,
                ),
          ],
          if (!widget.isInDetailView)
            InkWell(
              onTap: () => widget.onTapPost(widget.post),
              child: Text(
                translations.viewPostTitle,
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: Colors.black.withOpacity(0.5)),
              ),
            ),
        ],
      ),
    );
  }
}
