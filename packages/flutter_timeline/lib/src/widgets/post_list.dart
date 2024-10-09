import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";
import "package:flutter_timeline/src/widgets/timeline_post.dart";
import "package:timeline_repository_interface/timeline_repository_interface.dart";

class PostList extends StatelessWidget {
  const PostList({
    required this.controller,
    required this.posts,
    required this.timelineService,
    required this.options,
    required this.onTapPost,
    required this.currentUserId,
    required this.onTapComments,
    super.key,
  });

  final ScrollController controller;
  final List<TimelinePost> posts;
  final TimelineService timelineService;
  final TimelineOptions options;
  final Function(TimelinePost post) onTapPost;
  final String currentUserId;
  final Function(TimelinePost post) onTapComments;

  @override
  Widget build(BuildContext context) => Expanded(
        child: ListView.builder(
          controller: controller,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            posts.sort(
              (b, a) => a.createdAt.compareTo(b.createdAt),
            );
            var post = posts[index];
            // var post = posts[index];
            return options.postBuilder?.call(
                  context: context,
                  onTap: onTapPost,
                  post: post,
                ) ??
                TimelinePostWidget(
                  timelineService: timelineService,
                  currentUserId: currentUserId,
                  onTapPost: onTapPost,
                  options: options,
                  post: post,
                  onTapComments: onTapComments,
                );
          },
        ),
      );
}
